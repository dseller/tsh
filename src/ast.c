#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

#include "ast.h"

#define AST_DUMP_INDENT		3

const char *node_type_to_str(node_type_t type) {
	switch (type) {
	case V_STRING: return "V_STRING";

	case PRINT: return "PRINT";
	case INVALID: return "!! INVALID NODE !!";
	case LIST: return "LIST";
	default: return "<UNKNOWN>";
	}
}

void printfi(const char *fmt, int indent, ...) {
	va_list ap;
	va_start(ap, indent);

	for (int i = 0; i < indent; i++)
		putch(' ');

	vprintf(fmt, ap);

	va_end(ap);
}

void ast_dump(node_t *node, int indentation) {
	if (node == NULL)
		return;

	if (node->type != LIST) {
		printfi("%s", indentation, node_type_to_str(node->type));

		switch (node->type) {
			case V_STRING: printf(" => %s", node->value.string);
		}

		printf("\n");

		indentation += AST_DUMP_INDENT;
	}


	if (node->left != NULL) {
		ast_dump(node->left, indentation);
	}

	if (node->right != NULL) {
		ast_dump(node->right, indentation);
	}
}

node_t* node2(node_type_t type, node_t* left, node_t* right) {
	return node3(type, left, right, NULL);
}

node_t* node3(node_type_t type, node_t* left, node_t* right, node_t* middle) {
	node_t* node = (node_t*)malloc(sizeof(node_t));
	node->type = type;
	node->value.string = NULL;
	node->left = left;
	node->middle = middle;
	node->right = right;

	return node;
}

node_t* value_node(node_type_t type, void* value) {
	node_t* node = (node_t*)malloc(sizeof(node_t));
	node->type = type;
	node->value.string = value;
	node->left = node->middle = node->right = NULL;

	return node;
}