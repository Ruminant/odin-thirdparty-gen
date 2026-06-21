package capstone

import "core:c"

when ODIN_OS == .Windows {
	when #config(CAPSTONE_STATIC, false) {
		foreign import lib "libs/windows/amd64/capstone_static.lib"
	} else {
		foreign import lib "libs/windows/amd64/capstone.lib"
	}
} else when ODIN_OS == .Darwin {
	when ODIN_ARCH == .arm64 {
		when #config(CAPSTONE_STATIC, false) {
			foreign import lib "libs/darwin/arm64/libcapstone_static.a"
		} else {
			foreign import lib "libs/darwin/arm64/libcapstone.dylib"
		}
	} else when ODIN_ARCH == .amd64 {
		when #config(CAPSTONE_STATIC, false) {
			foreign import lib "libs/darwin/amd64/libcapstone_static.a"
		} else {
			foreign import lib "libs/darwin/amd64/libcapstone.dylib"
		}
	}
} else {
	foreign import lib "system:capstone"
}

_ :: lib


// Capstone API version
API_MAJOR :: 5
API_MINOR :: 0

// Version for bleeding edge code of the Github's "next" branch.
// Use this if you want the absolutely latest development code.
// This version number will be bumped up whenever we have a new major change.
NEXT_VERSION :: 5

// Capstone package version
VERSION_MAJOR :: API_MAJOR
VERSION_MINOR :: API_MINOR
VERSION_EXTRA :: 9

// Pre-release identifier.
// A stable release.
VERSION_STABLE :: 0xffff

// The postfix version: Alpha1, Alpha2, ..., Beta1, ...
VERSION_ALPHA  :: 0xa000
VERSION_ALPHA9 :: (VERSION_ALPHA|9)
VERSION_BETA   :: 0xb000
VERSION_BETA1  :: (VERSION_BETA|1)

// The identifier of a pre-release (Alpha, Beta, ...).
// It is set to CS_VERSION_STABLE, if this code is part of a stable release.
VERSION_PRE_RELEASE :: VERSION_STABLE

/// Maximum size of an instruction mnemonic string.
MNEMONIC_SIZE :: 32

// Handle using with all API
csh :: c.size_t

/// Architecture type
arch :: enum i32 {
	ARM        = 0,     ///< ARM architecture (including Thumb, Thumb-2)
	ARM64      = 1,     ///< ARM-64, also called AArch64
	MIPS       = 2,     ///< Mips architecture
	X86        = 3,     ///< X86 architecture (including x86 & x86-64)
	PPC        = 4,     ///< PowerPC architecture
	SPARC      = 5,     ///< Sparc architecture
	SYSZ       = 6,     ///< SystemZ architecture
	XCORE      = 7,     ///< XCore architecture
	M68K       = 8,     ///< 68K architecture
	TMS320C64X = 9,     ///< TMS320C64x architecture
	M680X      = 10,    ///< 680X architecture
	EVM        = 11,    ///< Ethereum architecture
	MOS65XX    = 12,    ///< MOS65XX architecture (including MOS6502)
	WASM       = 13,    ///< WebAssembly architecture
	BPF        = 14,    ///< Berkeley Packet Filter architecture (including eBPF)
	RISCV      = 15,    ///< RISCV architecture
	SH         = 16,    ///< SH architecture
	TRICORE    = 17,    ///< TriCore architecture
	MAX        = 18,
	ALL        = 65535, // All architectures - for cs_support()
}

