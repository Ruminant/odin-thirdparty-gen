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


//> Operand type for instruction's operands
riscv_op_type :: enum i32 {
	INVALID = 0, // = CS_OP_INVALID (Uninitialized).
	REG     = 1, // = CS_OP_REG (Register operand).
	IMM     = 2, // = CS_OP_IMM (Immediate operand).
	MEM     = 3, // = CS_OP_MEM (Memory operand).
}

// Instruction's operand referring to memory
// This is associated with RISCV_OP_MEM operand type above
riscv_op_mem :: struct {
	base: u32, // base register
	disp: i64, // displacement/offset value
}

// Instruction operand
riscv_op :: struct {
	type: riscv_op_type, // operand type

	using _: struct #raw_union {
		reg: u32,          // register value for REG operand
		imm: i64,          // immediate value for IMM operand
		mem: riscv_op_mem, // base/disp value for MEM operand
	},
}

// Instruction structure
riscv :: struct {
	// Does this instruction need effective address or not.
	need_effective_addr: bool,

	// Number of operands of this instruction,
	// or 0 when instruction has no operand.
	op_count: u8,
	operands: [8]riscv_op, // operands for this instruction.
}

//> RISCV registers
riscv_reg :: enum i32 {
	INVALID = 0,

	//> General purpose registers
	X0      = 1,  // "zero" 
	ZERO    = 1,  // "zero" 
	X1      = 2,  // "ra"
	RA      = 2,  // "ra"
	X2      = 3,  // "sp"
	SP      = 3,  // "sp"
	X3      = 4,  // "gp"
	GP      = 4,  // "gp"
	X4      = 5,  // "tp"
	TP      = 5,  // "tp"
	X5      = 6,  // "t0"
	T0      = 6,  // "t0"
	X6      = 7,  // "t1"
	T1      = 7,  // "t1"
	X7      = 8,  // "t2"
	T2      = 8,  // "t2"
	X8      = 9,  // "s0/fp"
	S0      = 9,  // "s0"
	FP      = 9,  // "fp"
	X9      = 10, // "s1"
	S1      = 10, // "s1"
	X10     = 11, // "a0"
	A0      = 11, // "a0"
	X11     = 12, // "a1"
	A1      = 12, // "a1"
	X12     = 13, // "a2"
	A2      = 13, // "a2"
	X13     = 14, // "a3"
	A3      = 14, // "a3"
	X14     = 15, // "a4"
	A4      = 15, // "a4"
	X15     = 16, // "a5"
	A5      = 16, // "a5"
	X16     = 17, // "a6"
	A6      = 17, // "a6"
	X17     = 18, // "a7"
	A7      = 18, // "a7"
	X18     = 19, // "s2"
	S2      = 19, // "s2"
	X19     = 20, // "s3"
	S3      = 20, // "s3"
	X20     = 21, // "s4"
	S4      = 21, // "s4"
	X21     = 22, // "s5"
	S5      = 22, // "s5"
	X22     = 23, // "s6"
	S6      = 23, // "s6"
	X23     = 24, // "s7"
	S7      = 24, // "s7"
	X24     = 25, // "s8"
	S8      = 25, // "s8"
	X25     = 26, // "s9"
	S9      = 26, // "s9"
	X26     = 27, // "s10"
	S10     = 27, // "s10"
	X27     = 28, // "s11"
	S11     = 28, // "s11"
	X28     = 29, // "t3"
	T3      = 29, // "t3"
	X29     = 30, // "t4"
	T4      = 30, // "t4"
	X30     = 31, // "t5"
	T5      = 31, // "t5"
	X31     = 32, // "t6"
	T6      = 32, // "t6"

	//> Floating-point registers
	F0_32   = 33, // "ft0"
	F0_64   = 34, // "ft0"
	F1_32   = 35, // "ft1"
	F1_64   = 36, // "ft1"
	F2_32   = 37, // "ft2"
	F2_64   = 38, // "ft2"
	F3_32   = 39, // "ft3"
	F3_64   = 40, // "ft3"
	F4_32   = 41, // "ft4"
	F4_64   = 42, // "ft4"
	F5_32   = 43, // "ft5"
	F5_64   = 44, // "ft5"
	F6_32   = 45, // "ft6"
	F6_64   = 46, // "ft6"
	F7_32   = 47, // "ft7"
	F7_64   = 48, // "ft7"
	F8_32   = 49, // "fs0"
	F8_64   = 50, // "fs0"
	F9_32   = 51, // "fs1"
	F9_64   = 52, // "fs1"
	F10_32  = 53, // "fa0"
	F10_64  = 54, // "fa0"
	F11_32  = 55, // "fa1"
	F11_64  = 56, // "fa1"
	F12_32  = 57, // "fa2"
	F12_64  = 58, // "fa2"
	F13_32  = 59, // "fa3"
	F13_64  = 60, // "fa3"
	F14_32  = 61, // "fa4"
	F14_64  = 62, // "fa4"
	F15_32  = 63, // "fa5"
	F15_64  = 64, // "fa5"
	F16_32  = 65, // "fa6"
	F16_64  = 66, // "fa6"
	F17_32  = 67, // "fa7"
	F17_64  = 68, // "fa7"
	F18_32  = 69, // "fs2"
	F18_64  = 70, // "fs2"
	F19_32  = 71, // "fs3"
	F19_64  = 72, // "fs3"
	F20_32  = 73, // "fs4"
	F20_64  = 74, // "fs4"
	F21_32  = 75, // "fs5"
	F21_64  = 76, // "fs5"
	F22_32  = 77, // "fs6"
	F22_64  = 78, // "fs6"
	F23_32  = 79, // "fs7"
	F23_64  = 80, // "fs7"
	F24_32  = 81, // "fs8"
	F24_64  = 82, // "fs8"
	F25_32  = 83, // "fs9"
	F25_64  = 84, // "fs9"
	F26_32  = 85, // "fs10"
	F26_64  = 86, // "fs10"
	F27_32  = 87, // "fs11"
	F27_64  = 88, // "fs11"
	F28_32  = 89, // "ft8"
	F28_64  = 90, // "ft8"
	F29_32  = 91, // "ft9"
	F29_64  = 92, // "ft9"
	F30_32  = 93, // "ft10"
	F30_64  = 94, // "ft10"
	F31_32  = 95, // "ft11"
	F31_64  = 96, // "ft11"
	ENDING  = 97, // <-- mark the end of the list or registers
}

