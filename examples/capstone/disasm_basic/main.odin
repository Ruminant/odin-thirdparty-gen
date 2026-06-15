package main

import "core:c"
import "core:fmt"
import cs "thirdparty:capstone"

CODE := [?]u8{0x55, 0x48, 0x8b, 0x05, 0xb8, 0x13, 0x00, 0x00}

main :: proc() {
	handle: cs.csh
	insns: ^cs.insn

	if cs.open(.X86, ._64, &handle) != .OK {
		return
	}
	defer cs.close(&handle)

	count := cs.disasm(
		handle,
		raw_data(CODE[:]),
		c.size_t(len(CODE)),
		0x1000,
		0,
		&insns,
	)

	if count == 0 {
		fmt.println("ERROR: Failed to disassemble given code!")
		return
	}
	defer cs.free(insns, count)

	insn_list := ([^]cs.insn)(insns)
	for i in 0 ..< int(count) {
		insn := insn_list[i]
		fmt.printf(
			"0x%x:\t%s\t\t%s\n",
			insn.address,
			cstring(rawptr(raw_data(insn.mnemonic[:]))),
			cstring(rawptr(raw_data(insn.op_str[:]))),
		)
	}
}
