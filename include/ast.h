#pragma once

typedef enum node_type_t {
	INVALID = 0,

	V_STRING,



	LIST,
	PRINT,
} node_type_t;

union node_value_t {
	const char* string;
	long long integer;
};

typedef struct node_t {
	node_type_t type;
	union node_value_t value;
	struct node_t* left, * middle, * right;
} node_t;

void ast_dump(node_t*, int indentation);
node_t* value_node(node_type_t type, void *value);
node_t* node2(node_type_t type, node_t* left, node_t* right);
node_t* node3(node_type_t type, node_t* left, node_t* right, node_t* middle);
