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


/// MOS65XX registers and special registers
mos65xx_reg :: enum i32 {
	INVALID = 0,
	ACC     = 1, ///< accumulator
	X       = 2, ///< X index register
	Y       = 3, ///< Y index register
	P       = 4, ///< status register
	SP      = 5, ///< stack pointer register
	DP      = 6, ///< direct page register
	B       = 7, ///< data bank register
	K       = 8, ///< program bank register
	ENDING  = 9, // <-- mark the end of the list of registers
}

/// MOS65XX Addressing Modes
mos65xx_address_mode :: enum i32 {
	NONE          = 0,  ///< No address mode.
	IMP           = 1,  ///< implied addressing (no addressing mode)
	ACC           = 2,  ///< accumulator addressing
	IMM           = 3,  ///< 8/16 Bit immediate value
	REL           = 4,  ///< relative addressing used by branches
	INT           = 5,  ///< interrupt addressing
	BLOCK         = 6,  ///< memory block addressing
	ZP            = 7,  ///< zeropage addressing
	ZP_X          = 8,  ///< indexed zeropage addressing by the X index register
	ZP_Y          = 9,  ///< indexed zeropage addressing by the Y index register
	ZP_REL        = 10, ///< zero page address, branch relative address
	ZP_IND        = 11, ///< indirect zeropage addressing
	ZP_X_IND      = 12, ///< indexed zeropage indirect addressing by the X index register
	ZP_IND_Y      = 13, ///< indirect zeropage indexed addressing by the Y index register
	ZP_IND_LONG   = 14, ///< zeropage indirect long addressing
	ZP_IND_LONG_Y = 15, ///< zeropage indirect long addressing indexed by Y register
	ABS           = 16, ///< absolute addressing
	ABS_X         = 17, ///< indexed absolute addressing by the X index register
	ABS_Y         = 18, ///< indexed absolute addressing by the Y index register
	ABS_IND       = 19, ///< absolute indirect addressing
	ABS_X_IND     = 20, ///< indexed absolute indirect addressing by the X index register
	ABS_IND_LONG  = 21, ///< absolute indirect long addressing
	ABS_LONG      = 22, ///< absolute long address mode
	ABS_LONG_X    = 23, ///< absolute long address mode, indexed by X register
	SR            = 24, ///< stack relative addressing
	SR_IND_Y      = 25, ///< indirect stack relative addressing indexed by the Y index register
}

/// MOS65XX instruction
mos65xx_insn :: enum i32 {
	INVALID = 0,
	ADC     = 1,
	AND     = 2,
	ASL     = 3,
	BBR     = 4,
	BBS     = 5,
	BCC     = 6,
	BCS     = 7,
	BEQ     = 8,
	BIT     = 9,
	BMI     = 10,
	BNE     = 11,
	BPL     = 12,
	BRA     = 13,
	BRK     = 14,
	BRL     = 15,
	BVC     = 16,
	BVS     = 17,
	CLC     = 18,
	CLD     = 19,
	CLI     = 20,
	CLV     = 21,
	CMP     = 22,
	COP     = 23,
	CPX     = 24,
	CPY     = 25,
	DEC     = 26,
	DEX     = 27,
	DEY     = 28,
	EOR     = 29,
	INC     = 30,
	INX     = 31,
	INY     = 32,
	JML     = 33,
	JMP     = 34,
	JSL     = 35,
	JSR     = 36,
	LDA     = 37,
	LDX     = 38,
	LDY     = 39,
	LSR     = 40,
	MVN     = 41,
	MVP     = 42,
	NOP     = 43,
	ORA     = 44,
	PEA     = 45,
	PEI     = 46,
	PER     = 47,
	PHA     = 48,
	PHB     = 49,
	PHD     = 50,
	PHK     = 51,
	PHP     = 52,
	PHX     = 53,
	PHY     = 54,
	PLA     = 55,
	PLB     = 56,
	PLD     = 57,
	PLP     = 58,
	PLX     = 59,
	PLY     = 60,
	REP     = 61,
	RMB     = 62,
	ROL     = 63,
	ROR     = 64,
	RTI     = 65,
	RTL     = 66,
	RTS     = 67,
	SBC     = 68,
	SEC     = 69,
	SED     = 70,
	SEI     = 71,
	SEP     = 72,
	SMB     = 73,
	STA     = 74,
	STP     = 75,
	STX     = 76,
	STY     = 77,
	STZ     = 78,
	TAX     = 79,
	TAY     = 80,
	TCD     = 81,
	TCS     = 82,
	TDC     = 83,
	TRB     = 84,
	TSB     = 85,
	TSC     = 86,
	TSX     = 87,
	TXA     = 88,
	TXS     = 89,
	TXY     = 90,
	TYA     = 91,
	TYX     = 92,
	WAI     = 93,
	WDM     = 94,
	XBA     = 95,
	XCE     = 96,
	ENDING  = 97, // <-- mark the end of the list of instructions
}

/// Group of MOS65XX instructions
mos65xx_group_type :: enum i32 {
	INVALID         = 0, ///< CS_GRP_INVALID
	JUMP            = 1, ///< = CS_GRP_JUMP
	CALL            = 2, ///< = CS_GRP_RET
	RET             = 3, ///< = CS_GRP_RET
	INT             = 4, ///< = CS_GRP_INT
	IRET            = 5, ///< = CS_GRP_IRET
	BRANCH_RELATIVE = 6, ///< = CS_GRP_BRANCH_RELATIVE
	ENDING          = 7, // <-- mark the end of the list of groups
}

/// Operand type for instruction's operands
mos65xx_op_type :: enum i32 {
	INVALID = 0, ///< = CS_OP_INVALID (Uninitialized).
	REG     = 1, ///< = CS_OP_REG (Register operand).
	IMM     = 2, ///< = CS_OP_IMM (Immediate operand).
	MEM     = 3, ///< = CS_OP_MEM (Memory operand).
}

/// Instruction operand
mos65xx_op :: struct {
	type: mos65xx_op_type, ///< operand type

	using _: struct #raw_union {
		reg: mos65xx_reg, ///< register value for REG operand
		imm: u16,         ///< immediate value for IMM operand
		mem: u32,         ///< address for MEM operand
	},
}

/// The MOS65XX address mode and it's operands
mos65xx :: struct {
	am:             mos65xx_address_mode,
	modifies_flags: bool,

	/// Number of operands of this instruction,
	/// or 0 when instruction has no operand.
	op_count: u8,
	operands: [3]mos65xx_op, ///< operands for this instruction.
}

