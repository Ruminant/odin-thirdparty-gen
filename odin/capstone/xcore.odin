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
xcore_op_type :: enum i32 {
	INVALID = 0, ///< = CS_OP_INVALID (Uninitialized).
	REG     = 1, ///< = CS_OP_REG (Register operand).
	IMM     = 2, ///< = CS_OP_IMM (Immediate operand).
	MEM     = 3, ///< = CS_OP_MEM (Memory operand).
}

/// XCore registers
xcore_reg :: enum i32 {
	INVALID = 0,
	CP      = 1,
	DP      = 2,
	LR      = 3,
	SP      = 4,
	R0      = 5,
	R1      = 6,
	R2      = 7,
	R3      = 8,
	R4      = 9,
	R5      = 10,
	R6      = 11,
	R7      = 12,
	R8      = 13,
	R9      = 14,
	R10     = 15,
	R11     = 16,

	// pseudo registers
	PC      = 17, ///< pc

	// internal thread registers
	// see The-XMOS-XS1-Architecture(X7879A).pdf
	SCP     = 18, ///< save pc
	SSR     = 19, //< save status
	ET      = 20, //< exception type
	ED      = 21, //< exception data
	SED     = 22, //< save exception data
	KEP     = 23, //< kernel entry pointer
	KSP     = 24, //< kernel stack pointer
	ID      = 25, //< thread ID
	ENDING  = 26, // <-- mark the end of the list of registers
}

/// Instruction's operand referring to memory
/// This is associated with XCORE_OP_MEM operand type above
xcore_op_mem :: struct {
	base: u8, ///< base register, can be safely interpreted as

	///< a value of type `xcore_reg`, but it is only
	///< one byte wide
	index:  u8,  ///< index register, same conditions apply here
	disp:   i32, ///< displacement/offset value
	direct: i32, ///< +1: forward, -1: backward
}

/// Instruction operand
xcore_op :: struct {
	type: xcore_op_type, ///< operand type

	using _: struct #raw_union {
		reg: xcore_reg,    ///< register value for REG operand
		imm: i32,          ///< immediate value for IMM operand
		mem: xcore_op_mem, ///< base/disp value for MEM operand
	},
}

/// Instruction structure
xcore :: struct {
	/// Number of operands of this instruction,
	/// or 0 when instruction has no operand.
	op_count: u8,
	operands: [8]xcore_op, ///< operands for this instruction.
}

/// XCore instruction
xcore_insn :: enum i32 {
	INVALID = 0,
	ADD     = 1,
	ANDNOT  = 2,
	AND     = 3,
	ASHR    = 4,
	BAU     = 5,
	BITREV  = 6,
	BLA     = 7,
	BLAT    = 8,
	BL      = 9,
	BF      = 10,
	BT      = 11,
	BU      = 12,
	BRU     = 13,
	BYTEREV = 14,
	CHKCT   = 15,
	CLRE    = 16,
	CLRPT   = 17,
	CLRSR   = 18,
	CLZ     = 19,
	CRC8    = 20,
	CRC32   = 21,
	DCALL   = 22,
	DENTSP  = 23,
	DGETREG = 24,
	DIVS    = 25,
	DIVU    = 26,
	DRESTSP = 27,
	DRET    = 28,
	ECALLF  = 29,
	ECALLT  = 30,
	EDU     = 31,
	EEF     = 32,
	EET     = 33,
	EEU     = 34,
	ENDIN   = 35,
	ENTSP   = 36,
	EQ      = 37,
	EXTDP   = 38,
	EXTSP   = 39,
	FREER   = 40,
	FREET   = 41,
	GETD    = 42,
	GET     = 43,
	GETN    = 44,
	GETR    = 45,
	GETSR   = 46,
	GETST   = 47,
	GETTS   = 48,
	INCT    = 49,
	INIT    = 50,
	INPW    = 51,
	INSHR   = 52,
	INT     = 53,
	IN      = 54,
	KCALL   = 55,
	KENTSP  = 56,
	KRESTSP = 57,
	KRET    = 58,
	LADD    = 59,
	LD16S   = 60,
	LD8U    = 61,
	LDA16   = 62,
	LDAP    = 63,
	LDAW    = 64,
	LDC     = 65,
	LDW     = 66,
	LDIVU   = 67,
	LMUL    = 68,
	LSS     = 69,
	LSUB    = 70,
	LSU     = 71,
	MACCS   = 72,
	MACCU   = 73,
	MJOIN   = 74,
	MKMSK   = 75,
	MSYNC   = 76,
	MUL     = 77,
	NEG     = 78,
	NOT     = 79,
	OR      = 80,
	OUTCT   = 81,
	OUTPW   = 82,
	OUTSHR  = 83,
	OUTT    = 84,
	OUT     = 85,
	PEEK    = 86,
	REMS    = 87,
	REMU    = 88,
	RETSP   = 89,
	SETCLK  = 90,
	SET     = 91,
	SETC    = 92,
	SETD    = 93,
	SETEV   = 94,
	SETN    = 95,
	SETPSC  = 96,
	SETPT   = 97,
	SETRDY  = 98,
	SETSR   = 99,
	SETTW   = 100,
	SETV    = 101,
	SEXT    = 102,
	SHL     = 103,
	SHR     = 104,
	SSYNC   = 105,
	ST16    = 106,
	ST8     = 107,
	STW     = 108,
	SUB     = 109,
	SYNCR   = 110,
	TESTCT  = 111,
	TESTLCL = 112,
	TESTWCT = 113,
	TSETMR  = 114,
	START   = 115,
	WAITEF  = 116,
	WAITET  = 117,
	WAITEU  = 118,
	XOR     = 119,
	ZEXT    = 120,
	ENDING  = 121, // <-- mark the end of the list of instructions
}

/// Group of XCore instructions
xcore_insn_group :: enum i32 {
	INVALID = 0, ///< = CS_GRP_INVALID

	// Generic groups
	// all jump instructions (conditional+direct+indirect jumps)
	JUMP    = 1, ///< = CS_GRP_JUMP
	ENDING  = 2, // <-- mark the end of the list of groups
}