/// Mode type
mode :: enum i32 {
	LITTLE_ENDIAN         = 0,           ///< little-endian mode (default mode)
	ARM                   = 0,           ///< 32-bit ARM
	_16                   = 2,           ///< 16-bit mode (X86)
	_32                   = 4,           ///< 32-bit mode (X86)
	_64                   = 8,           ///< 64-bit mode (X86, PPC)
	THUMB                 = 16,          ///< ARM's Thumb mode, including Thumb-2
	MCLASS                = 32,          ///< ARM's Cortex-M series
	V8                    = 64,          ///< ARMv8 A32 encodings for ARM
	MICRO                 = 16,          ///< MicroMips mode (MIPS)
	MIPS3                 = 32,          ///< Mips III ISA
	MIPS32R6              = 64,          ///< Mips32r6 ISA
	MIPS2                 = 128,         ///< Mips II ISA
	V9                    = 16,          ///< SparcV9 mode (Sparc)
	QPX                   = 16,          ///< Quad Processing eXtensions mode (PPC)
	SPE                   = 32,          ///< Signal Processing Engine mode (PPC)
	BOOKE                 = 64,          ///< Book-E mode (PPC)
	PS                    = 128,         ///< Paired-singles mode (PPC)
	M68K_000              = 2,           ///< M68K 68000 mode
	M68K_010              = 4,           ///< M68K 68010 mode
	M68K_020              = 8,           ///< M68K 68020 mode
	M68K_030              = 16,          ///< M68K 68030 mode
	M68K_040              = 32,          ///< M68K 68040 mode
	M68K_060              = 64,          ///< M68K 68060 mode
	BIG_ENDIAN            = -2147483648, ///< big-endian mode
	MIPS32                = 4,           ///< Mips32 ISA (Mips)
	MIPS64                = 8,           ///< Mips64 ISA (Mips)
	M680X_6301            = 2,           ///< M680X Hitachi 6301,6303 mode
	M680X_6309            = 4,           ///< M680X Hitachi 6309 mode
	M680X_6800            = 8,           ///< M680X Motorola 6800,6802 mode
	M680X_6801            = 16,          ///< M680X Motorola 6801,6803 mode
	M680X_6805            = 32,          ///< M680X Motorola/Freescale 6805 mode
	M680X_6808            = 64,          ///< M680X Motorola/Freescale/NXP 68HC08 mode
	M680X_6809            = 128,         ///< M680X Motorola 6809 mode
	M680X_6811            = 256,         ///< M680X Motorola/Freescale/NXP 68HC11 mode
	M680X_CPU12           = 512,         ///< M680X Motorola/Freescale/NXP CPU12

	///< used on M68HC12/HCS12
	M680X_HCS08           = 1024,        ///< M680X Freescale/NXP HCS08 mode
	BPF_CLASSIC           = 0,           ///< Classic BPF mode (default)
	BPF_EXTENDED          = 1,           ///< Extended BPF mode
	RISCV32               = 1,           ///< RISCV RV32G
	RISCV64               = 2,           ///< RISCV RV64G
	RISCVC                = 4,           ///< RISCV compressed instructure mode
	MOS65XX_6502          = 2,           ///< MOS65XXX MOS 6502
	MOS65XX_65C02         = 4,           ///< MOS65XXX WDC 65c02
	MOS65XX_W65C02        = 8,           ///< MOS65XXX WDC W65c02
	MOS65XX_65816         = 16,          ///< MOS65XXX WDC 65816, 8-bit m/x
	MOS65XX_65816_LONG_M  = 32,          ///< MOS65XXX WDC 65816, 16-bit m, 8-bit x
	MOS65XX_65816_LONG_X  = 64,          ///< MOS65XXX WDC 65816, 8-bit m, 16-bit x
	MOS65XX_65816_LONG_MX = 96,
	SH2                   = 2,           ///< SH2
	SH2A                  = 4,           ///< SH2A
	SH3                   = 8,           ///< SH3
	SH4                   = 16,          ///< SH4
	SH4A                  = 32,          ///< SH4A
	SHFPU                 = 64,          ///< w/ FPU
	SHDSP                 = 128,         ///< w/ DSP
	TRICORE_110           = 2,           ///< Tricore 1.1
	TRICORE_120           = 4,           ///< Tricore 1.2
	TRICORE_130           = 8,           ///< Tricore 1.3
	TRICORE_131           = 16,          ///< Tricore 1.3.1
	TRICORE_160           = 32,          ///< Tricore 1.6
	TRICORE_161           = 64,          ///< Tricore 1.6.1
	TRICORE_162           = 128,         ///< Tricore 1.6.2
}

malloc_t    :: proc "c" (size: c.size_t) -> rawptr
calloc_t    :: proc "c" (nmemb: c.size_t, size: c.size_t) -> rawptr
realloc_t   :: proc "c" (ptr: rawptr, size: c.size_t) -> rawptr
free_t      :: proc "c" (ptr: rawptr)
vsnprintf_t :: proc "c" (str: cstring, size: c.size_t, format: cstring, ap: c.va_list) -> i32

