/* Capstone Disassembly Engine */
/* TMS320C64x Backend by Fotis Loukos <me@fotisl.com> 2016 */
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


tms320c64x_op_type :: enum i32 {
	INVALID = 0,  ///< = CS_OP_INVALID (Uninitialized).
	REG     = 1,  ///< = CS_OP_REG (Register operand).
	IMM     = 2,  ///< = CS_OP_IMM (Immediate operand).
	MEM     = 3,  ///< = CS_OP_MEM (Memory operand).
	REGPAIR = 64, ///< Register pair for double word ops
}

tms320c64x_mem_disp :: enum i32 {
	INVALID  = 0,
	CONSTANT = 1,
	REGISTER = 2,
}

tms320c64x_mem_dir :: enum i32 {
	INVALID = 0,
	FW      = 1,
	BW      = 2,
}

tms320c64x_mem_mod :: enum i32 {
	INVALID = 0,
	NO      = 1,
	PRE     = 2,
	POST    = 3,
}

tms320c64x_op_mem :: struct {
	base:      u32, ///< base register
	disp:      u32, ///< displacement/offset value
	unit:      u32, ///< unit of base and offset register
	scaled:    u32, ///< offset scaled
	disptype:  u32, ///< displacement type
	direction: u32, ///< direction
	modify:    u32, ///< modification
}

tms320c64x_op :: struct {
	type: tms320c64x_op_type, ///< operand type

	using _: struct #raw_union {
		reg: u32,               ///< register value for REG operand or first register for REGPAIR operand
		imm: i32,               ///< immediate value for IMM operand
		mem: tms320c64x_op_mem, ///< base/disp value for MEM operand
	},
}

tms320c64x :: struct {
	op_count: u8,
	operands: [8]tms320c64x_op, ///< operands for this instruction.

	condition: struct {
		reg:  u32,
		zero: u32,
	},

	funit: struct {
		unit:      u32,
		side:      u32,
		crosspath: u32,
	},

	parallel: u32,
}

tms320c64x_reg :: enum i32 {
	INVALID = 0,
	AMR     = 1,
	CSR     = 2,
	DIER    = 3,
	DNUM    = 4,
	ECR     = 5,
	GFPGFR  = 6,
	GPLYA   = 7,
	GPLYB   = 8,
	ICR     = 9,
	IER     = 10,
	IERR    = 11,
	ILC     = 12,
	IRP     = 13,
	ISR     = 14,
	ISTP    = 15,
	ITSR    = 16,
	NRP     = 17,
	NTSR    = 18,
	REP     = 19,
	RILC    = 20,
	SSR     = 21,
	TSCH    = 22,
	TSCL    = 23,
	TSR     = 24,
	A0      = 25,
	A1      = 26,
	A2      = 27,
	A3      = 28,
	A4      = 29,
	A5      = 30,
	A6      = 31,
	A7      = 32,
	A8      = 33,
	A9      = 34,
	A10     = 35,
	A11     = 36,
	A12     = 37,
	A13     = 38,
	A14     = 39,
	A15     = 40,
	A16     = 41,
	A17     = 42,
	A18     = 43,
	A19     = 44,
	A20     = 45,
	A21     = 46,
	A22     = 47,
	A23     = 48,
	A24     = 49,
	A25     = 50,
	A26     = 51,
	A27     = 52,
	A28     = 53,
	A29     = 54,
	A30     = 55,
	A31     = 56,
	B0      = 57,
	B1      = 58,
	B2      = 59,
	B3      = 60,
	B4      = 61,
	B5      = 62,
	B6      = 63,
	B7      = 64,
	B8      = 65,
	B9      = 66,
	B10     = 67,
	B11     = 68,
	B12     = 69,
	B13     = 70,
	B14     = 71,
	B15     = 72,
	B16     = 73,
	B17     = 74,
	B18     = 75,
	B19     = 76,
	B20     = 77,
	B21     = 78,
	B22     = 79,
	B23     = 80,
	B24     = 81,
	B25     = 82,
	B26     = 83,
	B27     = 84,
	B28     = 85,
	B29     = 86,
	B30     = 87,
	B31     = 88,
	PCE1    = 89,
	ENDING  = 90, // <-- mark the end of the list of registers

	// Alias registers
	EFR     = 5,
	IFR     = 14,
}

