#pragma once

typedef enum opcode_t {
	O_BRK = 0x00,
	O_LC,
	O_ADD,
	O_SUB,
	O_MUL,
	O_DIV,
	O_PRINT
} opcode_t;

typedef struct operation_t {
	opcode_t opcode;
} operation_t;

operation_t* op_new(opcode_t opcode);
