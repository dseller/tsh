#pragma once

#include <stdint.h>

// Really simple stack-based VM that executes the bytecode.

typedef union {
	const char* str;
	uint64_t u64;
	int64_t i64;
	uint32_t u32;
} vm_value_t;

typedef struct {
	/// <summary>
	/// Points to the beginning of the stack.
	/// </summary>
	uint64_t* stack;

	/// <summary>
	/// Pointer to TOS.
	/// </summary>
	uint64_t* stackPointer;
} vm_state;

vm_state* vm_get();