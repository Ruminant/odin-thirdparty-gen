package capstone

when ODIN_OS == .Windows {
	when #config(CAPSTONE_STATIC, false) {
		foreign import lib "libs/windows/amd64/capstone_static.lib"
	} else {
		foreign import lib "libs/windows/amd64/capstone.lib"
	}
} else {
	foreign import lib "system:capstone"
}

_ :: lib


/// Enums corresponding to Sparc condition codes, both icc's and fcc's.
sparc_cc :: enum i32 {
	INVALID = 0,   ///< invalid CC (default)

	// Integer condition codes
	ICC_A   = 264, ///< Always
	ICC_N   = 256, ///< Never
	ICC_NE  = 265, ///< Not Equal
	ICC_E   = 257, ///< Equal
	ICC_G   = 266, ///< Greater
	ICC_LE  = 258, ///< Less or Equal
	ICC_GE  = 267, ///< Greater or Equal
	ICC_L   = 259, ///< Less
	ICC_GU  = 268, ///< Greater Unsigned
	ICC_LEU = 260, ///< Less or Equal Unsigned
	ICC_CC  = 269, ///< Carry Clear/Great or Equal Unsigned
	ICC_CS  = 261, ///< Carry Set/Less Unsigned
	ICC_POS = 270, ///< Positive
	ICC_NEG = 262, ///< Negative
	ICC_VC  = 271, ///< Overflow Clear
	ICC_VS  = 263, ///< Overflow Set

	// Floating condition codes
	FCC_A   = 280, ///< Always
	FCC_N   = 272, ///< Never
	FCC_U   = 279, ///< Unordered
	FCC_G   = 278, ///< Greater
	FCC_UG  = 277, ///< Unordered or Greater
	FCC_L   = 276, ///< Less
	FCC_UL  = 275, ///< Unordered or Less
	FCC_LG  = 274, ///< Less or Greater
	FCC_NE  = 273, ///< Not Equal
	FCC_E   = 281, ///< Equal
	FCC_UE  = 282, ///< Unordered or Equal
	FCC_GE  = 283, ///< Greater or Equal
	FCC_UGE = 284, ///< Unordered or Greater or Equal
	FCC_LE  = 285, ///< Less or Equal
	FCC_ULE = 286, ///< Unordered or Less or Equal
	FCC_O   = 287, ///< Ordered
}

/// Branch hint
sparc_hint :: enum i32 {
	INVALID = 0, ///< no hint
	A       = 1, ///< annul delay slot instruction
	PT      = 2, ///< branch taken
	PN      = 4, ///< branch NOT taken
}

/// Operand type for instruction's operands
sparc_op_type :: enum i32 {
	INVALID = 0, ///< = CS_OP_INVALID (Uninitialized).
	REG     = 1, ///< = CS_OP_REG (Register operand).
	IMM     = 2, ///< = CS_OP_IMM (Immediate operand).
	MEM     = 3, ///< = CS_OP_MEM (Memory operand).
}

