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


/// ARM shift type
arm_shifter :: enum i32 {
	INVALID = 0,
	ASR     = 1,  ///< shift with immediate const
	LSL     = 2,  ///< shift with immediate const
	LSR     = 3,  ///< shift with immediate const
	ROR     = 4,  ///< shift with immediate const
	RRX     = 5,  ///< shift with immediate const
	ASR_REG = 6,  ///< shift with register
	LSL_REG = 7,  ///< shift with register
	LSR_REG = 8,  ///< shift with register
	ROR_REG = 9,  ///< shift with register
	RRX_REG = 10, ///< shift with register
}

/// ARM condition code
arm_cc :: enum i32 {
	INVALID = 0,
	EQ      = 1,  ///< Equal                      Equal
	NE      = 2,  ///< Not equal                  Not equal, or unordered
	HS      = 3,  ///< Carry set                  >, ==, or unordered
	LO      = 4,  ///< Carry clear                Less than
	MI      = 5,  ///< Minus, negative            Less than
	PL      = 6,  ///< Plus, positive or zero     >, ==, or unordered
	VS      = 7,  ///< Overflow                   Unordered
	VC      = 8,  ///< No overflow                Not unordered
	HI      = 9,  ///< Unsigned higher            Greater than, or unordered
	LS      = 10, ///< Unsigned lower or same     Less than or equal
	GE      = 11, ///< Greater than or equal      Greater than or equal
	LT      = 12, ///< Less than                  Less than, or unordered
	GT      = 13, ///< Greater than               Greater than
	LE      = 14, ///< Less than or equal         <, ==, or unordered
	AL      = 15, ///< Always (unconditional)     Always (unconditional)
}

arm_sysreg :: enum i32 {
	/// Special registers for MSR
	INVALID      = 0,

	// SPSR* registers can be OR combined
	SPSR_C       = 1,
	SPSR_X       = 2,
	SPSR_S       = 4,
	SPSR_F       = 8,

	// CPSR* registers can be OR combined
	CPSR_C       = 16,
	CPSR_X       = 32,
	CPSR_S       = 64,
	CPSR_F       = 128,

	// independent registers
	APSR         = 256,
	APSR_G       = 257,
	APSR_NZCVQ   = 258,
	APSR_NZCVQG  = 259,
	IAPSR        = 260,
	IAPSR_G      = 261,
	IAPSR_NZCVQG = 262,
	IAPSR_NZCVQ  = 263,
	EAPSR        = 264,
	EAPSR_G      = 265,
	EAPSR_NZCVQG = 266,
	EAPSR_NZCVQ  = 267,
	XPSR         = 268,
	XPSR_G       = 269,
	XPSR_NZCVQG  = 270,
	XPSR_NZCVQ   = 271,
	IPSR         = 272,
	EPSR         = 273,
	IEPSR        = 274,
	MSP          = 275,
	PSP          = 276,
	PRIMASK      = 277,
	BASEPRI      = 278,
	BASEPRI_MAX  = 279,
	FAULTMASK    = 280,
	CONTROL      = 281,
	MSPLIM       = 282,
	PSPLIM       = 283,
	MSP_NS       = 284,
	PSP_NS       = 285,
	MSPLIM_NS    = 286,
	PSPLIM_NS    = 287,
	PRIMASK_NS   = 288,
	BASEPRI_NS   = 289,
	FAULTMASK_NS = 290,
	CONTROL_NS   = 291,
	SP_NS        = 292,

	// Banked Registers
	R8_USR       = 293,
	R9_USR       = 294,
	R10_USR      = 295,
	R11_USR      = 296,
	R12_USR      = 297,
	SP_USR       = 298,
	LR_USR       = 299,
	R8_FIQ       = 300,
	R9_FIQ       = 301,
	R10_FIQ      = 302,
	R11_FIQ      = 303,
	R12_FIQ      = 304,
	SP_FIQ       = 305,
	LR_FIQ       = 306,
	LR_IRQ       = 307,
	SP_IRQ       = 308,
	LR_SVC       = 309,
	SP_SVC       = 310,
	LR_ABT       = 311,
	SP_ABT       = 312,
	LR_UND       = 313,
	SP_UND       = 314,
	LR_MON       = 315,
	SP_MON       = 316,
	ELR_HYP      = 317,
	SP_HYP       = 318,
	SPSR_FIQ     = 319,
	SPSR_IRQ     = 320,
	SPSR_SVC     = 321,
	SPSR_ABT     = 322,
	SPSR_UND     = 323,
	SPSR_MON     = 324,
	SPSR_HYP     = 325,
}

