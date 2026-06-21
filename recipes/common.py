from __future__ import annotations

import os
import platform
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Callable, TypeAlias


CommandArg: TypeAlias = str | os.PathLike[str]
Logger: TypeAlias = Callable[[str], None]
DEFAULT_MACOS_DEPLOYMENT_TARGET = "15.0"


@dataclass(frozen=True)
class HostPlatform:
    os_name: str
    arch: str

    @property
    def key(self) -> str:
        return f"{self.os_name}-{self.arch}"

    @property
    def bindgen_exe_name(self) -> str:
        return "bindgen.exe" if self.os_name == "windows" else "bindgen"

    @property
    def upstream_arch_token(self) -> str:
        return "x64" if self.arch == "amd64" else self.arch

    def library_dir(self, package_dir: Path) -> Path:
        return package_dir / "libs" / self.os_name / self.arch

    def tool_dir(self, root: Path) -> Path:
        return root / ".thirdparty-tools" / "bindgen" / self.key


def make_logger(recipe_name: str) -> Logger:
    def log(message: str) -> None:
        print(f"[{recipe_name}] {message}", flush=True)

    return log


def detect_platform() -> HostPlatform:
    system = platform.system().lower()
    machine = platform.machine().lower()
    os_name = {
        "windows": "windows",
        "darwin": "darwin",
        "linux": "linux",
    }.get(system)
    arch = {
        "amd64": "amd64",
        "x86_64": "amd64",
        "arm64": "arm64",
        "aarch64": "arm64",
    }.get(machine)
    if not os_name or not arch:
        raise SystemExit(f"Unsupported platform: {platform.system()} {platform.machine()}")
    return HostPlatform(os_name=os_name, arch=arch)


def command_exists(command: str) -> bool:
    return shutil.which(command) is not None


def run(
    command: list[CommandArg],
    cwd: Path | None = None,
    env: dict[str, str] | None = None,
    log: Logger | None = None,
) -> None:
    if log is not None:
        log("+ " + " ".join(os.fspath(arg) for arg in command))
    subprocess.run(command, cwd=cwd, env=env, check=True)


def copy_newer(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists() and destination.stat().st_mtime >= source.stat().st_mtime:
        return
    shutil.copy2(source, destination)


def resolve_bindgen(host: HostPlatform, root: Path) -> Path:
    candidates = []
    env_bindgen = os.environ.get("BINDGEN_EXE")
    if env_bindgen:
        candidates.append(Path(env_bindgen))

    candidates.append(host.tool_dir(root) / host.bindgen_exe_name)

    path_bindgen = shutil.which("bindgen")
    if path_bindgen:
        candidates.append(Path(path_bindgen))

    for candidate in candidates:
        if candidate.exists():
            return candidate.resolve()

    raise FileNotFoundError(
        "Missing bindgen executable. Run `just bootstrap-tools`, install bindgen on PATH, "
        "or set BINDGEN_EXE."
    )


def macos_deployment_target() -> str:
    return os.environ.get("MACOSX_DEPLOYMENT_TARGET", DEFAULT_MACOS_DEPLOYMENT_TARGET)


def build_environment(host: HostPlatform) -> dict[str, str]:
    env = os.environ.copy()
    if host.os_name == "darwin":
        env.setdefault("MACOSX_DEPLOYMENT_TARGET", macos_deployment_target())
        env["PATH"] = f"/usr/bin{os.pathsep}{env.get('PATH', '')}"
    return env


def bindgen_environment(host: HostPlatform) -> dict[str, str]:
    env = build_environment(host)
    if host.os_name != "darwin":
        return env

    sdkroot = env.get("SDKROOT")
    if not sdkroot and command_exists("xcrun"):
        result = subprocess.run(
            ["xcrun", "--show-sdk-path"],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
        )
        sdkroot = result.stdout.strip()
        env["SDKROOT"] = sdkroot

    if sdkroot:
        include_dir = Path(sdkroot) / "usr" / "include"
        if include_dir.exists():
            existing = env.get("CPATH")
            env["CPATH"] = str(include_dir) if not existing else f"{include_dir}{os.pathsep}{existing}"

    return env


def run_bindgen_checked(command: list[CommandArg], cwd: Path, env: dict[str, str], log: Logger | None = None) -> None:
    if log is not None:
        log("+ " + " ".join(os.fspath(arg) for arg in command))
    completed = subprocess.run(
        command,
        cwd=cwd,
        env=env,
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    if completed.stdout:
        print(completed.stdout, end="")
    if completed.returncode != 0:
        raise subprocess.CalledProcessError(completed.returncode, command)
    if "[ERROR]" in completed.stdout or "[FATAL]" in completed.stdout:
        raise RuntimeError("bindgen reported parse errors; refusing to sync partial bindings.")
