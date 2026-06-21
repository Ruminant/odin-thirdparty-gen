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


M680X_OPERAND_COUNT :: 9

/// M680X registers and special registers
m680x_reg :: enum i32 {
	INVALID = 0,
	A       = 1,  ///< M6800/1/2/3/9, HD6301/9
	B       = 2,  ///< M6800/1/2/3/9, HD6301/9
	E       = 3,  ///< HD6309
	F       = 4,  ///< HD6309
	_0      = 5,  ///< HD6309
	D       = 6,  ///< M6801/3/9, HD6301/9
	W       = 7,  ///< HD6309
	CC      = 8,  ///< M6800/1/2/3/9, M6301/9
	DP      = 9,  ///< M6809/M6309
	MD      = 10, ///< M6309
	HX      = 11, ///< M6808
	H       = 12, ///< M6808
	X       = 13, ///< M6800/1/2/3/9, M6301/9
	Y       = 14, ///< M6809/M6309
	S       = 15, ///< M6809/M6309
	U       = 16, ///< M6809/M6309
	V       = 17, ///< M6309
	Q       = 18, ///< M6309
	PC      = 19, ///< M6800/1/2/3/9, M6301/9
	TMP2    = 20, ///< CPU12
	TMP3    = 21, ///< CPU12
	ENDING  = 22, ///< <-- mark the end of the list of registers
}

/// Operand type for instruction's operands
m680x_op_type :: enum i32 {
	INVALID   = 0, ///< = CS_OP_INVALID (Uninitialized).
	REGISTER  = 1, ///< = Register operand.
	IMMEDIATE = 2, ///< = Immediate operand.
	INDEXED   = 3, ///< = Indexed addressing operand.
	EXTENDED  = 4, ///< = Extended addressing operand.
	DIRECT    = 5, ///< = Direct addressing operand.
	RELATIVE  = 6, ///< = Relative addressing operand.
	CONSTANT  = 7, ///< = constant operand (Displayed as number only).
}

// Supported bit values for mem.idx.offset_bits
M680X_OFFSET_NONE      :: 0
M680X_OFFSET_BITS_5    :: 5
M680X_OFFSET_BITS_8    :: 8
M680X_OFFSET_BITS_9    :: 9
M680X_OFFSET_BITS_16  :: 16

// Supported bit flags for mem.idx.flags
// These flags can be combined
M680X_IDX_INDIRECT     :: 1
M680X_IDX_NO_COMMA     :: 2
M680X_IDX_POST_INC_DEC :: 4

/// Instruction's operand referring to indexed addressing
m680x_op_idx :: struct {
	base_reg: m680x_reg, ///< base register (or M680X_REG_INVALID if

	///< irrelevant)
	offset_reg: m680x_reg, ///< offset register (or M680X_REG_INVALID if

	///< irrelevant)
	offset:      i16, ///< 5-,8- or 16-bit offset. See also offset_bits.
	offset_addr: u16, ///< = offset addr. if base_reg == M680X_REG_PC.

	///< calculated as offset + PC
	offset_bits: u8, ///< offset width in bits for indexed addressing
	inc_dec:     i8, ///< inc. or dec. value:

	///<    0: no inc-/decrement
	///<    1 .. 8: increment by 1 .. 8
	///<    -1 .. -8: decrement by 1 .. 8
	///< if flag M680X_IDX_POST_INC_DEC set it is post
	///< inc-/decrement otherwise pre inc-/decrement
	flags: u8, ///< 8-bit flags (see above)
}

/// Instruction's memory operand referring to relative addressing (Bcc/LBcc)
m680x_op_rel :: struct {
	address: u16, ///< The absolute address.

	///< calculated as PC + offset. PC is the first
	///< address after the instruction.
	offset: i16, ///< the offset/displacement value
}

/// Instruction's operand referring to extended addressing
m680x_op_ext :: struct {
	address:  u16,  ///< The absolute address
	indirect: bool, ///< true if extended indirect addressing
}