/// The memory barrier constants map directly to the 4-bit encoding of
/// the option field for Memory Barrier operations.
arm_mem_barrier :: enum i32 {
	INVALID     = 0,
	RESERVED_0  = 1,
	OSHLD       = 2,
	OSHST       = 3,
	OSH         = 4,
	RESERVED_4  = 5,
	NSHLD       = 6,
	NSHST       = 7,
	NSH         = 8,
	RESERVED_8  = 9,
	ISHLD       = 10,
	ISHST       = 11,
	ISH         = 12,
	RESERVED_12 = 13,
	LD          = 14,
	ST          = 15,
	SY          = 16,
}

/// Operand type for instruction's operands
arm_op_type :: enum i32 {
	INVALID = 0,  ///< = CS_OP_INVALID (Uninitialized).
	REG     = 1,  ///< = CS_OP_REG (Register operand).
	IMM     = 2,  ///< = CS_OP_IMM (Immediate operand).
	MEM     = 3,  ///< = CS_OP_MEM (Memory operand).
	FP      = 4,  ///< = CS_OP_FP (Floating-Point operand).
	CIMM    = 64, ///< C-Immediate (coprocessor registers)
	PIMM    = 65, ///< P-Immediate (coprocessor registers)
	SETEND  = 66, ///< operand for SETEND instruction
	SYSREG  = 67, ///< MSR/MRS special register operand
}

/// Operand type for SETEND instruction
arm_setend_type :: enum i32 {
	INVALID = 0, ///< Uninitialized.
	BE      = 1, ///< BE operand.
	LE      = 2, ///< LE operand
}

arm_cpsmode_type :: enum i32 {
	INVALID = 0,
	IE      = 2,
	ID      = 3,
}

/// Operand type for SETEND instruction
arm_cpsflag_type :: enum i32 {
	INVALID = 0,
	F       = 1,
	I       = 2,
	A       = 4,
	NONE    = 16, ///< no flag
}

/// Data type for elements of vector instructions.
arm_vectordata_type :: enum i32 {
	INVALID = 0,

	// Integer type
	I8      = 1,
	I16     = 2,
	I32     = 3,
	I64     = 4,

	// Signed integer type
	S8      = 5,
	S16     = 6,
	S32     = 7,
	S64     = 8,

	// Unsigned integer type
	U8      = 9,
	U16     = 10,
	U32     = 11,
	U64     = 12,

	// Data type for VMUL/VMULL
	P8      = 13,

	// Floating type
	F16     = 14,
	F32     = 15,
	F64     = 16,

	// Convert float <-> float
	F16F64  = 17, // f16.f64
	F64F16  = 18, // f64.f16
	F32F16  = 19, // f32.f16
	F16F32  = 20, // f32.f16
	F64F32  = 21, // f64.f32
	F32F64  = 22, // f32.f64

	// Convert integer <-> float
	S32F32  = 23, // s32.f32
	U32F32  = 24, // u32.f32
	F32S32  = 25, // f32.s32
	F32U32  = 26, // f32.u32
	F64S16  = 27, // f64.s16
	F32S16  = 28, // f32.s16
	F64S32  = 29, // f64.s32
	S16F64  = 30, // s16.f64
	S16F32  = 31, // s16.f64
	S32F64  = 32, // s32.f64
	U16F64  = 33, // u16.f64
	U16F32  = 34, // u16.f32
	U32F64  = 35, // u32.f64
	F64U16  = 36, // f64.u16
	F32U16  = 37, // f32.u16
	F64U32  = 38, // f64.u32
	F16U16  = 39, // f16.u16
	U16F16  = 40, // u16.f16
	F16U32  = 41, // f16.u32
	U32F16  = 42, // u32.f16
}