//> RISCV instruction
riscv_insn :: enum i32 {
	INVALID         = 0,
	ADD             = 1,
	ADDI            = 2,
	ADDIW           = 3,
	ADDW            = 4,
	AMOADD_D        = 5,
	AMOADD_D_AQ     = 6,
	AMOADD_D_AQ_RL  = 7,
	AMOADD_D_RL     = 8,
	AMOADD_W        = 9,
	AMOADD_W_AQ     = 10,
	AMOADD_W_AQ_RL  = 11,
	AMOADD_W_RL     = 12,
	AMOAND_D        = 13,
	AMOAND_D_AQ     = 14,
	AMOAND_D_AQ_RL  = 15,
	AMOAND_D_RL     = 16,
	AMOAND_W        = 17,
	AMOAND_W_AQ     = 18,
	AMOAND_W_AQ_RL  = 19,
	AMOAND_W_RL     = 20,
	AMOMAXU_D       = 21,
	AMOMAXU_D_AQ    = 22,
	AMOMAXU_D_AQ_RL = 23,
	AMOMAXU_D_RL    = 24,
	AMOMAXU_W       = 25,
	AMOMAXU_W_AQ    = 26,
	AMOMAXU_W_AQ_RL = 27,
	AMOMAXU_W_RL    = 28,
	AMOMAX_D        = 29,
	AMOMAX_D_AQ     = 30,
	AMOMAX_D_AQ_RL  = 31,
	AMOMAX_D_RL     = 32,
	AMOMAX_W        = 33,
	AMOMAX_W_AQ     = 34,
	AMOMAX_W_AQ_RL  = 35,
	AMOMAX_W_RL     = 36,
	AMOMINU_D       = 37,
	AMOMINU_D_AQ    = 38,
	AMOMINU_D_AQ_RL = 39,
	AMOMINU_D_RL    = 40,
	AMOMINU_W       = 41,
	AMOMINU_W_AQ    = 42,
	AMOMINU_W_AQ_RL = 43,
	AMOMINU_W_RL    = 44,
	AMOMIN_D        = 45,
	AMOMIN_D_AQ     = 46,
	AMOMIN_D_AQ_RL  = 47,
	AMOMIN_D_RL     = 48,
	AMOMIN_W        = 49,
	AMOMIN_W_AQ     = 50,
	AMOMIN_W_AQ_RL  = 51,
	AMOMIN_W_RL     = 52,
	AMOOR_D         = 53,
	AMOOR_D_AQ      = 54,
	AMOOR_D_AQ_RL   = 55,
	AMOOR_D_RL      = 56,
	AMOOR_W         = 57,
	AMOOR_W_AQ      = 58,
	AMOOR_W_AQ_RL   = 59,
	AMOOR_W_RL      = 60,
	AMOSWAP_D       = 61,
	AMOSWAP_D_AQ    = 62,
	AMOSWAP_D_AQ_RL = 63,
	AMOSWAP_D_RL    = 64,
	AMOSWAP_W       = 65,
	AMOSWAP_W_AQ    = 66,
	AMOSWAP_W_AQ_RL = 67,
	AMOSWAP_W_RL    = 68,
	AMOXOR_D        = 69,
	AMOXOR_D_AQ     = 70,
	AMOXOR_D_AQ_RL  = 71,
	AMOXOR_D_RL     = 72,
	AMOXOR_W        = 73,
	AMOXOR_W_AQ     = 74,
	AMOXOR_W_AQ_RL  = 75,
	AMOXOR_W_RL     = 76,
	AND             = 77,
	ANDI            = 78,
	AUIPC           = 79,
	BEQ             = 80,
	BGE             = 81,
	BGEU            = 82,
	BLT             = 83,
	BLTU            = 84,
	BNE             = 85,
	CSRRC           = 86,
	CSRRCI          = 87,
	CSRRS           = 88,
	CSRRSI          = 89,
	CSRRW           = 90,
	CSRRWI          = 91,
	C_ADD           = 92,
	C_ADDI          = 93,
	C_ADDI16SP      = 94,
	C_ADDI4SPN      = 95,
	C_ADDIW         = 96,
	C_ADDW          = 97,
	C_AND           = 98,
	C_ANDI          = 99,
	C_BEQZ          = 100,
	C_BNEZ          = 101,
	C_EBREAK        = 102,
	C_FLD           = 103,
	C_FLDSP         = 104,
	C_FLW           = 105,
	C_FLWSP         = 106,
	C_FSD           = 107,
	C_FSDSP         = 108,
	C_FSW           = 109,
	C_FSWSP         = 110,
	C_J             = 111,
	C_JAL           = 112,
	C_JALR          = 113,
	C_JR            = 114,
	C_LD            = 115,
	C_LDSP          = 116,
	C_LI            = 117,
	C_LUI           = 118,
	C_LW            = 119,
	C_LWSP          = 120,
	C_MV            = 121,
	C_NOP           = 122,
	C_OR            = 123,
	C_SD            = 124,
	C_SDSP          = 125,
	C_SLLI          = 126,
	C_SRAI          = 127,
	C_SRLI          = 128,
	C_SUB           = 129,
	C_SUBW          = 130,
	C_SW            = 131,
	C_SWSP          = 132,
	C_UNIMP         = 133,
	C_XOR           = 134,
	DIV             = 135,
	DIVU            = 136,
	DIVUW           = 137,
	DIVW            = 138,
	EBREAK          = 139,
	ECALL           = 140,
	FADD_D          = 141,
	FADD_S          = 142,
	FCLASS_D        = 143,
	FCLASS_S        = 144,
	FCVT_D_L        = 145,
	FCVT_D_LU       = 146,
	FCVT_D_S        = 147,
	FCVT_D_W        = 148,
	FCVT_D_WU       = 149,
	FCVT_LU_D       = 150,
	FCVT_LU_S       = 151,
	FCVT_L_D        = 152,
	FCVT_L_S        = 153,
	FCVT_S_D        = 154,
	FCVT_S_L        = 155,
	FCVT_S_LU       = 156,
	FCVT_S_W        = 157,
	FCVT_S_WU       = 158,
	FCVT_WU_D       = 159,
	FCVT_WU_S       = 160,
	FCVT_W_D        = 161,
	FCVT_W_S        = 162,
	FDIV_D          = 163,
	FDIV_S          = 164,
	FENCE           = 165,
	FENCE_I         = 166,
	FENCE_TSO       = 167,
	FEQ_D           = 168,
	FEQ_S           = 169,
	FLD             = 170,
	FLE_D           = 171,
	FLE_S           = 172,
	FLT_D           = 173,
	FLT_S           = 174,
	FLW             = 175,
	FMADD_D         = 176,
	FMADD_S         = 177,
	FMAX_D          = 178,
	FMAX_S          = 179,
	FMIN_D          = 180,
	FMIN_S          = 181,
	FMSUB_D         = 182,
	FMSUB_S         = 183,
	FMUL_D          = 184,
	FMUL_S          = 185,
	FMV_D_X         = 186,
	FMV_W_X         = 187,
	FMV_X_D         = 188,
	FMV_X_W         = 189,
	FNMADD_D        = 190,
	FNMADD_S        = 191,
	FNMSUB_D        = 192,
	FNMSUB_S        = 193,
	FSD             = 194,
	FSGNJN_D        = 195,
	FSGNJN_S        = 196,
	FSGNJX_D        = 197,
	FSGNJX_S        = 198,
	FSGNJ_D         = 199,
	FSGNJ_S         = 200,
	FSQRT_D         = 201,
	FSQRT_S         = 202,
	FSUB_D          = 203,
	FSUB_S          = 204,
	FSW             = 205,
	JAL             = 206,
	JALR            = 207,
	LB              = 208,
	LBU             = 209,
	LD              = 210,
	LH              = 211,
	LHU             = 212,
	LR_D            = 213,
	LR_D_AQ         = 214,
	LR_D_AQ_RL      = 215,
	LR_D_RL         = 216,
	LR_W            = 217,
	LR_W_AQ         = 218,
	LR_W_AQ_RL      = 219,
	LR_W_RL         = 220,
	LUI             = 221,
	LW              = 222,
	LWU             = 223,
	MRET            = 224,
	MUL             = 225,
	MULH            = 226,
	MULHSU          = 227,
	MULHU           = 228,
	MULW            = 229,
	OR              = 230,
	ORI             = 231,
	REM             = 232,
	REMU            = 233,
	REMUW           = 234,
	REMW            = 235,
	SB              = 236,
	SC_D            = 237,
	SC_D_AQ         = 238,
	SC_D_AQ_RL      = 239,
	SC_D_RL         = 240,
	SC_W            = 241,
	SC_W_AQ         = 242,
	SC_W_AQ_RL      = 243,
	SC_W_RL         = 244,
	SD              = 245,
	SFENCE_VMA      = 246,
	SH              = 247,
	SLL             = 248,
	SLLI            = 249,
	SLLIW           = 250,
	SLLW            = 251,
	SLT             = 252,
	SLTI            = 253,
	SLTIU           = 254,
	SLTU            = 255,
	SRA             = 256,
	SRAI            = 257,
	SRAIW           = 258,
	SRAW            = 259,
	SRET            = 260,
	SRL             = 261,
	SRLI            = 262,
	SRLIW           = 263,
	SRLW            = 264,
	SUB             = 265,
	SUBW            = 266,
	SW              = 267,
	UNIMP           = 268,
	URET            = 269,
	WFI             = 270,
	XOR             = 271,
	XORI            = 272,
	ENDING          = 273,
}