/// SPARC registers
sparc_reg :: enum i32 {
	INVALID = 0,
	F0      = 1,
	F1      = 2,
	F2      = 3,
	F3      = 4,
	F4      = 5,
	F5      = 6,
	F6      = 7,
	F7      = 8,
	F8      = 9,
	F9      = 10,
	F10     = 11,
	F11     = 12,
	F12     = 13,
	F13     = 14,
	F14     = 15,
	F15     = 16,
	F16     = 17,
	F17     = 18,
	F18     = 19,
	F19     = 20,
	F20     = 21,
	F21     = 22,
	F22     = 23,
	F23     = 24,
	F24     = 25,
	F25     = 26,
	F26     = 27,
	F27     = 28,
	F28     = 29,
	F29     = 30,
	F30     = 31,
	F31     = 32,
	F32     = 33,
	F34     = 34,
	F36     = 35,
	F38     = 36,
	F40     = 37,
	F42     = 38,
	F44     = 39,
	F46     = 40,
	F48     = 41,
	F50     = 42,
	F52     = 43,
	F54     = 44,
	F56     = 45,
	F58     = 46,
	F60     = 47,
	F62     = 48,
	FCC0    = 49, // Floating condition codes
	FCC1    = 50,
	FCC2    = 51,
	FCC3    = 52,
	FP      = 53,
	G0      = 54,
	G1      = 55,
	G2      = 56,
	G3      = 57,
	G4      = 58,
	G5      = 59,
	G6      = 60,
	G7      = 61,
	I0      = 62,
	I1      = 63,
	I2      = 64,
	I3      = 65,
	I4      = 66,
	I5      = 67,
	I7      = 68,
	ICC     = 69, // Integer condition codes
	L0      = 70,
	L1      = 71,
	L2      = 72,
	L3      = 73,
	L4      = 74,
	L5      = 75,
	L6      = 76,
	L7      = 77,
	O0      = 78,
	O1      = 79,
	O2      = 80,
	O3      = 81,
	O4      = 82,
	O5      = 83,
	O7      = 84,
	SP      = 85,
	Y       = 86,

	// special register
	XCC     = 87,
	ENDING  = 88, // <-- mark the end of the list of registers

	// extras
	O6      = 85,
	I6      = 53,
}

/// Instruction's operand referring to memory
/// This is associated with SPARC_OP_MEM operand type above
sparc_op_mem :: struct {
	base: u8, ///< base register, can be safely interpreted as

	///< a value of type `sparc_reg`, but it is only
	///< one byte wide
	index: u8,  ///< index register, same conditions apply here
	disp:  i32, ///< displacement/offset value
}

/// Instruction operand
sparc_op :: struct {
	type: sparc_op_type, ///< operand type

	using _: struct #raw_union {
		reg: sparc_reg,    ///< register value for REG operand
		imm: i64,          ///< immediate value for IMM operand
		mem: sparc_op_mem, ///< base/disp value for MEM operand
	},
}

/// Instruction structure
sparc :: struct {
	cc:   sparc_cc,   ///< code condition for this insn
	hint: sparc_hint, ///< branch hint: encoding as bitwise OR of sparc_hint.

	/// Number of operands of this instruction,
	/// or 0 when instruction has no operand.
	op_count: u8,
	operands: [4]sparc_op, ///< operands for this instruction.
}