/// ARM registers
arm_reg :: enum i32 {
	INVALID    = 0,
	APSR       = 1,
	APSR_NZCV  = 2,
	CPSR       = 3,
	FPEXC      = 4,
	FPINST     = 5,
	FPSCR      = 6,
	FPSCR_NZCV = 7,
	FPSID      = 8,
	ITSTATE    = 9,
	LR         = 10,
	PC         = 11,
	SP         = 12,
	SPSR       = 13,
	D0         = 14,
	D1         = 15,
	D2         = 16,
	D3         = 17,
	D4         = 18,
	D5         = 19,
	D6         = 20,
	D7         = 21,
	D8         = 22,
	D9         = 23,
	D10        = 24,
	D11        = 25,
	D12        = 26,
	D13        = 27,
	D14        = 28,
	D15        = 29,
	D16        = 30,
	D17        = 31,
	D18        = 32,
	D19        = 33,
	D20        = 34,
	D21        = 35,
	D22        = 36,
	D23        = 37,
	D24        = 38,
	D25        = 39,
	D26        = 40,
	D27        = 41,
	D28        = 42,
	D29        = 43,
	D30        = 44,
	D31        = 45,
	FPINST2    = 46,
	MVFR0      = 47,
	MVFR1      = 48,
	MVFR2      = 49,
	Q0         = 50,
	Q1         = 51,
	Q2         = 52,
	Q3         = 53,
	Q4         = 54,
	Q5         = 55,
	Q6         = 56,
	Q7         = 57,
	Q8         = 58,
	Q9         = 59,
	Q10        = 60,
	Q11        = 61,
	Q12        = 62,
	Q13        = 63,
	Q14        = 64,
	Q15        = 65,
	R0         = 66,
	R1         = 67,
	R2         = 68,
	R3         = 69,
	R4         = 70,
	R5         = 71,
	R6         = 72,
	R7         = 73,
	R8         = 74,
	R9         = 75,
	R10        = 76,
	R11        = 77,
	R12        = 78,
	S0         = 79,
	S1         = 80,
	S2         = 81,
	S3         = 82,
	S4         = 83,
	S5         = 84,
	S6         = 85,
	S7         = 86,
	S8         = 87,
	S9         = 88,
	S10        = 89,
	S11        = 90,
	S12        = 91,
	S13        = 92,
	S14        = 93,
	S15        = 94,
	S16        = 95,
	S17        = 96,
	S18        = 97,
	S19        = 98,
	S20        = 99,
	S21        = 100,
	S22        = 101,
	S23        = 102,
	S24        = 103,
	S25        = 104,
	S26        = 105,
	S27        = 106,
	S28        = 107,
	S29        = 108,
	S30        = 109,
	S31        = 110,
	ENDING     = 111, // <-- mark the end of the list or registers

	// alias registers
	R13        = 12,
	R14        = 10,
	R15        = 11,
	SB         = 75,
	SL         = 76,
	FP         = 77,
	IP         = 78,
}

/// Instruction's operand referring to memory
/// This is associated with ARM_OP_MEM operand type above
arm_op_mem :: struct {
	base:  arm_reg, ///< base register
	index: arm_reg, ///< index register
	scale: i32,     ///< scale for index register (can be 1, or -1)
	disp:  i32,     ///< displacement/offset value

	/// left-shift on index register, or 0 if irrelevant
	/// NOTE: this value can also be fetched via operand.shift.value
	lshift: i32,
}

/// Instruction operand
arm_op :: struct {
	vector_index: i32, ///< Vector Index for some vector operands (or -1 if irrelevant)

	shift: struct {
		type:  arm_shifter,
		value: u32,
	},

	type: arm_op_type, ///< operand type

	using _: struct #raw_union {
		reg:    i32,             ///< register value for REG/SYSREG operand
		imm:    i32,             ///< immediate value for C-IMM, P-IMM or IMM operand
		fp:     f64,             ///< floating point value for FP operand
		mem:    arm_op_mem,      ///< base/index/scale/disp value for MEM operand
		setend: arm_setend_type, ///< SETEND instruction's operand type
	},

	/// in some instructions, an operand can be subtracted or added to
	/// the base register,
	/// if TRUE, this operand is subtracted. otherwise, it is added.
	subtracted: bool,

	/// How is this operand accessed? (READ, WRITE or READ|WRITE)
	/// This field is combined of cs_ac_type.
	/// NOTE: this field is irrelevant if engine is compiled in DIET mode.
	access: u8,

	/// Neon lane index for NEON instructions (or -1 if irrelevant)
	neon_lane: i8,
}