/// User-defined dynamic memory related functions: malloc/calloc/realloc/free/vsnprintf()
/// By default, Capstone uses system's malloc(), calloc(), realloc(), free() & vsnprintf().
opt_mem :: struct {
	malloc:    malloc_t,
	calloc:    calloc_t,
	realloc:   realloc_t,
	free:      free_t,
	vsnprintf: vsnprintf_t,
}

/// Customize mnemonic for instructions with alternative name.
/// To reset existing customized instruction to its default mnemonic,
/// call cs_option(CS_OPT_MNEMONIC) again with the same @id and NULL value
/// for @mnemonic.
opt_mnem :: struct {
	/// ID of instruction to be customized.
	id: u32,

	/// Customized instruction mnemonic.
	mnemonic: cstring,
}

/// Runtime option for the disassembled engine
opt_type :: enum i32 {
	INVALID          = 0, ///< No option specified
	SYNTAX           = 1, ///< Assembly output syntax
	DETAIL           = 2, ///< Break down instruction structure into details
	MODE             = 3, ///< Change engine's mode at run-time
	MEM              = 4, ///< User-defined dynamic memory related functions
	SKIPDATA         = 5, ///< Skip data when disassembling. Then engine is in SKIPDATA mode.
	SKIPDATA_SETUP   = 6, ///< Setup user-defined function for SKIPDATA option
	MNEMONIC         = 7, ///< Customize instruction mnemonic
	UNSIGNED         = 8, ///< print immediate operands in unsigned form
	NO_BRANCH_OFFSET = 9, ///< ARM, prints branch immediates without offset.
}

/// Runtime option value (associated with option type above)
opt_value :: enum i32 {
	OFF              = 0, ///< Turn OFF an option - default for CS_OPT_DETAIL, CS_OPT_SKIPDATA, CS_OPT_UNSIGNED.
	ON               = 3, ///< Turn ON an option (CS_OPT_DETAIL, CS_OPT_SKIPDATA).
	SYNTAX_DEFAULT   = 0, ///< Default asm syntax (CS_OPT_SYNTAX).
	SYNTAX_INTEL     = 1, ///< X86 Intel asm syntax - default on X86 (CS_OPT_SYNTAX).
	SYNTAX_ATT       = 2, ///< X86 ATT asm syntax (CS_OPT_SYNTAX).
	SYNTAX_NOREGNAME = 3, ///< Prints register name with only number (CS_OPT_SYNTAX)
	SYNTAX_MASM      = 4, ///< X86 Intel Masm syntax (CS_OPT_SYNTAX).
	SYNTAX_MOTOROLA  = 5, ///< MOS65XX use $ as hex prefix
}

/// Common instruction operand types - to be consistent across all architectures.
op_type :: enum i32 {
	INVALID = 0, ///< uninitialized/invalid operand.
	REG     = 1, ///< Register operand.
	IMM     = 2, ///< Immediate operand.
	MEM     = 3, ///< Memory operand. Can be ORed with another operand type.
	FP      = 4, ///< Floating-Point operand.
}

/// Common instruction operand access types - to be consistent across all architectures.
/// It is possible to combine access types, for example: CS_AC_READ | CS_AC_WRITE
ac_type :: enum i32 {
	INVALID = 0, ///< Uninitialized/invalid access type.
	READ    = 1, ///< Operand read from memory or register.
	WRITE   = 2, ///< Operand write to memory or register.
}

/// Common instruction groups - to be consistent across all architectures.
group_type :: enum i32 {
	INVALID         = 0, ///< uninitialized/invalid group.
	JUMP            = 1, ///< all jump instructions (conditional+direct+indirect jumps)
	CALL            = 2, ///< all call instructions
	RET             = 3, ///< all return instructions
	INT             = 4, ///< all interrupt instructions (int+syscall)
	IRET            = 5, ///< all interrupt return instructions
	PRIVILEGE       = 6, ///< all privileged instructions
	BRANCH_RELATIVE = 7, ///< all relative branching instructions
}

