/* Capstone Disassembly Engine */
/* BPF Backend by david942j <david942j@gmail.com>, 2019 */
package capstone

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


/// Operand type for instruction's operands
bpf_op_type :: enum i32 {
	INVALID = 0,
	REG     = 1,
	IMM     = 2,
	OFF     = 3,
	MEM     = 4,
	MMEM    = 5, ///< M[k] in cBPF
	MSH     = 6, ///< corresponds to cBPF's BPF_MSH mode
	EXT     = 7, ///< cBPF's extension (not eBPF)
}

/// BPF registers
bpf_reg :: enum i32 {
	INVALID = 0,

	///< cBPF
	A       = 1,
	X       = 2,

	///< eBPF
	R0      = 3,
	R1      = 4,
	R2      = 5,
	R3      = 6,
	R4      = 7,
	R5      = 8,
	R6      = 9,
	R7      = 10,
	R8      = 11,
	R9      = 12,
	R10     = 13,
	ENDING  = 14,
}

/// Instruction's operand referring to memory
/// This is associated with BPF_OP_MEM operand type above
bpf_op_mem :: struct {
	base: bpf_reg, ///< base register
	disp: u32,     ///< offset value
}

bpf_ext_type :: enum i32 {
	INVALID = 0,
	LEN     = 1,
}

/// Instruction operand
bpf_op :: struct {
	type: bpf_op_type,

	using _: struct #raw_union {
		reg: u8,         ///< register value for REG operand
		imm: u64,        ///< immediate value IMM operand
		off: u32,        ///< offset value, used in jump & call
		mem: bpf_op_mem, ///< base/disp value for MEM operand

		/* cBPF only */
		mmem: u32, ///< M[k] in cBPF
		msh:  u32, ///< corresponds to cBPF's BPF_MSH mode
		ext:  u32, ///< cBPF's extension (not eBPF)
	},

	/// How is this operand accessed? (READ, WRITE or READ|WRITE)
	/// This field is combined of cs_ac_type.
	/// NOTE: this field is irrelevant if engine is compiled in DIET mode.
	access: u8,
}

/// Instruction structure
bpf :: struct {
	op_count: u8,
	operands: [4]bpf_op,
}

/// BPF instruction
bpf_insn :: enum i32 {
	INVALID = 0,

	///< ALU
	ADD     = 1,
	SUB     = 2,
	MUL     = 3,
	DIV     = 4,
	OR      = 5,
	AND     = 6,
	LSH     = 7,
	RSH     = 8,
	NEG     = 9,
	MOD     = 10,
	XOR     = 11,
	MOV     = 12, ///< eBPF only
	ARSH    = 13, ///< eBPF only

	///< ALU64, eBPF only
	ADD64   = 14,
	SUB64   = 15,
	MUL64   = 16,
	DIV64   = 17,
	OR64    = 18,
	AND64   = 19,
	LSH64   = 20,
	RSH64   = 21,
	NEG64   = 22,
	MOD64   = 23,
	XOR64   = 24,
	MOV64   = 25,
	ARSH64  = 26,

	///< Byteswap, eBPF only
	LE16    = 27,
	LE32    = 28,
	LE64    = 29,
	BE16    = 30,
	BE32    = 31,
	BE64    = 32,

	///< Load
	LDW     = 33, ///< eBPF only
	LDH     = 34,
	LDB     = 35,
	LDDW    = 36, ///< eBPF only: load 64-bit imm
	LDXW    = 37, ///< eBPF only
	LDXH    = 38, ///< eBPF only
	LDXB    = 39, ///< eBPF only
	LDXDW   = 40, ///< eBPF only

	///< Store
	STW     = 41, ///< eBPF only
	STH     = 42, ///< eBPF only
	STB     = 43, ///< eBPF only
	STDW    = 44, ///< eBPF only
	STXW    = 45, ///< eBPF only
	STXH    = 46, ///< eBPF only
	STXB    = 47, ///< eBPF only
	STXDW   = 48, ///< eBPF only
	XADDW   = 49, ///< eBPF only
	XADDDW  = 50, ///< eBPF only

	///< Jump
	JMP     = 51,
	JEQ     = 52,
	JGT     = 53,
	JGE     = 54,
	JSET    = 55,
	JNE     = 56, ///< eBPF only
	JSGT    = 57, ///< eBPF only
	JSGE    = 58, ///< eBPF only
	CALL    = 59, ///< eBPF only
	CALLX   = 60, ///< eBPF only
	EXIT    = 61, ///< eBPF only
	JLT     = 62, ///< eBPF only
	JLE     = 63, ///< eBPF only
	JSLT    = 64, ///< eBPF only
	JSLE    = 65, ///< eBPF only

	///< Return, cBPF only
	RET     = 66,

	///< Misc, cBPF only
	TAX     = 67,
	TXA     = 68,
	ENDING  = 69,

	// alias instructions
	LD      = 33, ///< cBPF only
	LDX     = 37, ///< cBPF only
	ST      = 41, ///< cBPF only
	STX     = 45, ///< cBPF only
}

/// Group of BPF instructions
bpf_insn_group :: enum i32 {
	INVALID = 0, ///< = CS_GRP_INVALID
	LOAD    = 1,
	STORE   = 2,
	ALU     = 3,
	JUMP    = 4,
	CALL    = 5, ///< eBPF only
	RETURN  = 6,
	MISC    = 7, ///< cBPF only
	ENDING  = 8,
}

