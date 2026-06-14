package capstone

when ODIN_OS == .Windows {
	when #config(CAPSTONE_STATIC, false) {
		foreign import lib "lib/windows/capstone_static.lib"
	} else {
		foreign import lib "lib/windows/capstone.lib"
	}
} else {
	foreign import lib "system:capstone"
}

_ :: lib


M68K_OPERAND_COUNT :: 4

/// M68K registers and special registers
m68k_reg :: enum i32 {
	INVALID = 0,
	D0      = 1,
	D1      = 2,
	D2      = 3,
	D3      = 4,
	D4      = 5,
	D5      = 6,
	D6      = 7,
	D7      = 8,
	A0      = 9,
	A1      = 10,
	A2      = 11,
	A3      = 12,
	A4      = 13,
	A5      = 14,
	A6      = 15,
	A7      = 16,
	FP0     = 17,
	FP1     = 18,
	FP2     = 19,
	FP3     = 20,
	FP4     = 21,
	FP5     = 22,
	FP6     = 23,
	FP7     = 24,
	PC      = 25,
	SR      = 26,
	CCR     = 27,
	SFC     = 28,
	DFC     = 29,
	USP     = 30,
	VBR     = 31,
	CACR    = 32,
	CAAR    = 33,
	MSP     = 34,
	ISP     = 35,
	TC      = 36,
	ITT0    = 37,
	ITT1    = 38,
	DTT0    = 39,
	DTT1    = 40,
	MMUSR   = 41,
	URP     = 42,
	SRP     = 43,
	FPCR    = 44,
	FPSR    = 45,
	FPIAR   = 46,
	ENDING  = 47, // <-- mark the end of the list of registers
}

/// M68K Addressing Modes
m68k_address_mode :: enum i32 {
	NONE                   = 0,  ///< No address mode.
	REG_DIRECT_DATA        = 1,  ///< Register Direct - Data
	REG_DIRECT_ADDR        = 2,  ///< Register Direct - Address
	REGI_ADDR              = 3,  ///< Register Indirect - Address
	REGI_ADDR_POST_INC     = 4,  ///< Register Indirect - Address with Postincrement
	REGI_ADDR_PRE_DEC      = 5,  ///< Register Indirect - Address with Predecrement
	REGI_ADDR_DISP         = 6,  ///< Register Indirect - Address with Displacement
	AREGI_INDEX_8_BIT_DISP = 7,  ///< Address Register Indirect With Index- 8-bit displacement
	AREGI_INDEX_BASE_DISP  = 8,  ///< Address Register Indirect With Index- Base displacement
	MEMI_POST_INDEX        = 9,  ///< Memory indirect - Postindex
	MEMI_PRE_INDEX         = 10, ///< Memory indirect - Preindex
	PCI_DISP               = 11, ///< Program Counter Indirect - with Displacement
	PCI_INDEX_8_BIT_DISP   = 12, ///< Program Counter Indirect with Index - with 8-Bit Displacement
	PCI_INDEX_BASE_DISP    = 13, ///< Program Counter Indirect with Index - with Base Displacement
	PC_MEMI_POST_INDEX     = 14, ///< Program Counter Memory Indirect - Postindexed
	PC_MEMI_PRE_INDEX      = 15, ///< Program Counter Memory Indirect - Preindexed
	ABSOLUTE_DATA_SHORT    = 16, ///< Absolute Data Addressing  - Short
	ABSOLUTE_DATA_LONG     = 17, ///< Absolute Data Addressing  - Long
	IMMEDIATE              = 18, ///< Immediate value
	BRANCH_DISPLACEMENT    = 19, ///< Address as displacement from (PC+2) used by branches
}