/// Instruction structure
arm :: struct {
	usermode:     bool,                ///< User-mode registers to be loaded (for LDM/STM instructions)
	vector_size:  i32,                 ///< Scalar size for vector instructions
	vector_data:  arm_vectordata_type, ///< Data type for elements of vector instructions
	cps_mode:     arm_cpsmode_type,    ///< CPS mode for CPS instruction
	cps_flag:     arm_cpsflag_type,    ///< CPS mode for CPS instruction
	cc:           arm_cc,              ///< conditional code for this insn
	update_flags: bool,                ///< does this insn update flags?
	writeback:    bool,                ///< does this insn write-back?
	post_index:   bool,                ///< only set if writeback is 'True', if 'False' pre-index, otherwise post.
	mem_barrier:  arm_mem_barrier,     ///< Option for some memory barrier instructions

	/// Number of operands of this instruction,
	/// or 0 when instruction has no operand.
	op_count: u8,
	operands: [36]arm_op, ///< operands for this instruction.
}

/// ARM instruction
arm_insn :: enum i32 {
	INVALID   = 0,
	ADC       = 1,
	ADD       = 2,
	ADDW      = 3,
	ADR       = 4,
	AESD      = 5,
	AESE      = 6,
	AESIMC    = 7,
	AESMC     = 8,
	AND       = 9,
	ASR       = 10,
	B         = 11,
	BFC       = 12,
	BFI       = 13,
	BIC       = 14,
	BKPT      = 15,
	BL        = 16,
	BLX       = 17,
	BLXNS     = 18,
	BX        = 19,
	BXJ       = 20,
	BXNS      = 21,
	CBNZ      = 22,
	CBZ       = 23,
	CDP       = 24,
	CDP2      = 25,
	CLREX     = 26,
	CLZ       = 27,
	CMN       = 28,
	CMP       = 29,
	CPS       = 30,
	CRC32B    = 31,
	CRC32CB   = 32,
	CRC32CH   = 33,
	CRC32CW   = 34,
	CRC32H    = 35,
	CRC32W    = 36,
	CSDB      = 37,
	DBG       = 38,
	DCPS1     = 39,
	DCPS2     = 40,
	DCPS3     = 41,
	DFB       = 42,
	DMB       = 43,
	DSB       = 44,
	EOR       = 45,
	ERET      = 46,
	ESB       = 47,
	FADDD     = 48,
	FADDS     = 49,
	FCMPZD    = 50,
	FCMPZS    = 51,
	FCONSTD   = 52,
	FCONSTS   = 53,
	FLDMDBX   = 54,
	FLDMIAX   = 55,
	FMDHR     = 56,
	FMDLR     = 57,
	FMSTAT    = 58,
	FSTMDBX   = 59,
	FSTMIAX   = 60,
	FSUBD     = 61,
	FSUBS     = 62,
	HINT      = 63,
	HLT       = 64,
	HVC       = 65,
	ISB       = 66,
	IT        = 67,
	LDA       = 68,
	LDAB      = 69,
	LDAEX     = 70,
	LDAEXB    = 71,
	LDAEXD    = 72,
	LDAEXH    = 73,
	LDAH      = 74,
	LDC       = 75,
	LDC2      = 76,
	LDC2L     = 77,
	LDCL      = 78,
	LDM       = 79,
	LDMDA     = 80,
	LDMDB     = 81,
	LDMIB     = 82,
	LDR       = 83,
	LDRB      = 84,
	LDRBT     = 85,
	LDRD      = 86,
	LDREX     = 87,
	LDREXB    = 88,
	LDREXD    = 89,
	LDREXH    = 90,
	LDRH      = 91,
	LDRHT     = 92,
	LDRSB     = 93,
	LDRSBT    = 94,
	LDRSH     = 95,
	LDRSHT    = 96,
	LDRT      = 97,
	LSL       = 98,
	LSR       = 99,
	MCR       = 100,
	MCR2      = 101,
	MCRR      = 102,
	MCRR2     = 103,
	MLA       = 104,
	MLS       = 105,
	MOV       = 106,
	MOVS      = 107,
	MOVT      = 108,
	MOVW      = 109,
	MRC       = 110,
	MRC2      = 111,
	MRRC      = 112,
	MRRC2     = 113,
	MRS       = 114,
	MSR       = 115,
	MUL       = 116,
	MVN       = 117,
	NEG       = 118,
	NOP       = 119,
	ORN       = 120,
	ORR       = 121,
	PKHBT     = 122,
	PKHTB     = 123,
	PLD       = 124,
	PLDW      = 125,
	PLI       = 126,
	POP       = 127,
	PUSH      = 128,
	QADD      = 129,
	QADD16    = 130,
	QADD8     = 131,
	QASX      = 132,
	QDADD     = 133,
	QDSUB     = 134,
	QSAX      = 135,
	QSUB      = 136,
	QSUB16    = 137,
	QSUB8     = 138,
	RBIT      = 139,
	REV       = 140,
	REV16     = 141,
	REVSH     = 142,
	RFEDA     = 143,
	RFEDB     = 144,
	RFEIA     = 145,
	RFEIB     = 146,
	ROR       = 147,
	RRX       = 148,
	RSB       = 149,
	RSC       = 150,
	SADD16    = 151,
	SADD8     = 152,
	SASX      = 153,
	SBC       = 154,
	SBFX      = 155,
	SDIV      = 156,
	SEL       = 157,
	SETEND    = 158,
	SETPAN    = 159,
	SEV       = 160,
	SEVL      = 161,
	SG        = 162,
	SHA1C     = 163,
	SHA1H     = 164,
	SHA1M     = 165,
	SHA1P     = 166,
	SHA1SU0   = 167,
	SHA1SU1   = 168,
	SHA256H   = 169,
	SHA256H2  = 170,
	SHA256SU0 = 171,
	SHA256SU1 = 172,
	SHADD16   = 173,
	SHADD8    = 174,
	SHASX     = 175,
	SHSAX     = 176,
	SHSUB16   = 177,
	SHSUB8    = 178,
	SMC       = 179,
	SMLABB    = 180,
	SMLABT    = 181,
	SMLAD     = 182,
	SMLADX    = 183,
	SMLAL     = 184,
	SMLALBB   = 185,
	SMLALBT   = 186,
	SMLALD    = 187,
	SMLALDX   = 188,
	SMLALTB   = 189,
	SMLALTT   = 190,
	SMLATB    = 191,
	SMLATT    = 192,
	SMLAWB    = 193,
	SMLAWT    = 194,
	SMLSD     = 195,
	SMLSDX    = 196,
	SMLSLD    = 197,
	SMLSLDX   = 198,
	SMMLA     = 199,
	SMMLAR    = 200,
	SMMLS     = 201,
	SMMLSR    = 202,
	SMMUL     = 203,
	SMMULR    = 204,
	SMUAD     = 205,
	SMUADX    = 206,
	SMULBB    = 207,
	SMULBT    = 208,
	SMULL     = 209,
	SMULTB    = 210,
	SMULTT    = 211,
	SMULWB    = 212,
	SMULWT    = 213,
	SMUSD     = 214,
	SMUSDX    = 215,
	SRSDA     = 216,
	SRSDB     = 217,
	SRSIA     = 218,
	SRSIB     = 219,
	SSAT      = 220,
	SSAT16    = 221,
	SSAX      = 222,
	SSUB16    = 223,
	SSUB8     = 224,
	STC       = 225,
	STC2      = 226,
	STC2L     = 227,
	STCL      = 228,
	STL       = 229,
	STLB      = 230,
	STLEX     = 231,
	STLEXB    = 232,
	STLEXD    = 233,
	STLEXH    = 234,
	STLH      = 235,
	STM       = 236,
	STMDA     = 237,
	STMDB     = 238,
	STMIB     = 239,
	STR       = 240,
	STRB      = 241,
	STRBT     = 242,
	STRD      = 243,
	STREX     = 244,
	STREXB    = 245,
	STREXD    = 246,
	STREXH    = 247,
	STRH      = 248,
	STRHT     = 249,
	STRT      = 250,
	SUB       = 251,
	SUBS      = 252,
	SUBW      = 253,
	SVC       = 254,
	SWP       = 255,
	SWPB      = 256,
	SXTAB     = 257,
	SXTAB16   = 258,
	SXTAH     = 259,
	SXTB      = 260,
	SXTB16    = 261,
	SXTH      = 262,
	TBB       = 263,
	TBH       = 264,
	TEQ       = 265,
	TRAP      = 266,
	TSB       = 267,
	TST       = 268,
	TT        = 269,
	TTA       = 270,
	TTAT      = 271,
	TTT       = 272,
	UADD16    = 273,
	UADD8     = 274,
	UASX      = 275,
	UBFX      = 276,
	UDF       = 277,
	UDIV      = 278,
	UHADD16   = 279,
	UHADD8    = 280,
	UHASX     = 281,
	UHSAX     = 282,
	UHSUB16   = 283,
	UHSUB8    = 284,
	UMAAL     = 285,
	UMLAL     = 286,
	UMULL     = 287,
	UQADD16   = 288,
	UQADD8    = 289,
	UQASX     = 290,
	UQSAX     = 291,
	UQSUB16   = 292,
	UQSUB8    = 293,
	USAD8     = 294,
	USADA8    = 295,
	USAT      = 296,
	USAT16    = 297,
	USAX      = 298,
	USUB16    = 299,
	USUB8     = 300,
	UXTAB     = 301,
	UXTAB16   = 302,
	UXTAH     = 303,
	UXTB      = 304,
	UXTB16    = 305,
	UXTH      = 306,
	VABA      = 307,
	VABAL     = 308,
	VABD      = 309,
	VABDL     = 310,
	VABS      = 311,
	VACGE     = 312,
	VACGT     = 313,
	VACLE     = 314,
	VACLT     = 315,
	VADD      = 316,
	VADDHN    = 317,
	VADDL     = 318,
	VADDW     = 319,
	VAND      = 320,
	VBIC      = 321,
	VBIF      = 322,
	VBIT      = 323,
	VBSL      = 324,
	VCADD     = 325,
	VCEQ      = 326,
	VCGE      = 327,
	VCGT      = 328,
	VCLE      = 329,
	VCLS      = 330,
	VCLT      = 331,
	VCLZ      = 332,
	VCMLA     = 333,
	VCMP      = 334,
	VCMPE     = 335,
	VCNT      = 336,
	VCVT      = 337,
	VCVTA     = 338,
	VCVTB     = 339,
	VCVTM     = 340,
	VCVTN     = 341,
	VCVTP     = 342,
	VCVTR     = 343,
	VCVTT     = 344,
	VDIV      = 345,
	VDUP      = 346,
	VEOR      = 347,
	VEXT      = 348,
	VFMA      = 349,
	VFMS      = 350,
	VFNMA     = 351,
	VFNMS     = 352,
	VHADD     = 353,
	VHSUB     = 354,
	VINS      = 355,
	VJCVT     = 356,
	VLD1      = 357,
	VLD2      = 358,
	VLD3      = 359,
	VLD4      = 360,
	VLDMDB    = 361,
	VLDMIA    = 362,
	VLDR      = 363,
	VLLDM     = 364,
	VLSTM     = 365,
	VMAX      = 366,
	VMAXNM    = 367,
	VMIN      = 368,
	VMINNM    = 369,
	VMLA      = 370,
	VMLAL     = 371,
	VMLS      = 372,
	VMLSL     = 373,
	VMOV      = 374,
	VMOVL     = 375,
	VMOVN     = 376,
	VMOVX     = 377,
	VMRS      = 378,
	VMSR      = 379,
	VMUL      = 380,
	VMULL     = 381,
	VMVN      = 382,
	VNEG      = 383,
	VNMLA     = 384,
	VNMLS     = 385,
	VNMUL     = 386,
	VORN      = 387,
	VORR      = 388,
	VPADAL    = 389,
	VPADD     = 390,
	VPADDL    = 391,
	VPMAX     = 392,
	VPMIN     = 393,
	VPOP      = 394,
	VPUSH     = 395,
	VQABS     = 396,
	VQADD     = 397,
	VQDMLAL   = 398,
	VQDMLSL   = 399,
	VQDMULH   = 400,
	VQDMULL   = 401,
	VQMOVN    = 402,
	VQMOVUN   = 403,
	VQNEG     = 404,
	VQRDMLAH  = 405,
	VQRDMLSH  = 406,
	VQRDMULH  = 407,
	VQRSHL    = 408,
	VQRSHRN   = 409,
	VQRSHRUN  = 410,
	VQSHL     = 411,
	VQSHLU    = 412,
	VQSHRN    = 413,
	VQSHRUN   = 414,
	VQSUB     = 415,
	VRADDHN   = 416,
	VRECPE    = 417,
	VRECPS    = 418,
	VREV16    = 419,
	VREV32    = 420,
	VREV64    = 421,
	VRHADD    = 422,
	VRINTA    = 423,
	VRINTM    = 424,
	VRINTN    = 425,
	VRINTP    = 426,
	VRINTR    = 427,
	VRINTX    = 428,
	VRINTZ    = 429,
	VRSHL     = 430,
	VRSHR     = 431,
	VRSHRN    = 432,
	VRSQRTE   = 433,
	VRSQRTS   = 434,
	VRSRA     = 435,
	VRSUBHN   = 436,
	VSDOT     = 437,
	VSELEQ    = 438,
	VSELGE    = 439,
	VSELGT    = 440,
	VSELVS    = 441,
	VSHL      = 442,
	VSHLL     = 443,
	VSHR      = 444,
	VSHRN     = 445,
	VSLI      = 446,
	VSQRT     = 447,
	VSRA      = 448,
	VSRI      = 449,
	VST1      = 450,
	VST2      = 451,
	VST3      = 452,
	VST4      = 453,
	VSTMDB    = 454,
	VSTMIA    = 455,
	VSTR      = 456,
	VSUB      = 457,
	VSUBHN    = 458,
	VSUBL     = 459,
	VSUBW     = 460,
	VSWP      = 461,
	VTBL      = 462,
	VTBX      = 463,
	VTRN      = 464,
	VTST      = 465,
	VUDOT     = 466,
	VUZP      = 467,
	VZIP      = 468,
	WFE       = 469,
	WFI       = 470,
	YIELD     = 471,
	ENDING    = 472, // <-- mark the end of the list of instructions
}

