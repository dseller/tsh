#include <ctype.h>
#include <assert.h>
#include <stdint.h>

#define ischar(c)   (isupper(c) || islower(c))

int64_t hatoi(char *str)
{
	// 70 - 48 = 22
	int64_t res = 0;
	for (int i = 0; str[i] != '\0'; ++i)
	{
		uint8_t ch = ischar(str[i]) ? toupper(str[i]) : str[i];
		res = res * 16 + (isdigit(ch) ? (ch - '0') : (ch - '7'));
	}

	return res;
}

int64_t batoi(char *str)
{
	int64_t res = 0;
	for (int i = 0; str[i] != '\0'; ++i)
	{
		uint8_t ch = str[i];
		assert(ch == '1' || ch == '0');

		res = res * 2 + (ch - '0');
	}
	return res;
}
