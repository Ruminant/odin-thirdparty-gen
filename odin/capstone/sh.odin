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


/// SH registers and special registers
sh_reg :: enum i32 {
	INVALID  = 0,
	R0       = 1,
	R1       = 2,
	R2       = 3,
	R3       = 4,
	R4       = 5,
	R5       = 6,
	R6       = 7,
	R7       = 8,
	R8       = 9,
	R9       = 10,
	R10      = 11,
	R11      = 12,
	R12      = 13,
	R13      = 14,
	R14      = 15,
	R15      = 16,
	R0_BANK  = 17,
	R1_BANK  = 18,
	R2_BANK  = 19,
	R3_BANK  = 20,
	R4_BANK  = 21,
	R5_BANK  = 22,
	R6_BANK  = 23,
	R7_BANK  = 24,
	FR0      = 25,
	FR1      = 26,
	FR2      = 27,
	FR3      = 28,
	FR4      = 29,
	FR5      = 30,
	FR6      = 31,
	FR7      = 32,
	FR8      = 33,
	FR9      = 34,
	FR10     = 35,
	FR11     = 36,
	FR12     = 37,
	FR13     = 38,
	FR14     = 39,
	FR15     = 40,
	DR0      = 41,
	DR2      = 42,
	DR4      = 43,
	DR6      = 44,
	DR8      = 45,
	DR10     = 46,
	DR12     = 47,
	DR14     = 48,
	XD0      = 49,
	XD2      = 50,
	XD4      = 51,
	XD6      = 52,
	XD8      = 53,
	XD10     = 54,
	XD12     = 55,
	XD14     = 56,
	XF0      = 57,
	XF1      = 58,
	XF2      = 59,
	XF3      = 60,
	XF4      = 61,
	XF5      = 62,
	XF6      = 63,
	XF7      = 64,
	XF8      = 65,
	XF9      = 66,
	XF10     = 67,
	XF11     = 68,
	XF12     = 69,
	XF13     = 70,
	XF14     = 71,
	XF15     = 72,
	FV0      = 73,
	FV4      = 74,
	FV8      = 75,
	FV12     = 76,
	XMATRX   = 77,
	PC       = 78,
	PR       = 79,
	MACH     = 80,
	MACL     = 81,
	SR       = 82,
	GBR      = 83,
	SSR      = 84,
	SPC      = 85,
	SGR      = 86,
	DBR      = 87,
	VBR      = 88,
	TBR      = 89,
	RS       = 90,
	RE       = 91,
	MOD      = 92,
	FPUL     = 93,
	FPSCR    = 94,
	DSP_X0   = 95,
	DSP_X1   = 96,
	DSP_Y0   = 97,
	DSP_Y1   = 98,
	DSP_A0   = 99,
	DSP_A1   = 100,
	DSP_A0G  = 101,
	DSP_A1G  = 102,
	DSP_M0   = 103,
	DSP_M1   = 104,
	DSP_DSR  = 105,
	DSP_RSV0 = 106,
	DSP_RSV1 = 107,
	DSP_RSV2 = 108,
	DSP_RSV3 = 109,
	DSP_RSV4 = 110,
	DSP_RSV5 = 111,
	DSP_RSV6 = 112,
	DSP_RSV7 = 113,
	DSP_RSV8 = 114,
	DSP_RSV9 = 115,
	DSP_RSVA = 116,
	DSP_RSVB = 117,
	DSP_RSVC = 118,
	DSP_RSVD = 119,
	DSP_RSVE = 120,
	DSP_RSVF = 121,
	ENDING   = 122, // <-- mark the end of the list of registers
}

sh_op_type :: enum i32 {
	INVALID = 0, ///< = CS_OP_INVALID (Uninitialized).
	REG     = 1, ///< = CS_OP_REG (Register operand).
	IMM     = 2, ///< = CS_OP_IMM (Immediate operand).
	MEM     = 3, ///< = CS_OP_MEM (Memory operand).
}

