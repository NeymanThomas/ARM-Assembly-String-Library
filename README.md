# ARM-Assembly-String-Library
An implementation of some of the functions in the &lt;string.h> C standard Library written in ARM Assembly.
==========================================================================================================

This code was made purely for learning experiences and I do not recommend using the ARM library to implement 
string functions in C when the library to do so already exists.
Included Library Functions:

strcat()
--The strcat() function appends the src string to the dest string, overwriting the terminating null byte
at the end of dest, and then adds a terminating null byte. If dest is not large enough, program behavior
is unpredictable. Returns a pointer to the resulting string dest.
strncat()
--Same as strcat() except that it will use at most n bytes from src; and src does not need to be nullterminated if it contains n or more bytes. If src contains n or more bytes, strncat() writes n+1 bytes
to dest (n from src plus the terminating null byte). Returns a pointer to the resulting string dest.
strchr()
--The strchr() function returns a pointer to the first occurrence of the character c in the string s.
Returns a pointer to the matched character or NULL if the character is not found. The terminating
null byte is considered part of the string, so that if c is specified as ‘\0’, this function returns a pointer
to the terminator.
strrchr()
--The strrchar() function returns a pointer to the last occurrence of the character c in the string s.
Returns a pointer to the matched character or NULL if the character is not found. The terminating
null byte is considered part of the string, so that if c is specified as ‘\0’, this function returns a pointer
to the terminator.
strcmp()
--The strcmp() function compares the two strings s1 and s2. It returns an integer less than, equal to,
or greater than zero if s1 is found, respectively, to be less than, to match, or be greater than s2.
strncmp()
--Same as strcmp() except it compares only the first (at most) n bytes of s1 and s2.
strcpy()
--The strcpy() function copies the string pointed to by src, including the terminating null byte, to
the buffer pointed to by dest. The destination string dest must be large enough to receive the copy.
Returns a pointer to the destination string dest
strncpy()
--Same as strcpy() except that at most n bytes of src are copied. If there is no null byte among the
first n bytes of src, the string placed in dest will not be null-terminated. If the length of src is less than
n, this function will write additional null bytes to dest to ensure that a total of n bytes are written.
Returns a pointer to the destination string dest.
strdup()
--The strdup() function returns a pointer to a new string which is a duplicate of the string s. Memory
for the new string is obtained with malloc(), and can be freed with free(). On success, returns a
pointer to the duplicated string. It returns NULL if insufficient memory was available.
strndup()
--Same as strdup() except that at most n bytes are copied. If s is longer than n, only n bytes are
copied, and a terminating null byte is added. On success, returns a pointer to the duplicated string.
It returns NULL if insufficient memory was available.
strlen()
--The strlen() function calculates the length of the string pointed to by s, excluding the terminating
null byte.
strstr()
--The strstr() function finds the first occurrence of the substring needle in the string haystack. The
terminating null bytes are not compared. Returns a pointer to the beginning of the located substring,
or NULL if the substring is not found.

In order to compile the project, you must be using an ARM architecture. Next, input the command:
arm-none-eabi-gcc -o main main.c my_string.s 
Then simply run the executable to run the testing of the Library.
