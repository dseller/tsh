#include "vm.h"

#include <stdlib.h>

static vm_state* vm = NULL;

vm_state *vm_get() {
	if (vm != NULL)
		return vm;

	vm = (vm_state*)malloc(sizeof(vm_state));
	
	return vm;
}