/// Group of ARM instructions
arm_insn_group :: enum i32 {
	INVALID         = 0, ///< = CS_GRP_INVALID

	// Generic groups
	// all jump instructions (conditional+direct+indirect jumps)
	JUMP            = 1, ///< = CS_GRP_JUMP
	CALL            = 2, ///< = CS_GRP_CALL
	INT             = 4, ///< = CS_GRP_INT
	PRIVILEGE       = 6, ///< = CS_GRP_PRIVILEGE
	BRANCH_RELATIVE = 7, ///< = CS_GRP_BRANCH_RELATIVE

	// Architecture-specific groups
	CRYPTO          = 128,
	DATABARRIER     = 129,
	DIVIDE          = 130,
	FPARMV8         = 131,
	MULTPRO         = 132,
	NEON            = 133,
	T2EXTRACTPACK   = 134,
	THUMB2DSP       = 135,
	TRUSTZONE       = 136,
	V4T             = 137,
	V5T             = 138,
	V5TE            = 139,
	V6              = 140,
	V6T2            = 141,
	V7              = 142,
	V8              = 143,
	VFP2            = 144,
	VFP3            = 145,
	VFP4            = 146,
	ARM             = 147,
	MCLASS          = 148,
	NOTMCLASS       = 149,
	THUMB           = 150,
	THUMB1ONLY      = 151,
	THUMB2          = 152,
	PREV8           = 153,
	FPVMLX          = 154,
	MULOPS          = 155,
	CRC             = 156,
	DPVFP           = 157,
	V6M             = 158,
	VIRTUALIZATION  = 159,
	ENDING          = 160,
}