//> Group of RISCV instructions
riscv_insn_group :: enum i32 {
	INVALID         = 0, ///< = CS_GRP_INVALID

	// Generic groups
	// all jump instructions (conditional+direct+indirect jumps)
	JUMP            = 1, ///< = CS_GRP_JUMP

	// all call instructions
	CALL            = 2, ///< = CS_GRP_CALL

	// all return instructions
	RET             = 3, ///< = CS_GRP_RET

	// all interrupt instructions (int+syscall)
	INT             = 4, ///< = CS_GRP_INT

	// all interrupt return instructions
	IRET            = 5, ///< = CS_GRP_IRET

	// all privileged instructions
	PRIVILEGE       = 6, ///< = CS_GRP_PRIVILEGE

	// all relative branching instructions
	BRANCH_RELATIVE = 7, ///< = CS_GRP_BRANCH_RELATIVE

	// Architecture-specific groups
	ISRV32          = 128,
	ISRV64          = 129,
	HASSTDEXTA      = 130,
	HASSTDEXTC      = 131,
	HASSTDEXTD      = 132,
	HASSTDEXTF      = 133,
	HASSTDEXTM      = 134,

	/*
	RISCV_GRP_ISRVA,
	RISCV_GRP_ISRVC,
	RISCV_GRP_ISRVD,
	RISCV_GRP_ISRVCD,
	RISCV_GRP_ISRVF,
	RISCV_GRP_ISRV32C,
	RISCV_GRP_ISRV32CF,
	RISCV_GRP_ISRVM,
	RISCV_GRP_ISRV64A,
	RISCV_GRP_ISRV64C,
	RISCV_GRP_ISRV64D,
	RISCV_GRP_ISRV64F,
	RISCV_GRP_ISRV64M,
	*/
	ENDING          = 135,
}