/// Operand type for instruction's operands
m68k_op_type :: enum i32 {
	INVALID   = 0, ///< = CS_OP_INVALID (Uninitialized).
	REG       = 1, ///< = CS_OP_REG (Register operand).
	IMM       = 2, ///< = CS_OP_IMM (Immediate operand).
	MEM       = 3, ///< = CS_OP_MEM (Memory operand).
	FP_SINGLE = 4, ///< single precision Floating-Point operand
	FP_DOUBLE = 5, ///< double precision Floating-Point operand
	REG_BITS  = 6, ///< Register bits move
	REG_PAIR  = 7, ///< Register pair in the same op (upper 4 bits for first reg, lower for second)
	BR_DISP   = 8, ///< Branch displacement
}

/// Instruction's operand referring to memory
/// This is associated with M68K_OP_MEM operand type above
m68k_op_mem :: struct {
	base_reg:    m68k_reg, ///< base register (or M68K_REG_INVALID if irrelevant)
	index_reg:   m68k_reg, ///< index register (or M68K_REG_INVALID if irrelevant)
	in_base_reg: m68k_reg, ///< indirect base register (or M68K_REG_INVALID if irrelevant)
	in_disp:     u32,      ///< indirect displacement
	out_disp:    u32,      ///< other displacement
	disp:        i16,      ///< displacement value
	scale:       u8,       ///< scale for index register
	bitfield:    u8,       ///< set to true if the two values below should be used
	width:       u8,       ///< used for bf* instructions
	offset:      u8,       ///< used for bf* instructions
	index_size:  u8,       ///< 0 = w, 1 = l
}

/// Operand type for instruction's operands
m68k_op_br_disp_size :: enum i32 {
	INVALID = 0, ///< = CS_OP_INVALID (Uninitialized).
	BYTE    = 1, ///< signed 8-bit displacement
	WORD    = 2, ///< signed 16-bit displacement
	LONG    = 4, ///< signed 32-bit displacement
}

m68k_op_br_disp :: struct {
	disp:      i32, ///< displacement value
	disp_size: u8,  ///< Size from m68k_op_br_disp_size type above
}

/// Register pair in one operand.
m68k_op_reg_pair :: struct {
	reg_0: m68k_reg,
	reg_1: m68k_reg,
}

/// Instruction operand
m68k_op :: struct {
	using _: struct #raw_union {
		imm:      u64,              ///< immediate value for IMM operand
		dimm:     f64,              ///< double imm
		simm:     f32,              ///< float imm
		reg:      m68k_reg,         ///< register value for REG operand
		reg_pair: m68k_op_reg_pair, ///< register pair in one operand
	},

	mem:           m68k_op_mem,       ///< data when operand is targeting memory
	br_disp:       m68k_op_br_disp,   ///< data when operand is a branch displacement
	register_bits: u32,               ///< register bits for movem etc. (always in d0-d7, a0-a7, fp0 - fp7 order)
	type:          m68k_op_type,
	address_mode:  m68k_address_mode, ///< M68K addressing mode for this op
}

/// Operation size of the CPU instructions
m68k_cpu_size :: enum i32 {
	NONE = 0, ///< unsized or unspecified
	BYTE = 1, ///< 1 byte in size
	WORD = 2, ///< 2 bytes in size
	LONG = 4, ///< 4 bytes in size
}

/// Operation size of the FPU instructions (Notice that FPU instruction can also use CPU sizes if needed)
m68k_fpu_size :: enum i32 {
	NONE     = 0,  ///< unsized like fsave/frestore
	SINGLE   = 4,  ///< 4 byte in size (single float)
	DOUBLE   = 8,  ///< 8 byte in size (double)
	EXTENDED = 12, ///< 12 byte in size (extended real format)
}

/// Type of size that is being used for the current instruction
m68k_size_type :: enum i32 {
	INVALID = 0,
	CPU     = 1,
	FPU     = 2,
}

/// Operation size of the current instruction (NOT the actually size of instruction)
m68k_op_size :: struct {
	type: m68k_size_type,

	using _: struct #raw_union {
		cpu_size: m68k_cpu_size,
		fpu_size: m68k_fpu_size,
	},
}