sh_op_mem_type :: enum i32 {
	INVALID  = 0, /// <= Invalid
	REG_IND  = 1, /// <= Register indirect
	REG_POST = 2, /// <= Register post increment
	REG_PRE  = 3, /// <= Register pre decrement
	REG_DISP = 4, /// <= displacement
	REG_R0   = 5, /// <= R0 indexed
	GBR_DISP = 6, /// <= GBR based displacement
	GBR_R0   = 7, /// <= GBR based R0 indexed
	PCR      = 8, /// <= PC relative
	TBR_DISP = 9, /// <= TBR based displaysment
}

sh_op_mem :: struct {
	address: sh_op_mem_type, /// <= memory address
	reg:     sh_reg,         /// <= base register
	disp:    u32,            /// <= displacement
}

// SH-DSP instcutions define
sh_dsp_insn_type :: enum i32 {
	INVALID  = 0,
	DOUBLE   = 1,
	SINGLE   = 2,
	PARALLEL = 3,
}

sh_dsp_insn :: enum i32 {
	NOP        = 1,
	MOV        = 2,
	PSHL       = 3,
	PSHA       = 4,
	PMULS      = 5,
	PCLR_PMULS = 6,
	PSUB_PMULS = 7,
	PADD_PMULS = 8,
	PSUBC      = 9,
	PADDC      = 10,
	PCMP       = 11,
	PABS       = 12,
	PRND       = 13,
	PSUB       = 14,
	PSUBr      = 15,
	PADD       = 16,
	PAND       = 17,
	PXOR       = 18,
	POR        = 19,
	PDEC       = 20,
	PINC       = 21,
	PCLR       = 22,
	PDMSB      = 23,
	PNEG       = 24,
	PCOPY      = 25,
	PSTS       = 26,
	PLDS       = 27,
	PSWAP      = 28,
	PWAD       = 29,
	PWSB       = 30,
}

sh_dsp_operand :: enum i32 {
	INVALID   = 0,
	REG_PRE   = 1,
	REG_IND   = 2,
	REG_POST  = 3,
	REG_INDEX = 4,
	REG       = 5,
	IMM       = 6,
}

sh_dsp_cc :: enum i32 {
	INVALID = 0,
	NONE    = 1,
	DCT     = 2,
	DCF     = 3,
}

sh_op_dsp :: struct {
	insn:    sh_dsp_insn,
	operand: [2]sh_dsp_operand,
	r:       [6]sh_reg,
	cc:      sh_dsp_cc,
	imm:     u8,
	size:    i32,
}

/// Instruction operand
sh_op :: struct {
	type: sh_op_type,

	using _: struct #raw_union {
		imm: u64,       ///< immediate value for IMM operand
		reg: sh_reg,    ///< register value for REG operand
		mem: sh_op_mem, ///< data when operand is targeting memory
		dsp: sh_op_dsp, ///< dsp instruction
	},
}

