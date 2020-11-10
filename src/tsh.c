#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <assert.h>

#include "ast.h"
#include "lex.yy.h"
#include "tsh.tab.h"
#include "vm.h"

void define_function(const char *name, enum type_t return_type, node_t *ast) {
    printf("Defining function '%s', return type %i\n", name, return_type);
    ast_dump(ast, 0);
}

void panic(const char *reason) {
    printf("%s\n", reason);
    exit(-1);
}

void load(const char *file) {
    yyin = fopen(file, "r");
    assert(yyin != NULL);

    do {
        yyparse();
    } while (!feof(yyin));

    fclose(yyin);
}


// 80x60
int main(int argc, char *argv[]) {
    load("main.hc");

    vm_state* vm = vm_get();
}