/// SPARC instruction
sparc_insn :: enum i32 {
	INVALID     = 0,
	ADDCC       = 1,
	ADDX        = 2,
	ADDXCC      = 3,
	ADDXC       = 4,
	ADDXCCC     = 5,
	ADD         = 6,
	ALIGNADDR   = 7,
	ALIGNADDRL  = 8,
	ANDCC       = 9,
	ANDNCC      = 10,
	ANDN        = 11,
	AND         = 12,
	ARRAY16     = 13,
	ARRAY32     = 14,
	ARRAY8      = 15,
	B           = 16,
	JMP         = 17,
	BMASK       = 18,
	FB          = 19,
	BRGEZ       = 20,
	BRGZ        = 21,
	BRLEZ       = 22,
	BRLZ        = 23,
	BRNZ        = 24,
	BRZ         = 25,
	BSHUFFLE    = 26,
	CALL        = 27,
	CASX        = 28,
	CAS         = 29,
	CMASK16     = 30,
	CMASK32     = 31,
	CMASK8      = 32,
	CMP         = 33,
	EDGE16      = 34,
	EDGE16L     = 35,
	EDGE16LN    = 36,
	EDGE16N     = 37,
	EDGE32      = 38,
	EDGE32L     = 39,
	EDGE32LN    = 40,
	EDGE32N     = 41,
	EDGE8       = 42,
	EDGE8L      = 43,
	EDGE8LN     = 44,
	EDGE8N      = 45,
	FABSD       = 46,
	FABSQ       = 47,
	FABSS       = 48,
	FADDD       = 49,
	FADDQ       = 50,
	FADDS       = 51,
	FALIGNDATA  = 52,
	FAND        = 53,
	FANDNOT1    = 54,
	FANDNOT1S   = 55,
	FANDNOT2    = 56,
	FANDNOT2S   = 57,
	FANDS       = 58,
	FCHKSM16    = 59,
	FCMPD       = 60,
	FCMPEQ16    = 61,
	FCMPEQ32    = 62,
	FCMPGT16    = 63,
	FCMPGT32    = 64,
	FCMPLE16    = 65,
	FCMPLE32    = 66,
	FCMPNE16    = 67,
	FCMPNE32    = 68,
	FCMPQ       = 69,
	FCMPS       = 70,
	FDIVD       = 71,
	FDIVQ       = 72,
	FDIVS       = 73,
	FDMULQ      = 74,
	FDTOI       = 75,
	FDTOQ       = 76,
	FDTOS       = 77,
	FDTOX       = 78,
	FEXPAND     = 79,
	FHADDD      = 80,
	FHADDS      = 81,
	FHSUBD      = 82,
	FHSUBS      = 83,
	FITOD       = 84,
	FITOQ       = 85,
	FITOS       = 86,
	FLCMPD      = 87,
	FLCMPS      = 88,
	FLUSHW      = 89,
	FMEAN16     = 90,
	FMOVD       = 91,
	FMOVQ       = 92,
	FMOVRDGEZ   = 93,
	FMOVRQGEZ   = 94,
	FMOVRSGEZ   = 95,
	FMOVRDGZ    = 96,
	FMOVRQGZ    = 97,
	FMOVRSGZ    = 98,
	FMOVRDLEZ   = 99,
	FMOVRQLEZ   = 100,
	FMOVRSLEZ   = 101,
	FMOVRDLZ    = 102,
	FMOVRQLZ    = 103,
	FMOVRSLZ    = 104,
	FMOVRDNZ    = 105,
	FMOVRQNZ    = 106,
	FMOVRSNZ    = 107,
	FMOVRDZ     = 108,
	FMOVRQZ     = 109,
	FMOVRSZ     = 110,
	FMOVS       = 111,
	FMUL8SUX16  = 112,
	FMUL8ULX16  = 113,
	FMUL8X16    = 114,
	FMUL8X16AL  = 115,
	FMUL8X16AU  = 116,
	FMULD       = 117,
	FMULD8SUX16 = 118,
	FMULD8ULX16 = 119,
	FMULQ       = 120,
	FMULS       = 121,
	FNADDD      = 122,
	FNADDS      = 123,
	FNAND       = 124,
	FNANDS      = 125,
	FNEGD       = 126,
	FNEGQ       = 127,
	FNEGS       = 128,
	FNHADDD     = 129,
	FNHADDS     = 130,
	FNOR        = 131,
	FNORS       = 132,
	FNOT1       = 133,
	FNOT1S      = 134,
	FNOT2       = 135,
	FNOT2S      = 136,
	FONE        = 137,
	FONES       = 138,
	FOR         = 139,
	FORNOT1     = 140,
	FORNOT1S    = 141,
	FORNOT2     = 142,
	FORNOT2S    = 143,
	FORS        = 144,
	FPACK16     = 145,
	FPACK32     = 146,
	FPACKFIX    = 147,
	FPADD16     = 148,
	FPADD16S    = 149,
	FPADD32     = 150,
	FPADD32S    = 151,
	FPADD64     = 152,
	FPMERGE     = 153,
	FPSUB16     = 154,
	FPSUB16S    = 155,
	FPSUB32     = 156,
	FPSUB32S    = 157,
	FQTOD       = 158,
	FQTOI       = 159,
	FQTOS       = 160,
	FQTOX       = 161,
	FSLAS16     = 162,
	FSLAS32     = 163,
	FSLL16      = 164,
	FSLL32      = 165,
	FSMULD      = 166,
	FSQRTD      = 167,
	FSQRTQ      = 168,
	FSQRTS      = 169,
	FSRA16      = 170,
	FSRA32      = 171,
	FSRC1       = 172,
	FSRC1S      = 173,
	FSRC2       = 174,
	FSRC2S      = 175,
	FSRL16      = 176,
	FSRL32      = 177,
	FSTOD       = 178,
	FSTOI       = 179,
	FSTOQ       = 180,
	FSTOX       = 181,
	FSUBD       = 182,
	FSUBQ       = 183,
	FSUBS       = 184,
	FXNOR       = 185,
	FXNORS      = 186,
	FXOR        = 187,
	FXORS       = 188,
	FXTOD       = 189,
	FXTOQ       = 190,
	FXTOS       = 191,
	FZERO       = 192,
	FZEROS      = 193,
	JMPL        = 194,
	LDD         = 195,
	LD          = 196,
	LDQ         = 197,
	LDSB        = 198,
	LDSH        = 199,
	LDSW        = 200,
	LDUB        = 201,
	LDUH        = 202,
	LDX         = 203,
	LZCNT       = 204,
	MEMBAR      = 205,
	MOVDTOX     = 206,
	MOV         = 207,
	MOVRGEZ     = 208,
	MOVRGZ      = 209,
	MOVRLEZ     = 210,
	MOVRLZ      = 211,
	MOVRNZ      = 212,
	MOVRZ       = 213,
	MOVSTOSW    = 214,
	MOVSTOUW    = 215,
	MULX        = 216,
	NOP         = 217,
	ORCC        = 218,
	ORNCC       = 219,
	ORN         = 220,
	OR          = 221,
	PDIST       = 222,
	PDISTN      = 223,
	POPC        = 224,
	RD          = 225,
	RESTORE     = 226,
	RETT        = 227,
	SAVE        = 228,
	SDIVCC      = 229,
	SDIVX       = 230,
	SDIV        = 231,
	SETHI       = 232,
	SHUTDOWN    = 233,
	SIAM        = 234,
	SLLX        = 235,
	SLL         = 236,
	SMULCC      = 237,
	SMUL        = 238,
	SRAX        = 239,
	SRA         = 240,
	SRLX        = 241,
	SRL         = 242,
	STBAR       = 243,
	STB         = 244,
	STD         = 245,
	ST          = 246,
	STH         = 247,
	STQ         = 248,
	STX         = 249,
	SUBCC       = 250,
	SUBX        = 251,
	SUBXCC      = 252,
	SUB         = 253,
	SWAP        = 254,
	TADDCCTV    = 255,
	TADDCC      = 256,
	T           = 257,
	TSUBCCTV    = 258,
	TSUBCC      = 259,
	UDIVCC      = 260,
	UDIVX       = 261,
	UDIV        = 262,
	UMULCC      = 263,
	UMULXHI     = 264,
	UMUL        = 265,
	UNIMP       = 266,
	FCMPED      = 267,
	FCMPEQ      = 268,
	FCMPES      = 269,
	WR          = 270,
	XMULX       = 271,
	XMULXHI     = 272,
	XNORCC      = 273,
	XNOR        = 274,
	XORCC       = 275,
	XOR         = 276,

	// alias instructions
	RET         = 277,
	RETL        = 278,
	ENDING      = 279, // <-- mark the end of the list of instructions
}

/// Group of SPARC instructions
sparc_insn_group :: enum i32 {
	INVALID  = 0,   ///< = CS_GRP_INVALID

	// Generic groups
	// all jump instructions (conditional+direct+indirect jumps)
	JUMP     = 1,   ///< = CS_GRP_JUMP

	// Architecture-specific groups
	HARDQUAD = 128,
	V9       = 129,
	VIS      = 130,
	VIS2     = 131,
	VIS3     = 132,
	_32BIT   = 133,
	_64BIT   = 134,
	ENDING   = 135, // <-- mark the end of the list of groups
}