/// SH instruction
sh_insn :: enum i32 {
	INVALID = 0,
	ADD_r   = 1,
	ADD     = 2,
	ADDC    = 3,
	ADDV    = 4,
	AND     = 5,
	BAND    = 6,
	BANDNOT = 7,
	BCLR    = 8,
	BF      = 9,
	BF_S    = 10,
	BLD     = 11,
	BLDNOT  = 12,
	BOR     = 13,
	BORNOT  = 14,
	BRA     = 15,
	BRAF    = 16,
	BSET    = 17,
	BSR     = 18,
	BSRF    = 19,
	BST     = 20,
	BT      = 21,
	BT_S    = 22,
	BXOR    = 23,
	CLIPS   = 24,
	CLIPU   = 25,
	CLRDMXY = 26,
	CLRMAC  = 27,
	CLRS    = 28,
	CLRT    = 29,
	CMP_EQ  = 30,
	CMP_GE  = 31,
	CMP_GT  = 32,
	CMP_HI  = 33,
	CMP_HS  = 34,
	CMP_PL  = 35,
	CMP_PZ  = 36,
	CMP_STR = 37,
	DIV0S   = 38,
	DIV0U   = 39,
	DIV1    = 40,
	DIVS    = 41,
	DIVU    = 42,
	DMULS_L = 43,
	DMULU_L = 44,
	DT      = 45,
	EXTS_B  = 46,
	EXTS_W  = 47,
	EXTU_B  = 48,
	EXTU_W  = 49,
	FABS    = 50,
	FADD    = 51,
	FCMP_EQ = 52,
	FCMP_GT = 53,
	FCNVDS  = 54,
	FCNVSD  = 55,
	FDIV    = 56,
	FIPR    = 57,
	FLDI0   = 58,
	FLDI1   = 59,
	FLDS    = 60,
	FLOAT   = 61,
	FMAC    = 62,
	FMOV    = 63,
	FMUL    = 64,
	FNEG    = 65,
	FPCHG   = 66,
	FRCHG   = 67,
	FSCA    = 68,
	FSCHG   = 69,
	FSQRT   = 70,
	FSRRA   = 71,
	FSTS    = 72,
	FSUB    = 73,
	FTRC    = 74,
	FTRV    = 75,
	ICBI    = 76,
	JMP     = 77,
	JSR     = 78,
	JSR_N   = 79,
	LDBANK  = 80,
	LDC     = 81,
	LDRC    = 82,
	LDRE    = 83,
	LDRS    = 84,
	LDS     = 85,
	LDTLB   = 86,
	MAC_L   = 87,
	MAC_W   = 88,
	MOV     = 89,
	MOVA    = 90,
	MOVCA   = 91,
	MOVCO   = 92,
	MOVI20  = 93,
	MOVI20S = 94,
	MOVLI   = 95,
	MOVML   = 96,
	MOVMU   = 97,
	MOVRT   = 98,
	MOVT    = 99,
	MOVU    = 100,
	MOVUA   = 101,
	MUL_L   = 102,
	MULR    = 103,
	MULS_W  = 104,
	MULU_W  = 105,
	NEG     = 106,
	NEGC    = 107,
	NOP     = 108,
	NOT     = 109,
	NOTT    = 110,
	OCBI    = 111,
	OCBP    = 112,
	OCBWB   = 113,
	OR      = 114,
	PREF    = 115,
	PREFI   = 116,
	RESBANK = 117,
	ROTCL   = 118,
	ROTCR   = 119,
	ROTL    = 120,
	ROTR    = 121,
	RTE     = 122,
	RTS     = 123,
	RTS_N   = 124,
	RTV_N   = 125,
	SETDMX  = 126,
	SETDMY  = 127,
	SETRC   = 128,
	SETS    = 129,
	SETT    = 130,
	SHAD    = 131,
	SHAL    = 132,
	SHAR    = 133,
	SHLD    = 134,
	SHLL    = 135,
	SHLL16  = 136,
	SHLL2   = 137,
	SHLL8   = 138,
	SHLR    = 139,
	SHLR16  = 140,
	SHLR2   = 141,
	SHLR8   = 142,
	SLEEP   = 143,
	STBANK  = 144,
	STC     = 145,
	STS     = 146,
	SUB     = 147,
	SUBC    = 148,
	SUBV    = 149,
	SWAP_B  = 150,
	SWAP_W  = 151,
	SYNCO   = 152,
	TAS     = 153,
	TRAPA   = 154,
	TST     = 155,
	XOR     = 156,
	XTRCT   = 157,
	DSP     = 158,
	ENDING  = 159, // <-- mark the end of the list of instructions
}

/// Instruction structure
sh :: struct {
	insn:     sh_insn,
	size:     u8,
	op_count: u8,
	operands: [3]sh_op,
}

/// Group of SH instructions
sh_insn_group :: enum i32 {
	INVALID         = 0,  ///< CS_GRUP_INVALID
	JUMP            = 1,  ///< = CS_GRP_JUMP
	CALL            = 2,  ///< = CS_GRP_CALL
	INT             = 3,  ///< = CS_GRP_INT
	RET             = 4,  ///< = CS_GRP_RET
	IRET            = 5,  ///< = CS_GRP_IRET
	PRIVILEGE       = 6,  ///< = CS_GRP_PRIVILEGE
	BRANCH_RELATIVE = 7,  ///< = CS_GRP_BRANCH_RELATIVE
	SH1             = 8,
	SH2             = 9,
	SH2E            = 10,
	SH2DSP          = 11,
	SH2A            = 12,
	SH2AFPU         = 13,
	SH3             = 14,
	SH3DSP          = 15,
	SH4             = 16,
	SH4A            = 17,
	ENDING          = 18, // <-- mark the end of the list of groups
}

