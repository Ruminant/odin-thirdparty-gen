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


/// Instruction structure
evm :: struct {
	pop:  u8,  ///< number of items popped from the stack
	push: u8,  ///< number of items pushed into the stack
	fee:  u32, ///< gas fee for the instruction
}

/// EVM instruction
evm_insn :: enum i32 {
	STOP           = 0,
	ADD            = 1,
	MUL            = 2,
	SUB            = 3,
	DIV            = 4,
	SDIV           = 5,
	MOD            = 6,
	SMOD           = 7,
	ADDMOD         = 8,
	MULMOD         = 9,
	EXP            = 10,
	SIGNEXTEND     = 11,
	LT             = 16,
	GT             = 17,
	SLT            = 18,
	SGT            = 19,
	EQ             = 20,
	ISZERO         = 21,
	AND            = 22,
	OR             = 23,
	XOR            = 24,
	NOT            = 25,
	BYTE           = 26,
	SHA3           = 32,
	ADDRESS        = 48,
	BALANCE        = 49,
	ORIGIN         = 50,
	CALLER         = 51,
	CALLVALUE      = 52,
	CALLDATALOAD   = 53,
	CALLDATASIZE   = 54,
	CALLDATACOPY   = 55,
	CODESIZE       = 56,
	CODECOPY       = 57,
	GASPRICE       = 58,
	EXTCODESIZE    = 59,
	EXTCODECOPY    = 60,
	RETURNDATASIZE = 61,
	RETURNDATACOPY = 62,
	BLOCKHASH      = 64,
	COINBASE       = 65,
	TIMESTAMP      = 66,
	NUMBER         = 67,
	DIFFICULTY     = 68,
	GASLIMIT       = 69,
	POP            = 80,
	MLOAD          = 81,
	MSTORE         = 82,
	MSTORE8        = 83,
	SLOAD          = 84,
	SSTORE         = 85,
	JUMP           = 86,
	JUMPI          = 87,
	PC             = 88,
	MSIZE          = 89,
	GAS            = 90,
	JUMPDEST       = 91,
	PUSH1          = 96,
	PUSH2          = 97,
	PUSH3          = 98,
	PUSH4          = 99,
	PUSH5          = 100,
	PUSH6          = 101,
	PUSH7          = 102,
	PUSH8          = 103,
	PUSH9          = 104,
	PUSH10         = 105,
	PUSH11         = 106,
	PUSH12         = 107,
	PUSH13         = 108,
	PUSH14         = 109,
	PUSH15         = 110,
	PUSH16         = 111,
	PUSH17         = 112,
	PUSH18         = 113,
	PUSH19         = 114,
	PUSH20         = 115,
	PUSH21         = 116,
	PUSH22         = 117,
	PUSH23         = 118,
	PUSH24         = 119,
	PUSH25         = 120,
	PUSH26         = 121,
	PUSH27         = 122,
	PUSH28         = 123,
	PUSH29         = 124,
	PUSH30         = 125,
	PUSH31         = 126,
	PUSH32         = 127,
	DUP1           = 128,
	DUP2           = 129,
	DUP3           = 130,
	DUP4           = 131,
	DUP5           = 132,
	DUP6           = 133,
	DUP7           = 134,
	DUP8           = 135,
	DUP9           = 136,
	DUP10          = 137,
	DUP11          = 138,
	DUP12          = 139,
	DUP13          = 140,
	DUP14          = 141,
	DUP15          = 142,
	DUP16          = 143,
	SWAP1          = 144,
	SWAP2          = 145,
	SWAP3          = 146,
	SWAP4          = 147,
	SWAP5          = 148,
	SWAP6          = 149,
	SWAP7          = 150,
	SWAP8          = 151,
	SWAP9          = 152,
	SWAP10         = 153,
	SWAP11         = 154,
	SWAP12         = 155,
	SWAP13         = 156,
	SWAP14         = 157,
	SWAP15         = 158,
	SWAP16         = 159,
	LOG0           = 160,
	LOG1           = 161,
	LOG2           = 162,
	LOG3           = 163,
	LOG4           = 164,
	CREATE         = 240,
	CALL           = 241,
	CALLCODE       = 242,
	RETURN         = 243,
	DELEGATECALL   = 244,
	CALLBLACKBOX   = 245,
	STATICCALL     = 250,
	REVERT         = 253,
	SUICIDE        = 255,
	INVALID        = 512,
	ENDING         = 513, // <-- mark the end of the list of instructions
}

/// Group of EVM instructions
evm_insn_group :: enum i32 {
	INVALID     = 0,  ///< = CS_GRP_INVALID
	JUMP        = 1,  ///< all jump instructions
	MATH        = 8,  ///< math instructions
	STACK_WRITE = 9,  ///< instructions write to stack
	STACK_READ  = 10, ///< instructions read from stack
	MEM_WRITE   = 11, ///< instructions write to memory
	MEM_READ    = 12, ///< instructions read from memory
	STORE_WRITE = 13, ///< instructions write to storage
	STORE_READ  = 14, ///< instructions read from storage
	HALT        = 15, ///< instructions halt execution
	ENDING      = 16, ///< <-- mark the end of the list of groups
}