tms320c64x_insn :: enum i32 {
	INVALID   = 0,
	ABS       = 1,
	ABS2      = 2,
	ADD       = 3,
	ADD2      = 4,
	ADD4      = 5,
	ADDAB     = 6,
	ADDAD     = 7,
	ADDAH     = 8,
	ADDAW     = 9,
	ADDK      = 10,
	ADDKPC    = 11,
	ADDU      = 12,
	AND       = 13,
	ANDN      = 14,
	AVG2      = 15,
	AVGU4     = 16,
	B         = 17,
	BDEC      = 18,
	BITC4     = 19,
	BNOP      = 20,
	BPOS      = 21,
	CLR       = 22,
	CMPEQ     = 23,
	CMPEQ2    = 24,
	CMPEQ4    = 25,
	CMPGT     = 26,
	CMPGT2    = 27,
	CMPGTU4   = 28,
	CMPLT     = 29,
	CMPLTU    = 30,
	DEAL      = 31,
	DOTP2     = 32,
	DOTPN2    = 33,
	DOTPNRSU2 = 34,
	DOTPRSU2  = 35,
	DOTPSU4   = 36,
	DOTPU4    = 37,
	EXT       = 38,
	EXTU      = 39,
	GMPGTU    = 40,
	GMPY4     = 41,
	LDB       = 42,
	LDBU      = 43,
	LDDW      = 44,
	LDH       = 45,
	LDHU      = 46,
	LDNDW     = 47,
	LDNW      = 48,
	LDW       = 49,
	LMBD      = 50,
	MAX2      = 51,
	MAXU4     = 52,
	MIN2      = 53,
	MINU4     = 54,
	MPY       = 55,
	MPY2      = 56,
	MPYH      = 57,
	MPYHI     = 58,
	MPYHIR    = 59,
	MPYHL     = 60,
	MPYHLU    = 61,
	MPYHSLU   = 62,
	MPYHSU    = 63,
	MPYHU     = 64,
	MPYHULS   = 65,
	MPYHUS    = 66,
	MPYLH     = 67,
	MPYLHU    = 68,
	MPYLI     = 69,
	MPYLIR    = 70,
	MPYLSHU   = 71,
	MPYLUHS   = 72,
	MPYSU     = 73,
	MPYSU4    = 74,
	MPYU      = 75,
	MPYU4     = 76,
	MPYUS     = 77,
	MVC       = 78,
	MVD       = 79,
	MVK       = 80,
	MVKL      = 81,
	MVKLH     = 82,
	NOP       = 83,
	NORM      = 84,
	OR        = 85,
	PACK2     = 86,
	PACKH2    = 87,
	PACKH4    = 88,
	PACKHL2   = 89,
	PACKL4    = 90,
	PACKLH2   = 91,
	ROTL      = 92,
	SADD      = 93,
	SADD2     = 94,
	SADDU4    = 95,
	SADDUS2   = 96,
	SAT       = 97,
	SET       = 98,
	SHFL      = 99,
	SHL       = 100,
	SHLMB     = 101,
	SHR       = 102,
	SHR2      = 103,
	SHRMB     = 104,
	SHRU      = 105,
	SHRU2     = 106,
	SMPY      = 107,
	SMPY2     = 108,
	SMPYH     = 109,
	SMPYHL    = 110,
	SMPYLH    = 111,
	SPACK2    = 112,
	SPACKU4   = 113,
	SSHL      = 114,
	SSHVL     = 115,
	SSHVR     = 116,
	SSUB      = 117,
	STB       = 118,
	STDW      = 119,
	STH       = 120,
	STNDW     = 121,
	STNW      = 122,
	STW       = 123,
	SUB       = 124,
	SUB2      = 125,
	SUB4      = 126,
	SUBAB     = 127,
	SUBABS4   = 128,
	SUBAH     = 129,
	SUBAW     = 130,
	SUBC      = 131,
	SUBU      = 132,
	SWAP4     = 133,
	UNPKHU4   = 134,
	UNPKLU4   = 135,
	XOR       = 136,
	XPND2     = 137,
	XPND4     = 138,

	// Aliases
	IDLE      = 139,
	MV        = 140,
	NEG       = 141,
	NOT       = 142,
	SWAP2     = 143,
	ZERO      = 144,
	ENDING    = 145, // <-- mark the end of the list of instructions
}

tms320c64x_insn_group :: enum i32 {
	INVALID  = 0,   ///< = CS_GRP_INVALID
	JUMP     = 1,   ///< = CS_GRP_JUMP
	FUNIT_D  = 128,
	FUNIT_L  = 129,
	FUNIT_M  = 130,
	FUNIT_S  = 131,
	FUNIT_NO = 132,
	ENDING   = 133, // <-- mark the end of the list of groups
}

tms320c64x_funit :: enum i32 {
	INVALID = 0,
	D       = 1,
	L       = 2,
	M       = 3,
	S       = 4,
	NO      = 5,
}

