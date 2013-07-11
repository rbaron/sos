/*

  Define here functions to be called from assembly.

*/

#if !defined(__cplusplus)
#include <stdbool.h> /* C doesn't have booleans by default. */
#endif
#include <stddef.h>
#include <stdint.h>

const char *my_string = "test string";

const char* test() {
  int a = 5;
  return my_string;
}