/// Instruction operand
m680x_op :: struct {
	type: m680x_op_type,

	using _: struct #raw_union {
		imm:         i32,          ///< immediate value for IMM operand
		reg:         m680x_reg,    ///< register value for REG operand
		idx:         m680x_op_idx, ///< Indexed addressing operand
		rel:         m680x_op_rel, ///< Relative address. operand (Bcc/LBcc)
		ext:         m680x_op_ext, ///< Extended address
		direct_addr: u8,           ///<</ Direct address (lower 8-bit)
		const_val:   u8,           ///< constant value (bit index, page nr.)
	},

	size: u8, ///< size of this operand (in bytes)

	/// How is this operand accessed? (READ, WRITE or READ|WRITE)
	/// This field is combined of cs_ac_type.
	/// NOTE: this field is irrelevant if engine is compiled in DIET
	access: u8,
}

/// Group of M680X instructions
m680x_group_type :: enum i32 {
	INVALID = 0, /// = CS_GRP_INVALID

	// Generic groups
	// all jump instructions (conditional+direct+indirect jumps)
	JUMP    = 1, ///< = CS_GRP_JUMP

	// all call instructions
	CALL    = 2, ///< = CS_GRP_CALL

	// all return instructions
	RET     = 3, ///< = CS_GRP_RET

	// all interrupt instructions (int+syscall)
	INT     = 4, ///< = CS_GRP_INT

	// all interrupt return instructions
	IRET    = 5, ///< = CS_GRP_IRET

	// all privileged instructions
	PRIV    = 6, ///< = CS_GRP_PRIVILEDGE; not used

	// all relative branching instructions
	BRAREL  = 7, ///< = CS_GRP_BRANCH_RELATIVE

	// Architecture-specific groups
	ENDING  = 8, // <-- mark the end of the list of groups
}

// M680X instruction flags:

/// The first (register) operand is part of the
/// instruction mnemonic
M680X_FIRST_OP_IN_MNEM    :: 1

/// The second (register) operand is part of the
/// instruction mnemonic
M680X_SECOND_OP_IN_MNEM   :: 2

/// The M680X instruction and it's operands
m680x :: struct {
	flags:    u8,          ///< See: M680X instruction flags
	op_count: u8,          ///< number of operands for the instruction or 0
	operands: [9]m680x_op, ///< operands for this insn.
}