/// The M68K instruction and it's operands
m68k :: struct {
	// Number of operands of this instruction or 0 when instruction has no operand.
	operands: [4]m68k_op,   ///< operands for this instruction.
	op_size:  m68k_op_size, ///< size of data operand works on in bytes (.b, .w, .l, etc)
	op_count: u8,           ///< number of operands for the instruction
}

/// M68K instruction
m68k_insn :: enum i32 {
	INVALID   = 0,
	ABCD      = 1,
	ADD       = 2,
	ADDA      = 3,
	ADDI      = 4,
	ADDQ      = 5,
	ADDX      = 6,
	AND       = 7,
	ANDI      = 8,
	ASL       = 9,
	ASR       = 10,
	BHS       = 11,
	BLO       = 12,
	BHI       = 13,
	BLS       = 14,
	BCC       = 15,
	BCS       = 16,
	BNE       = 17,
	BEQ       = 18,
	BVC       = 19,
	BVS       = 20,
	BPL       = 21,
	BMI       = 22,
	BGE       = 23,
	BLT       = 24,
	BGT       = 25,
	BLE       = 26,
	BRA       = 27,
	BSR       = 28,
	BCHG      = 29,
	BCLR      = 30,
	BSET      = 31,
	BTST      = 32,
	BFCHG     = 33,
	BFCLR     = 34,
	BFEXTS    = 35,
	BFEXTU    = 36,
	BFFFO     = 37,
	BFINS     = 38,
	BFSET     = 39,
	BFTST     = 40,
	BKPT      = 41,
	CALLM     = 42,
	CAS       = 43,
	CAS2      = 44,
	CHK       = 45,
	CHK2      = 46,
	CLR       = 47,
	CMP       = 48,
	CMPA      = 49,
	CMPI      = 50,
	CMPM      = 51,
	CMP2      = 52,
	CINVL     = 53,
	CINVP     = 54,
	CINVA     = 55,
	CPUSHL    = 56,
	CPUSHP    = 57,
	CPUSHA    = 58,
	DBT       = 59,
	DBF       = 60,
	DBHI      = 61,
	DBLS      = 62,
	DBCC      = 63,
	DBCS      = 64,
	DBNE      = 65,
	DBEQ      = 66,
	DBVC      = 67,
	DBVS      = 68,
	DBPL      = 69,
	DBMI      = 70,
	DBGE      = 71,
	DBLT      = 72,
	DBGT      = 73,
	DBLE      = 74,
	DBRA      = 75,
	DIVS      = 76,
	DIVSL     = 77,
	DIVU      = 78,
	DIVUL     = 79,
	EOR       = 80,
	EORI      = 81,
	EXG       = 82,
	EXT       = 83,
	EXTB      = 84,
	FABS      = 85,
	FSABS     = 86,
	FDABS     = 87,
	FACOS     = 88,
	FADD      = 89,
	FSADD     = 90,
	FDADD     = 91,
	FASIN     = 92,
	FATAN     = 93,
	FATANH    = 94,
	FBF       = 95,
	FBEQ      = 96,
	FBOGT     = 97,
	FBOGE     = 98,
	FBOLT     = 99,
	FBOLE     = 100,
	FBOGL     = 101,
	FBOR      = 102,
	FBUN      = 103,
	FBUEQ     = 104,
	FBUGT     = 105,
	FBUGE     = 106,
	FBULT     = 107,
	FBULE     = 108,
	FBNE      = 109,
	FBT       = 110,
	FBSF      = 111,
	FBSEQ     = 112,
	FBGT      = 113,
	FBGE      = 114,
	FBLT      = 115,
	FBLE      = 116,
	FBGL      = 117,
	FBGLE     = 118,
	FBNGLE    = 119,
	FBNGL     = 120,
	FBNLE     = 121,
	FBNLT     = 122,
	FBNGE     = 123,
	FBNGT     = 124,
	FBSNE     = 125,
	FBST      = 126,
	FCMP      = 127,
	FCOS      = 128,
	FCOSH     = 129,
	FDBF      = 130,
	FDBEQ     = 131,
	FDBOGT    = 132,
	FDBOGE    = 133,
	FDBOLT    = 134,
	FDBOLE    = 135,
	FDBOGL    = 136,
	FDBOR     = 137,
	FDBUN     = 138,
	FDBUEQ    = 139,
	FDBUGT    = 140,
	FDBUGE    = 141,
	FDBULT    = 142,
	FDBULE    = 143,
	FDBNE     = 144,
	FDBT      = 145,
	FDBSF     = 146,
	FDBSEQ    = 147,
	FDBGT     = 148,
	FDBGE     = 149,
	FDBLT     = 150,
	FDBLE     = 151,
	FDBGL     = 152,
	FDBGLE    = 153,
	FDBNGLE   = 154,
	FDBNGL    = 155,
	FDBNLE    = 156,
	FDBNLT    = 157,
	FDBNGE    = 158,
	FDBNGT    = 159,
	FDBSNE    = 160,
	FDBST     = 161,
	FDIV      = 162,
	FSDIV     = 163,
	FDDIV     = 164,
	FETOX     = 165,
	FETOXM1   = 166,
	FGETEXP   = 167,
	FGETMAN   = 168,
	FINT      = 169,
	FINTRZ    = 170,
	FLOG10    = 171,
	FLOG2     = 172,
	FLOGN     = 173,
	FLOGNP1   = 174,
	FMOD      = 175,
	FMOVE     = 176,
	FSMOVE    = 177,
	FDMOVE    = 178,
	FMOVECR   = 179,
	FMOVEM    = 180,
	FMUL      = 181,
	FSMUL     = 182,
	FDMUL     = 183,
	FNEG      = 184,
	FSNEG     = 185,
	FDNEG     = 186,
	FNOP      = 187,
	FREM      = 188,
	FRESTORE  = 189,
	FSAVE     = 190,
	FSCALE    = 191,
	FSGLDIV   = 192,
	FSGLMUL   = 193,
	FSIN      = 194,
	FSINCOS   = 195,
	FSINH     = 196,
	FSQRT     = 197,
	FSSQRT    = 198,
	FDSQRT    = 199,
	FSF       = 200,
	FSBEQ     = 201,
	FSOGT     = 202,
	FSOGE     = 203,
	FSOLT     = 204,
	FSOLE     = 205,
	FSOGL     = 206,
	FSOR      = 207,
	FSUN      = 208,
	FSUEQ     = 209,
	FSUGT     = 210,
	FSUGE     = 211,
	FSULT     = 212,
	FSULE     = 213,
	FSNE      = 214,
	FST       = 215,
	FSSF      = 216,
	FSSEQ     = 217,
	FSGT      = 218,
	FSGE      = 219,
	FSLT      = 220,
	FSLE      = 221,
	FSGL      = 222,
	FSGLE     = 223,
	FSNGLE    = 224,
	FSNGL     = 225,
	FSNLE     = 226,
	FSNLT     = 227,
	FSNGE     = 228,
	FSNGT     = 229,
	FSSNE     = 230,
	FSST      = 231,
	FSUB      = 232,
	FSSUB     = 233,
	FDSUB     = 234,
	FTAN      = 235,
	FTANH     = 236,
	FTENTOX   = 237,
	FTRAPF    = 238,
	FTRAPEQ   = 239,
	FTRAPOGT  = 240,
	FTRAPOGE  = 241,
	FTRAPOLT  = 242,
	FTRAPOLE  = 243,
	FTRAPOGL  = 244,
	FTRAPOR   = 245,
	FTRAPUN   = 246,
	FTRAPUEQ  = 247,
	FTRAPUGT  = 248,
	FTRAPUGE  = 249,
	FTRAPULT  = 250,
	FTRAPULE  = 251,
	FTRAPNE   = 252,
	FTRAPT    = 253,
	FTRAPSF   = 254,
	FTRAPSEQ  = 255,
	FTRAPGT   = 256,
	FTRAPGE   = 257,
	FTRAPLT   = 258,
	FTRAPLE   = 259,
	FTRAPGL   = 260,
	FTRAPGLE  = 261,
	FTRAPNGLE = 262,
	FTRAPNGL  = 263,
	FTRAPNLE  = 264,
	FTRAPNLT  = 265,
	FTRAPNGE  = 266,
	FTRAPNGT  = 267,
	FTRAPSNE  = 268,
	FTRAPST   = 269,
	FTST      = 270,
	FTWOTOX   = 271,
	HALT      = 272,
	ILLEGAL   = 273,
	JMP       = 274,
	JSR       = 275,
	LEA       = 276,
	LINK      = 277,
	LPSTOP    = 278,
	LSL       = 279,
	LSR       = 280,
	MOVE      = 281,
	MOVEA     = 282,
	MOVEC     = 283,
	MOVEM     = 284,
	MOVEP     = 285,
	MOVEQ     = 286,
	MOVES     = 287,
	MOVE16    = 288,
	MULS      = 289,
	MULU      = 290,
	NBCD      = 291,
	NEG       = 292,
	NEGX      = 293,
	NOP       = 294,
	NOT       = 295,
	OR        = 296,
	ORI       = 297,
	PACK      = 298,
	PEA       = 299,
	PFLUSH    = 300,
	PFLUSHA   = 301,
	PFLUSHAN  = 302,
	PFLUSHN   = 303,
	PLOADR    = 304,
	PLOADW    = 305,
	PLPAR     = 306,
	PLPAW     = 307,
	PMOVE     = 308,
	PMOVEFD   = 309,
	PTESTR    = 310,
	PTESTW    = 311,
	PULSE     = 312,
	REMS      = 313,
	REMU      = 314,
	RESET     = 315,
	ROL       = 316,
	ROR       = 317,
	ROXL      = 318,
	ROXR      = 319,
	RTD       = 320,
	RTE       = 321,
	RTM       = 322,
	RTR       = 323,
	RTS       = 324,
	SBCD      = 325,
	ST        = 326,
	SF        = 327,
	SHI       = 328,
	SLS       = 329,
	SCC       = 330,
	SHS       = 331,
	SCS       = 332,
	SLO       = 333,
	SNE       = 334,
	SEQ       = 335,
	SVC       = 336,
	SVS       = 337,
	SPL       = 338,
	SMI       = 339,
	SGE       = 340,
	SLT       = 341,
	SGT       = 342,
	SLE       = 343,
	STOP      = 344,
	SUB       = 345,
	SUBA      = 346,
	SUBI      = 347,
	SUBQ      = 348,
	SUBX      = 349,
	SWAP      = 350,
	TAS       = 351,
	TRAP      = 352,
	TRAPV     = 353,
	TRAPT     = 354,
	TRAPF     = 355,
	TRAPHI    = 356,
	TRAPLS    = 357,
	TRAPCC    = 358,
	TRAPHS    = 359,
	TRAPCS    = 360,
	TRAPLO    = 361,
	TRAPNE    = 362,
	TRAPEQ    = 363,
	TRAPVC    = 364,
	TRAPVS    = 365,
	TRAPPL    = 366,
	TRAPMI    = 367,
	TRAPGE    = 368,
	TRAPLT    = 369,
	TRAPGT    = 370,
	TRAPLE    = 371,
	TST       = 372,
	UNLK      = 373,
	UNPK      = 374,
	ENDING    = 375, // <-- mark the end of the list of instructions
}

/// Group of M68K instructions
m68k_group_type :: enum i32 {
	INVALID         = 0, ///< CS_GRUP_INVALID
	JUMP            = 1, ///< = CS_GRP_JUMP
	RET             = 3, ///< = CS_GRP_RET
	IRET            = 5, ///< = CS_GRP_IRET
	BRANCH_RELATIVE = 7, ///< = CS_GRP_BRANCH_RELATIVE
	ENDING          = 8, // <-- mark the end of the list of groups
}