/**
User-defined callback function for SKIPDATA option.
See tests/test_skipdata.c for sample code demonstrating this API.

@code: the input buffer containing code to be disassembled.
This is the same buffer passed to cs_disasm().
@code_size: size (in bytes) of the above @code buffer.
@offset: the position of the currently-examining byte in the input
buffer @code mentioned above.
@user_data: user-data passed to cs_option() via @user_data field in
cs_opt_skipdata struct below.

@return: return number of bytes to skip, or 0 to immediately stop disassembling.
*/
skipdata_cb_t :: proc "c" (code: ^u8, code_size: c.size_t, offset: c.size_t, user_data: rawptr) -> c.size_t

/// User-customized setup for SKIPDATA option
opt_skipdata :: struct {
	/// Capstone considers data to skip as special "instructions".
	/// User can specify the string for this instruction's "mnemonic" here.
	/// By default (if @mnemonic is NULL), Capstone use ".byte".
	mnemonic: cstring,

	/// User-defined callback function to be called when Capstone hits data.
	/// If the returned value from this callback is positive (>0), Capstone
	/// will skip exactly that number of bytes & continue. Otherwise, if
	/// the callback returns 0, Capstone stops disassembling and returns
	/// immediately from cs_disasm()
	/// NOTE: if this callback pointer is NULL, Capstone would skip a number
	/// of bytes depending on architectures, as following:
	/// Arm:     2 bytes (Thumb mode) or 4 bytes.
	/// Arm64:   4 bytes.
	/// Mips:    4 bytes.
	/// M680x:   1 byte.
	/// PowerPC: 4 bytes.
	/// Sparc:   4 bytes.
	/// SystemZ: 2 bytes.
	/// X86:     1 bytes.
	/// XCore:   2 bytes.
	/// EVM:     1 bytes.
	/// RISCV:   4 bytes.
	/// WASM:    1 bytes.
	/// MOS65XX: 1 bytes.
	/// BPF:     8 bytes.
	/// TriCore: 2 bytes.
	callback: skipdata_cb_t, // default value is NULL

	/// User-defined data to be passed to @callback function pointer.
	user_data: rawptr,
}

MAX_IMPL_W_REGS :: 20
MAX_IMPL_R_REGS :: 20
MAX_NUM_GROUPS  :: 8

/// NOTE: All information in cs_detail is only available when CS_OPT_DETAIL = CS_OPT_ON
/// Initialized as memset(., 0, offsetof(cs_detail, ARCH)+sizeof(cs_ARCH))
/// by ARCH_getInstruction in arch/ARCH/ARCHDisassembler.c
/// if cs_detail changes, in particular if a field is added after the union,
/// then update arch/ARCH/ARCHDisassembler.c accordingly
detail :: struct {
	regs_read:        [20]u16,
	regs_read_count:  u8,    ///< number of implicit registers read by this insn
	regs_write:       [20]u16,
	regs_write_count: u8,    ///< number of implicit registers modified by this insn
	groups:           [8]u8, ///< list of group this instruction belong to
	groups_count:     u8,    ///< number of groups this insn belongs to
	writeback:        bool,  ///< Instruction has writeback operands.

	/// Architecture-specific instruction info
	using _: struct #raw_union {
		x86:        x86,        ///< X86 architecture, including 16-bit, 32-bit & 64-bit mode
		arm64:      arm64,      ///< ARM64 architecture (aka AArch64)
		arm:        arm,        ///< ARM architecture (including Thumb/Thumb2)
		m68k:       m68k,       ///< M68K architecture
		mips:       mips,       ///< MIPS architecture
		ppc:        ppc,        ///< PowerPC architecture
		sparc:      sparc,      ///< Sparc architecture
		sysz:       sysz,       ///< SystemZ architecture
		xcore:      xcore,      ///< XCore architecture
		tms320c64x: tms320c64x, ///< TMS320C64x architecture
		m680x:      m680x,      ///< M680X architecture
		evm:        evm,        ///< Ethereum architecture
		mos65xx:    mos65xx,    ///< MOS65XX architecture (including MOS6502)
		wasm:       wasm,       ///< Web Assembly architecture
		bpf:        bpf,        ///< Berkeley Packet Filter architecture (including eBPF)
		riscv:      riscv,      ///< RISCV architecture
		sh:         sh,         ///< SH architecture
		tricore:    tricore,    ///< TriCore architecture
	},
}