/// M680X instruction IDs
m680x_insn :: enum i32 {
	INVLD  = 0,
	ABA    = 1,   ///< M6800/1/2/3
	ABX    = 2,
	ABY    = 3,
	ADC    = 4,
	ADCA   = 5,
	ADCB   = 6,
	ADCD   = 7,
	ADCR   = 8,
	ADD    = 9,
	ADDA   = 10,
	ADDB   = 11,
	ADDD   = 12,
	ADDE   = 13,
	ADDF   = 14,
	ADDR   = 15,
	ADDW   = 16,
	AIM    = 17,
	AIS    = 18,
	AIX    = 19,
	AND    = 20,
	ANDA   = 21,
	ANDB   = 22,
	ANDCC  = 23,
	ANDD   = 24,
	ANDR   = 25,
	ASL    = 26,
	ASLA   = 27,
	ASLB   = 28,
	ASLD   = 29,  ///< or LSLD
	ASR    = 30,
	ASRA   = 31,
	ASRB   = 32,
	ASRD   = 33,
	ASRX   = 34,
	BAND   = 35,
	BCC    = 36,  ///< or BHS
	BCLR   = 37,
	BCS    = 38,  ///< or BLO
	BEOR   = 39,
	BEQ    = 40,
	BGE    = 41,
	BGND   = 42,
	BGT    = 43,
	BHCC   = 44,
	BHCS   = 45,
	BHI    = 46,
	BIAND  = 47,
	BIEOR  = 48,
	BIH    = 49,
	BIL    = 50,
	BIOR   = 51,
	BIT    = 52,
	BITA   = 53,
	BITB   = 54,
	BITD   = 55,
	BITMD  = 56,
	BLE    = 57,
	BLS    = 58,
	BLT    = 59,
	BMC    = 60,
	BMI    = 61,
	BMS    = 62,
	BNE    = 63,
	BOR    = 64,
	BPL    = 65,
	BRCLR  = 66,
	BRSET  = 67,
	BRA    = 68,
	BRN    = 69,
	BSET   = 70,
	BSR    = 71,
	BVC    = 72,
	BVS    = 73,
	CALL   = 74,
	CBA    = 75,  ///< M6800/1/2/3
	CBEQ   = 76,
	CBEQA  = 77,
	CBEQX  = 78,
	CLC    = 79,  ///< M6800/1/2/3
	CLI    = 80,  ///< M6800/1/2/3
	CLR    = 81,
	CLRA   = 82,
	CLRB   = 83,
	CLRD   = 84,
	CLRE   = 85,
	CLRF   = 86,
	CLRH   = 87,
	CLRW   = 88,
	CLRX   = 89,
	CLV    = 90,  ///< M6800/1/2/3
	CMP    = 91,
	CMPA   = 92,
	CMPB   = 93,
	CMPD   = 94,
	CMPE   = 95,
	CMPF   = 96,
	CMPR   = 97,
	CMPS   = 98,
	CMPU   = 99,
	CMPW   = 100,
	CMPX   = 101,
	CMPY   = 102,
	COM    = 103,
	COMA   = 104,
	COMB   = 105,
	COMD   = 106,
	COME   = 107,
	COMF   = 108,
	COMW   = 109,
	COMX   = 110,
	CPD    = 111,
	CPHX   = 112,
	CPS    = 113,
	CPX    = 114, ///< M6800/1/2/3
	CPY    = 115,
	CWAI   = 116,
	DAA    = 117,
	DBEQ   = 118,
	DBNE   = 119,
	DBNZ   = 120,
	DBNZA  = 121,
	DBNZX  = 122,
	DEC    = 123,
	DECA   = 124,
	DECB   = 125,
	DECD   = 126,
	DECE   = 127,
	DECF   = 128,
	DECW   = 129,
	DECX   = 130,
	DES    = 131, ///< M6800/1/2/3
	DEX    = 132, ///< M6800/1/2/3
	DEY    = 133,
	DIV    = 134,
	DIVD   = 135,
	DIVQ   = 136,
	EDIV   = 137,
	EDIVS  = 138,
	EIM    = 139,
	EMACS  = 140,
	EMAXD  = 141,
	EMAXM  = 142,
	EMIND  = 143,
	EMINM  = 144,
	EMUL   = 145,
	EMULS  = 146,
	EOR    = 147,
	EORA   = 148,
	EORB   = 149,
	EORD   = 150,
	EORR   = 151,
	ETBL   = 152,
	EXG    = 153,
	FDIV   = 154,
	IBEQ   = 155,
	IBNE   = 156,
	IDIV   = 157,
	IDIVS  = 158,
	ILLGL  = 159,
	INC    = 160,
	INCA   = 161,
	INCB   = 162,
	INCD   = 163,
	INCE   = 164,
	INCF   = 165,
	INCW   = 166,
	INCX   = 167,
	INS    = 168, ///< M6800/1/2/3
	INX    = 169, ///< M6800/1/2/3
	INY    = 170,
	JMP    = 171,
	JSR    = 172,
	LBCC   = 173, ///< or LBHS
	LBCS   = 174, ///< or LBLO
	LBEQ   = 175,
	LBGE   = 176,
	LBGT   = 177,
	LBHI   = 178,
	LBLE   = 179,
	LBLS   = 180,
	LBLT   = 181,
	LBMI   = 182,
	LBNE   = 183,
	LBPL   = 184,
	LBRA   = 185,
	LBRN   = 186,
	LBSR   = 187,
	LBVC   = 188,
	LBVS   = 189,
	LDA    = 190,
	LDAA   = 191, ///< M6800/1/2/3
	LDAB   = 192, ///< M6800/1/2/3
	LDB    = 193,
	LDBT   = 194,
	LDD    = 195,
	LDE    = 196,
	LDF    = 197,
	LDHX   = 198,
	LDMD   = 199,
	LDQ    = 200,
	LDS    = 201,
	LDU    = 202,
	LDW    = 203,
	LDX    = 204,
	LDY    = 205,
	LEAS   = 206,
	LEAU   = 207,
	LEAX   = 208,
	LEAY   = 209,
	LSL    = 210,
	LSLA   = 211,
	LSLB   = 212,
	LSLD   = 213,
	LSLX   = 214,
	LSR    = 215,
	LSRA   = 216,
	LSRB   = 217,
	LSRD   = 218, ///< or ASRD
	LSRW   = 219,
	LSRX   = 220,
	MAXA   = 221,
	MAXM   = 222,
	MEM    = 223,
	MINA   = 224,
	MINM   = 225,
	MOV    = 226,
	MOVB   = 227,
	MOVW   = 228,
	MUL    = 229,
	MULD   = 230,
	NEG    = 231,
	NEGA   = 232,
	NEGB   = 233,
	NEGD   = 234,
	NEGX   = 235,
	NOP    = 236,
	NSA    = 237,
	OIM    = 238,
	ORA    = 239,
	ORAA   = 240, ///< M6800/1/2/3
	ORAB   = 241, ///< M6800/1/2/3
	ORB    = 242,
	ORCC   = 243,
	ORD    = 244,
	ORR    = 245,
	PSHA   = 246, ///< M6800/1/2/3
	PSHB   = 247, ///< M6800/1/2/3
	PSHC   = 248,
	PSHD   = 249,
	PSHH   = 250,
	PSHS   = 251,
	PSHSW  = 252,
	PSHU   = 253,
	PSHUW  = 254,
	PSHX   = 255, ///< M6800/1/2/3
	PSHY   = 256,
	PULA   = 257, ///< M6800/1/2/3
	PULB   = 258, ///< M6800/1/2/3
	PULC   = 259,
	PULD   = 260,
	PULH   = 261,
	PULS   = 262,
	PULSW  = 263,
	PULU   = 264,
	PULUW  = 265,
	PULX   = 266, ///< M6800/1/2/3
	PULY   = 267,
	REV    = 268,
	REVW   = 269,
	ROL    = 270,
	ROLA   = 271,
	ROLB   = 272,
	ROLD   = 273,
	ROLW   = 274,
	ROLX   = 275,
	ROR    = 276,
	RORA   = 277,
	RORB   = 278,
	RORD   = 279,
	RORW   = 280,
	RORX   = 281,
	RSP    = 282,
	RTC    = 283,
	RTI    = 284,
	RTS    = 285,
	SBA    = 286, ///< M6800/1/2/3
	SBC    = 287,
	SBCA   = 288,
	SBCB   = 289,
	SBCD   = 290,
	SBCR   = 291,
	SEC    = 292,
	SEI    = 293,
	SEV    = 294,
	SEX    = 295,
	SEXW   = 296,
	SLP    = 297,
	STA    = 298,
	STAA   = 299, ///< M6800/1/2/3
	STAB   = 300, ///< M6800/1/2/3
	STB    = 301,
	STBT   = 302,
	STD    = 303,
	STE    = 304,
	STF    = 305,
	STOP   = 306,
	STHX   = 307,
	STQ    = 308,
	STS    = 309,
	STU    = 310,
	STW    = 311,
	STX    = 312,
	STY    = 313,
	SUB    = 314,
	SUBA   = 315,
	SUBB   = 316,
	SUBD   = 317,
	SUBE   = 318,
	SUBF   = 319,
	SUBR   = 320,
	SUBW   = 321,
	SWI    = 322,
	SWI2   = 323,
	SWI3   = 324,
	SYNC   = 325,
	TAB    = 326, ///< M6800/1/2/3
	TAP    = 327, ///< M6800/1/2/3
	TAX    = 328,
	TBA    = 329, ///< M6800/1/2/3
	TBEQ   = 330,
	TBL    = 331,
	TBNE   = 332,
	TEST   = 333,
	TFM    = 334,
	TFR    = 335,
	TIM    = 336,
	TPA    = 337, ///< M6800/1/2/3
	TST    = 338,
	TSTA   = 339,
	TSTB   = 340,
	TSTD   = 341,
	TSTE   = 342,
	TSTF   = 343,
	TSTW   = 344,
	TSTX   = 345,
	TSX    = 346, ///< M6800/1/2/3
	TSY    = 347,
	TXA    = 348,
	TXS    = 349, ///< M6800/1/2/3
	TYS    = 350,
	WAI    = 351, ///< M6800/1/2/3
	WAIT   = 352,
	WAV    = 353,
	WAVR   = 354,
	XGDX   = 355, ///< HD6301
	XGDY   = 356,
	ENDING = 357, // <-- mark the end of the list of instructions
}