/// Detail information of disassembled instruction
insn :: struct {
	/// Instruction ID (basically a numeric ID for the instruction mnemonic)
	/// Find the instruction id in the '[ARCH]_insn' enum in the header file
	/// of corresponding architecture, such as 'arm_insn' in arm.h for ARM,
	/// 'x86_insn' in x86.h for X86, etc...
	/// This information is available even when CS_OPT_DETAIL = CS_OPT_OFF
	/// NOTE: in Skipdata mode, "data" instruction has 0 for this id field.
	id: u32,

	/// Address (EIP) of this instruction
	/// This information is available even when CS_OPT_DETAIL = CS_OPT_OFF
	address: u64,

	/// Size of this instruction
	/// This information is available even when CS_OPT_DETAIL = CS_OPT_OFF
	size: u16,

	/// Machine bytes of this instruction, with number of bytes indicated by @size above
	/// This information is available even when CS_OPT_DETAIL = CS_OPT_OFF
	bytes: [24]u8,

	/// Ascii text of instruction mnemonic
	/// This information is available even when CS_OPT_DETAIL = CS_OPT_OFF
	mnemonic: [32]i8,

	/// Ascii text of instruction operands
	/// This information is available even when CS_OPT_DETAIL = CS_OPT_OFF
	op_str: [160]i8,

	/// Pointer to cs_detail.
	/// NOTE: detail pointer is only valid when both requirements below are met:
	/// (1) CS_OP_DETAIL = CS_OPT_ON
	/// (2) Engine is not in Skipdata mode (CS_OP_SKIPDATA option set to CS_OPT_ON)
	///
	/// NOTE 2: when in Skipdata mode, or when detail mode is OFF, even if this pointer
	///     is not NULL, its content is still irrelevant.
	detail: ^detail,
}

/// All type of errors encountered by Capstone API.
/// These are values returned by cs_errno()
err :: enum i32 {
	OK        = 0,  ///< No error: everything was fine
	MEM       = 1,  ///< Out-Of-Memory error: cs_open(), cs_disasm(), cs_disasm_iter()
	ARCH      = 2,  ///< Unsupported architecture: cs_open()
	HANDLE    = 3,  ///< Invalid handle: cs_op_count(), cs_op_index()
	CSH       = 4,  ///< Invalid csh argument: cs_close(), cs_errno(), cs_option()
	MODE      = 5,  ///< Invalid/unsupported mode: cs_open()
	OPTION    = 6,  ///< Invalid/unsupported option: cs_option()
	DETAIL    = 7,  ///< Information is unavailable because detail option is OFF
	MEMSETUP  = 8,  ///< Dynamic memory management uninitialized (see CS_OPT_MEM)
	VERSION   = 9,  ///< Unsupported version (bindings)
	DIET      = 10, ///< Access irrelevant data in "diet" engine
	SKIPDATA  = 11, ///< Access irrelevant data for "data" instruction in SKIPDATA mode
	X86_ATT   = 12, ///< X86 AT&T syntax is unsupported (opt-out at compile time)
	X86_INTEL = 13, ///< X86 Intel syntax is unsupported (opt-out at compile time)
	X86_MASM  = 14, ///< X86 Masm syntax is unsupported (opt-out at compile time)
}

@(default_calling_convention="c", link_prefix="cs_")
foreign lib {
	/**
	Return combined API version & major and minor version numbers.
	
	@major: major number of API version
	@minor: minor number of API version
	
	@return hexical number as (major << 8 | minor), which encodes both
	major & minor versions.
	NOTE: This returned value can be compared with version number made
	with macro CS_MAKE_VERSION
	
	For example, second API version would return 1 in @major, and 1 in @minor
	The return value would be 0x0101
	
	NOTE: if you only care about returned value, but not major and minor values,
	set both @major & @minor arguments to NULL.
	*/
	version :: proc(major: ^i32, minor: ^i32) -> u32 ---

	/**
	This API can be used to either ask for archs supported by this library,
	or check to see if the library was compile with 'diet' option (or called
	in 'diet' mode).
	
	To check if a particular arch is supported by this library, set @query to
	arch mode (CS_ARCH_* value).
	To verify if this library supports all the archs, use CS_ARCH_ALL.
	
	To check if this library is in 'diet' mode, set @query to CS_SUPPORT_DIET.
	
	@return True if this library supports the given arch, or in 'diet' mode.
	*/
	support :: proc(query: i32) -> bool ---

	/**
	Initialize CS handle: this must be done before any usage of CS.
	
	@arch: architecture type (CS_ARCH_*)
	@mode: hardware mode. This is combined of CS_MODE_*
	@handle: pointer to handle, which will be updated at return time
	
	@return CS_ERR_OK on success, or other value on failure (refer to cs_err enum
	for detailed error).
	*/
	open :: proc(arch: arch, mode: mode, handle: ^csh) -> err ---

	/**
	Close CS handle: MUST do to release the handle when it is not used anymore.
	NOTE: this must be only called when there is no longer usage of Capstone,
	not even access to cs_insn array. The reason is the this API releases some
	cached memory, thus access to any Capstone API after cs_close() might crash
	your application.
	
	In fact,this API invalidate @handle by ZERO out its value (i.e *handle = 0).
	
	@handle: pointer to a handle returned by cs_open()
	
	@return CS_ERR_OK on success, or other value on failure (refer to cs_err enum
	for detailed error).
	*/
	close :: proc(handle: ^csh) -> err ---

	/**
	Set option for disassembling engine at runtime
	
	@handle: handle returned by cs_open()
	@type: type of option to be set
	@value: option value corresponding with @type
	
	@return: CS_ERR_OK on success, or other value on failure.
	Refer to cs_err enum for detailed error.
	
	NOTE: in the case of CS_OPT_MEM, handle's value can be anything,
	so that cs_option(handle, CS_OPT_MEM, value) can (i.e must) be called
	even before cs_open()
	*/
	option :: proc(handle: csh, type: opt_type, value: c.size_t) -> err ---

	/**
	Report the last error number when some API function fail.
	Like glibc's errno, cs_errno might not retain its old value once accessed.
	
	@handle: handle returned by cs_open()
	
	@return: error code of cs_err enum type (CS_ERR_*, see above)
	*/
	errno :: proc(handle: csh) -> err ---

	/**
	Return a string describing given error code.
	
	@code: error code (see CS_ERR_* above)
	
	@return: returns a pointer to a string that describes the error code
	passed in the argument @code
	*/
	strerror :: proc(code: err) -> cstring ---

	/**
	Disassemble binary code, given the code buffer, size, address and number
	of instructions to be decoded.
	This API dynamically allocate memory to contain disassembled instruction.
	Resulting instructions will be put into @*insn
	
	NOTE 1: this API will automatically determine memory needed to contain
	output disassembled instructions in @insn.
	
	NOTE 2: caller must free the allocated memory itself to avoid memory leaking.
	
	NOTE 3: for system with scarce memory to be dynamically allocated such as
	OS kernel or firmware, the API cs_disasm_iter() might be a better choice than
	cs_disasm(). The reason is that with cs_disasm(), based on limited available
	memory, we have to calculate in advance how many instructions to be disassembled,
	which complicates things. This is especially troublesome for the case @count=0,
	when cs_disasm() runs uncontrollably (until either end of input buffer, or
	when it encounters an invalid instruction).
	
	@handle: handle returned by cs_open()
	@code: buffer containing raw binary code to be disassembled.
	@code_size: size of the above code buffer.
	@address: address of the first instruction in given raw code buffer.
	@insn: array of instructions filled in by this API.
	NOTE: @insn will be allocated by this function, and should be freed
	with cs_free() API.
	@count: number of instructions to be disassembled, or 0 to get all of them
	
	@return: the number of successfully disassembled instructions,
	or 0 if this function failed to disassemble the given code
	
	On failure, call cs_errno() for error code.
	*/
	disasm :: proc(handle: csh, code: ^u8, code_size: c.size_t, address: u64, count: c.size_t, insn: ^^insn) -> c.size_t ---

	/**
	Free memory allocated by cs_malloc() or cs_disasm() (argument @insn)
	
	@insn: pointer returned by @insn argument in cs_disasm() or cs_malloc()
	@count: number of cs_insn structures returned by cs_disasm(), or 1
	to free memory allocated by cs_malloc().
	*/
	free :: proc(insn: ^insn, count: c.size_t) ---

	/**
	Allocate memory for 1 instruction to be used by cs_disasm_iter().
	
	@handle: handle returned by cs_open()
	
	NOTE: when no longer in use, you can reclaim the memory allocated for
	this instruction with cs_free(insn, 1)
	*/
	malloc :: proc(handle: csh) -> ^insn ---

	/**
	Fast API to disassemble binary code, given the code buffer, size, address
	and number of instructions to be decoded.
	This API puts the resulting instruction into a given cache in @insn.
	See tests/test_iter.c for sample code demonstrating this API.
	
	NOTE 1: this API will update @code, @size & @address to point to the next
	instruction in the input buffer. Therefore, it is convenient to use
	cs_disasm_iter() inside a loop to quickly iterate all the instructions.
	While decoding one instruction at a time can also be achieved with
	cs_disasm(count=1), some benchmarks shown that cs_disasm_iter() can be 30%
	faster on random input.
	
	NOTE 2: the cache in @insn can be created with cs_malloc() API.
	
	NOTE 3: for system with scarce memory to be dynamically allocated such as
	OS kernel or firmware, this API is recommended over cs_disasm(), which
	allocates memory based on the number of instructions to be disassembled.
	The reason is that with cs_disasm(), based on limited available memory,
	we have to calculate in advance how many instructions to be disassembled,
	which complicates things. This is especially troublesome for the case
	@count=0, when cs_disasm() runs uncontrollably (until either end of input
	buffer, or when it encounters an invalid instruction).
	
	@handle: handle returned by cs_open()
	@code: buffer containing raw binary code to be disassembled
	@size: size of above code
	@address: address of the first insn in given raw code buffer
	@insn: pointer to instruction to be filled in by this API.
	
	@return: true if this API successfully decode 1 instruction,
	or false otherwise.
	
	On failure, call cs_errno() for error code.
	*/
	disasm_iter :: proc(handle: csh, code: ^^u8, size: ^c.size_t, address: ^u64, insn: ^insn) -> bool ---

	/**
	Return friendly name of register in a string.
	Find the instruction id from header file of corresponding architecture (arm.h for ARM,
	x86.h for X86, ...)
	
	WARN: when in 'diet' mode, this API is irrelevant because engine does not
	store register name.
	
	@handle: handle returned by cs_open()
	@reg_id: register id
	
	@return: string name of the register, or NULL if @reg_id is invalid.
	*/
	reg_name :: proc(handle: csh, reg_id: u32) -> cstring ---

	/**
	Return friendly name of an instruction in a string.
	Find the instruction id from header file of corresponding architecture (arm.h for ARM, x86.h for X86, ...)
	
	WARN: when in 'diet' mode, this API is irrelevant because the engine does not
	store instruction name.
	
	@handle: handle returned by cs_open()
	@insn_id: instruction id
	
	@return: string name of the instruction, or NULL if @insn_id is invalid.
	*/
	insn_name :: proc(handle: csh, insn_id: u32) -> cstring ---

	/**
	Return friendly name of a group id (that an instruction can belong to)
	Find the group id from header file of corresponding architecture (arm.h for ARM, x86.h for X86, ...)
	
	WARN: when in 'diet' mode, this API is irrelevant because the engine does not
	store group name.
	
	@handle: handle returned by cs_open()
	@group_id: group id
	
	@return: string name of the group, or NULL if @group_id is invalid.
	*/
	group_name :: proc(handle: csh, group_id: u32) -> cstring ---

	/**
	Check if a disassembled instruction belong to a particular group.
	Find the group id from header file of corresponding architecture (arm.h for ARM, x86.h for X86, ...)
	Internally, this simply verifies if @group_id matches any member of insn->groups array.
	
	NOTE: this API is only valid when detail option is ON (which is OFF by default).
	
	WARN: when in 'diet' mode, this API is irrelevant because the engine does not
	update @groups array.
	
	@handle: handle returned by cs_open()
	@insn: disassembled instruction structure received from cs_disasm() or cs_disasm_iter()
	@group_id: group that you want to check if this instruction belong to.
	
	@return: true if this instruction indeed belongs to the given group, or false otherwise.
	*/
	insn_group :: proc(handle: csh, insn: ^insn, group_id: u32) -> bool ---

	/**
	Check if a disassembled instruction IMPLICITLY used a particular register.
	Find the register id from header file of corresponding architecture (arm.h for ARM, x86.h for X86, ...)
	Internally, this simply verifies if @reg_id matches any member of insn->regs_read array.
	
	NOTE: this API is only valid when detail option is ON (which is OFF by default)
	
	WARN: when in 'diet' mode, this API is irrelevant because the engine does not
	update @regs_read array.
	
	@insn: disassembled instruction structure received from cs_disasm() or cs_disasm_iter()
	@reg_id: register that you want to check if this instruction used it.
	
	@return: true if this instruction indeed implicitly used the given register, or false otherwise.
	*/
	reg_read :: proc(handle: csh, insn: ^insn, reg_id: u32) -> bool ---

	/**
	Check if a disassembled instruction IMPLICITLY modified a particular register.
	Find the register id from header file of corresponding architecture (arm.h for ARM, x86.h for X86, ...)
	Internally, this simply verifies if @reg_id matches any member of insn->regs_write array.
	
	NOTE: this API is only valid when detail option is ON (which is OFF by default)
	
	WARN: when in 'diet' mode, this API is irrelevant because the engine does not
	update @regs_write array.
	
	@insn: disassembled instruction structure received from cs_disasm() or cs_disasm_iter()
	@reg_id: register that you want to check if this instruction modified it.
	
	@return: true if this instruction indeed implicitly modified the given register, or false otherwise.
	*/
	reg_write :: proc(handle: csh, insn: ^insn, reg_id: u32) -> bool ---

	/**
	Count the number of operands of a given type.
	Find the operand type in header file of corresponding architecture (arm.h for ARM, x86.h for X86, ...)
	
	NOTE: this API is only valid when detail option is ON (which is OFF by default)
	
	@handle: handle returned by cs_open()
	@insn: disassembled instruction structure received from cs_disasm() or cs_disasm_iter()
	@op_type: Operand type to be found.
	
	@return: number of operands of given type @op_type in instruction @insn,
	or -1 on failure.
	*/
	op_count :: proc(handle: csh, insn: ^insn, op_type: u32) -> i32 ---

	/**
	Retrieve the position of operand of given type in <arch>.operands[] array.
	Later, the operand can be accessed using the returned position.
	Find the operand type in header file of corresponding architecture (arm.h for ARM, x86.h for X86, ...)
	
	NOTE: this API is only valid when detail option is ON (which is OFF by default)
	
	@handle: handle returned by cs_open()
	@insn: disassembled instruction structure received from cs_disasm() or cs_disasm_iter()
	@op_type: Operand type to be found.
	@position: position of the operand to be found. This must be in the range
	[1, cs_op_count(handle, insn, op_type)]
	
	@return: index of operand of given type @op_type in <arch>.operands[] array
	in instruction @insn, or -1 on failure.
	*/
	op_index :: proc(handle: csh, insn: ^insn, op_type: u32, position: u32) -> i32 ---
}

/// Type of array to keep the list of registers
regs :: [64]u16

@(default_calling_convention="c", link_prefix="cs_")
foreign lib {
	/**
	Retrieve all the registers accessed by an instruction, either explicitly or
	implicitly.
	
	WARN: when in 'diet' mode, this API is irrelevant because engine does not
	store registers.
	
	@handle: handle returned by cs_open()
	@insn: disassembled instruction structure returned from cs_disasm() or cs_disasm_iter()
	@regs_read: on return, this array contains all registers read by instruction.
	@regs_read_count: number of registers kept inside @regs_read array.
	@regs_write: on return, this array contains all registers written by instruction.
	@regs_write_count: number of registers kept inside @regs_write array.
	
	@return CS_ERR_OK on success, or other value on failure (refer to cs_err enum
	for detailed error).
	*/
	regs_access :: proc(handle: csh, insn: ^insn, regs_read: ^regs, regs_read_count: ^u8, regs_write: ^regs, regs_write_count: ^u8) -> err ---
}

