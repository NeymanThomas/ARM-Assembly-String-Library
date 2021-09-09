@ Thomas Neyman
@ This Assembly code implements some of the the standard <string.h> 
@ library functions in C. The code is primarily for learning purposes
@ and I highly recommend just using the standard library instead of
@ using Assembly code to implement it yourself.

.text
.align 2
.global my_strcat
.global my_strncat
.global my_strchr
.global my_strrchr
.global my_strcmp
.global my_strncmp
.global my_strcpy
.global my_strncpy
.global my_strdup
.global my_strndup
.global my_strlen
.global my_strstr
.global memcpy
.global memchr

.func my_strcat
my_strcat:
        str     fp, [sp, #-4]!      @ Store frame pointer to stack pointer 4 bytes
        add     fp, sp, #0          @ Add frame pointer to stack pointer
        sub     sp, sp, #20         @ Subtract stackpointer offset 20 bytes
        str     r0, [fp, #-16]      @ Store frame pointer offset 16 to register 0
        str     r1, [fp, #-20]      @ Store frame pointer offset 20 to register 1
        mov     r3, #0              @ Write value of #0 to register 3
        str     r3, [fp, #-8]       @ Store frame pointer offset 8 bytes to register 3
        b       .STRCAT2            @ Branch to .STRCAT3
.STRCAT3:
        ldr     r3, [fp, #-8]       @ load register 3 with memory address frame pointer 
        add     r3, r3, #1          @ Add register 3 and off set 1 into register 3
        str     r3, [fp, #-8]       @ Stire register 3 to frame pointer
.STRCAT2:
        ldr     r3, [fp, #-8]       
        ldr     r2, [fp, #-16]      
        add     r3, r2, r3          
        ldrb    r3, [r3]            @ Load register byte
        cmp     r3, #0              
        bne     .STRCAT3	    
        mov     r3, #0		    
        str     r3, [fp, #-12]	    
        b       .STRCAT4	    @ Branch to .STRCAT4
.STRCAT5:
        ldr     r3, [fp, #-12]	    
        ldr     r2, [fp, #-20]	    
        add     r2, r2, r3	    
        ldr     r1, [fp, #-8]	    
        ldr     r3, [fp, #-12]	    
        add     r3, r1, r3	    
        mov     r1, r3		    
        ldr     r3, [fp, #-16]	    
        add     r3, r3, r1	    
        ldrb    r2, [r2]	    
        strb    r2, [r3]	    
        ldr     r3, [fp, #-12]	   
        add     r3, r3, #1	    
        str     r3, [fp, #-12]	    
.STRCAT4:
        ldr     r3, [fp, #-12]	    
        ldr     r2, [fp, #-20]	    
        add     r3, r2, r3	    
        ldrb    r3, [r3]	    
        cmp     r3, #0		    
        bne     .STRCAT5	    @ Branch to .STRCAT5
        ldr     r2, [fp, #-8]	    
        ldr     r3, [fp, #-12]	    
        add     r3, r2, r3	    
        mov     r2, r3	   	    
        ldr     r3, [fp, #-16]	    
        add     r3, r3, r2	    
        mov     r2, #0		    
        strb    r2, [r3]	    
        ldr     r3, [fp, #-16]	    
        mov     r0, r3		    
        add     sp, fp, #0	    
        ldr     fp, [sp], #4	    
        bx      lr		    
.endfunc

.func my_strncat
my_strncat:
	@ Stores destination, source, and n passed in
        str     fp, [sp, #-4]!	    @ ! for register write back
        add     fp, sp, #0
        sub     sp, sp, #28
        str     r0, [fp, #-16]
        str     r1, [fp, #-20]
        str     r2, [fp, #-24]
	@ creates variable in for loop
        mov     r3, #0
        str     r3, [fp, #-8]
        b       .STRNCAT8
.STRNCAT9:
	@ Addition step of for loop
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        str     r3, [fp, #-8]
.STRNCAT8:
	@ Test if destination at i is null pointer
        ldr     r3, [fp, #-8]
        ldr     r2, [fp, #-16]
        add     r3, r2, r3
        ldrb    r3, [r3]
        cmp     r3, #0
        bne     .STRNCAT9
	@ Creates next variable for next for loop
        mov     r3, #0
        str     r3, [fp, #-12]
        b       .STRNCAT10
.STRNCAT12:
	@ Adding destination i + j and = source[j]
        ldr     r3, [fp, #-12]
        ldr     r2, [fp, #-20]
        add     r2, r2, r3
        ldr     r1, [fp, #-8]
        ldr     r3, [fp, #-12]
        add     r3, r1, r3
        mov     r1, r3
        ldr     r3, [fp, #-16]
        add     r3, r3, r1
        ldrb    r2, [r2]
        strb    r2, [r3]
	@ Increment j in for loop
        ldr     r3, [fp, #-12]
        add     r3, r3, #1
        str     r3, [fp, #-12]
.STRNCAT10:
	@ Check if source[j] != null pointer
        ldr     r3, [fp, #-12]
        ldr     r2, [fp, #-20]
        add     r3, r2, r3
        ldrb    r3, [r3]
        cmp     r3, #0
        beq     .STRNCAT11
        ldr     r2, [fp, #-12]
        ldr     r3, [fp, #-24]
        cmp     r2, r3
        blt     .STRNCAT12
.STRNCAT11:
	@ Final, make current destination[i + j] = null pointer
        ldr     r2, [fp, #-8]
        ldr     r3, [fp, #-12]
        add     r3, r2, r3
        mov     r2, r3
        ldr     r3, [fp, #-16]
        add     r3, r3, r2
        mov     r2, #0
        strb    r2, [r3]
	@ Return the destination
        ldr     r3, [fp, #-16]
	@ End the function
        mov     r0, r3
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.endfunc

.func my_strchr
my_strchr:
	@ Store char *s and int c
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        sub     sp, sp, #12
        str     r0, [fp, #-8]
        str     r1, [fp, #-12]
	@ branch to while loop
        b       .STRCHR19
.STRCHR21:
	@ if (!*s++)
        ldr     r3, [fp, #-8]
        add     r2, r3, #1
        str     r2, [fp, #-8]
        ldrb    r3, [r3]
        cmp     r3, #0
        bne     .STRCHR19
	@ return 0 if true
        mov     r3, #0
        b       .STRCHR20
.STRCHR19:
	@ While *s != (char)c
        ldr     r3, [fp, #-8]
        ldrb    r2, [r3]
        ldr     r3, [fp, #-12]
        and     r3, r3, #255
        cmp     r2, r3
        bne     .STRCHR21
	@return the (char *)s
        ldr     r3, [fp, #-8]
.STRCHR20:
	@ Final exit function
        mov     r0, r3
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.endfunc

.func my_strrchr
my_strrchr:
	@ Store char *s and int c
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        sub     sp, sp, #20
        str     r0, [fp, #-16]
        str     r1, [fp, #-20]
	@ create char* variable 0
        mov     r3, #0
        str     r3, [fp, #-8]
.STRRCHR24:
	@ if (*s == (char)c)
        ldr     r3, [fp, #-16]
        ldrb    r2, [r3]
        ldr     r3, [fp, #-20]
        and     r3, r3, #255
        cmp     r2, r3
        bne     .STRRCHR23
	@ return s if true
        ldr     r3, [fp, #-16]
        str     r3, [fp, #-8]
.STRRCHR23:
	@ while (*s++);
        ldr     r3, [fp, #-16]
        add     r2, r3, #1
        str     r2, [fp, #-16]
        ldrb    r3, [r3]
        cmp     r3, #0
        bne     .STRRCHR24
	@ return char* variable created
        ldr     r3, [fp, #-8]
	@ Exit function
        mov     r0, r3
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.endfunc

.func my_strcmp
my_strcmp:
	@ Store char *x and char *y
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        sub     sp, sp, #12
        str     r0, [fp, #-8]
        str     r1, [fp, #-12]
	@ Branch to while loop
        b       .STRCMP27
.STRCMP30:
	@ if (*x != *y)
        ldr     r3, [fp, #-8]
        ldrb    r2, [r3]
        ldr     r3, [fp, #-12]
        ldrb    r3, [r3]
        cmp     r2, r3
        bne     .STRCMP32
	@ increment x
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        str     r3, [fp, #-8]
	@ increment y
        ldr     r3, [fp, #-12]
        add     r3, r3, #1
        str     r3, [fp, #-12]
.STRCMP27:
	@ while (*x)
        ldr     r3, [fp, #-8]
        ldrb    r3, [r3]
        cmp     r3, #0
        bne     .STRCMP30
        b       .STRCMP29
.STRCMP32:
	@ function to break out of loop
        nop
.STRCMP29:
	@ return *(unsigned char*)x - *(unsigned char*)y
        ldr     r3, [fp, #-8]
        ldrb    r3, [r3]
        mov     r2, r3
        ldr     r3, [fp, #-12]
        ldrb    r3, [r3]
        sub     r3, r2, r3
	@ Exit the function
        mov     r0, r3
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.endfunc

.func my_strncmp
my_strncmp:
	@ Store char* s1, char* s2, and int n
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        sub     sp, sp, #20
        str     r0, [fp, #-8]
        str     r1, [fp, #-12]
        str     r2, [fp, #-16]
	@ Branch to while loop
        b       .STRNCMP34
.STRNCMP36:
	@if (*s1++ != *s2++)
        ldr     r3, [fp, #-8]
        add     r2, r3, #1
        str     r2, [fp, #-8]
        ldrb    r2, [r3]
        ldr     r3, [fp, #-12]
        add     r1, r3, #1
        str     r1, [fp, #-12]
        ldrb    r3, [r3]
        cmp     r2, r3
        beq     .STRNCMP34
	@ return *(char*)(s1 - 1) - *(char*)(s2 - 1) if true
        ldr     r3, [fp, #-8]
        sub     r3, r3, #1
        ldrb    r3, [r3]
        mov     r2, r3
        ldr     r3, [fp, #-12]
        sub     r3, r3, #1
        ldrb    r3, [r3]
        sub     r3, r2, r3
        b       .STRNCMP35
.STRNCMP34:
	@ While (n--)
        ldr     r3, [fp, #-16]
        sub     r2, r3, #1
        str     r2, [fp, #-16]
        cmp     r3, #0
        bne     .STRNCMP36
	@ return 0 otherwise
        mov     r3, #0
.STRNCMP35:
	@ Exit the function
        mov     r0, r3
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.endfunc

.func my_strcpy
my_strcpy:
	@ store char* destination and char* source
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        sub     sp, sp, #20
        str     r0, [fp, #-16]
        str     r1, [fp, #-20]
	@ if destination is null
        ldr     r3, [fp, #-16]
        cmp     r3, #0
        bne     .STRCPY38
	@ return null
        mov     r3, #0
        b       .STRCPY39
.STRCPY38:
	@ create char *pointer variable
        ldr     r3, [fp, #-16]
        str     r3, [fp, #-8]
	@ Branch to while loop
        b       .STRCPY40
.STRCPY41:
	@ *Destination = *Source
        ldr     r3, [fp, #-20]
        ldrb    r2, [r3]
        ldr     r3, [fp, #-16]
        strb    r2, [r3]
	@ Increment Destination
        ldr     r3, [fp, #-16]
        add     r3, r3, #1
        str     r3, [fp, #-16]
	@ Increment Source
        ldr     r3, [fp, #-20]
        add     r3, r3, #1
        str     r3, [fp, #-20]
.STRCPY40:
	@ while (*source != null terminator)
        ldr     r3, [fp, #-20]
        ldrb    r3, [r3]
        cmp     r3, #0
        bne     .STRCPY41
	@ *Destination = null terminator
        ldr     r3, [fp, #-16]
        mov     r2, #0
        strb    r2, [r3]
	@ return pointer variable
        ldr     r3, [fp, #-8]
.STRCPY39:
	@ Exit function
        mov     r0, r3
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.endfunc

.func my_strncpy
my_strncpy:
	@ Store char *Destination, char *Source, and int n
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        sub     sp, sp, #28
        str     r0, [fp, #-16]
        str     r1, [fp, #-20]
        str     r2, [fp, #-24]
	@ Create variable char *ret
        ldr     r3, [fp, #-16]
        str     r3, [fp, #-8]
.STRNCPY45:
	@ if (!n--)
        ldr     r3, [fp, #-24]
        sub     r2, r3, #1
        str     r2, [fp, #-24]
        cmp     r3, #0
        bne     .STRNCPY43
	@ Return the ret variable
        ldr     r3, [fp, #-8]
        b       .STRNCPY44
.STRNCPY43:
	@ While (*Destination++ = *Source++)
        ldr     r2, [fp, #-20]
        add     r3, r2, #1
        str     r3, [fp, #-20]
        ldr     r3, [fp, #-16]
        add     r1, r3, #1
        str     r1, [fp, #-16]
        ldrb    r2, [r2]
        strb    r2, [r3]
        ldrb    r3, [r3]
        cmp     r3, #0
        bne     .STRNCPY45
	@ branch to next while loop
        b       .STRNCPY46
.STRNCPY47:
	@ Increment *Destination++ and = 0
        ldr     r3, [fp, #-16]
        add     r2, r3, #1
        str     r2, [fp, #-16]
        mov     r2, #0
        strb    r2, [r3]
.STRNCPY46:
	@ while (n--)
        ldr     r3, [fp, #-24]
        sub     r2, r3, #1
        str     r2, [fp, #-24]
        cmp     r3, #0
        bne     .STRNCPY47
	@ return the ret variable created
        ldr     r3, [fp, #-8]
.STRNCPY44:
	@ Exit the function
        mov     r0, r3
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.endfunc

.func
memcpy:
	@ Store void *Destination, void *Source, and int n
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        sub     sp, sp, #28
        str     r0, [fp, #-16]
        str     r1, [fp, #-20]
        str     r2, [fp, #-24]
	@ Create char *dp variable = to Destination
        ldr     r3, [fp, #-16]
        str     r3, [fp, #-8]
	@ Create char *sp variable = to Source
        ldr     r3, [fp, #-20]
        str     r3, [fp, #-12]
	@ Branch to while loop
        b       .MEMCPY49
.MEMCPY50:
	@ Increment *dp and *sp
        ldr     r2, [fp, #-12]
        add     r3, r2, #1
        str     r3, [fp, #-12]
        ldr     r3, [fp, #-8]
        add     r1, r3, #1
        str     r1, [fp, #-8]
        ldrb    r2, [r2]
        strb    r2, [r3]
.MEMCPY49:
	@ while (n--)
        ldr     r3, [fp, #-24]
        sub     r2, r3, #1
        str     r2, [fp, #-24]
        cmp     r3, #0
        bne     .MEMCPY50
	@ return destination
        ldr     r3, [fp, #-16]
	@ Exit function
        mov     r0, r3
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.endfunc

.func my_strdup
my_strdup:
	@ Store the char *s passed in
        push    {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #16
        str     r0, [fp, #-16]
	@ if (!s)
        ldr     r3, [fp, #-16]
        cmp     r3, #0
        bne     .STRDUP53
	@ return NULL
        mov     r3, #0
        b       .STRDUP54
.STRDUP53:
	@ Create variable length using my_strlen
        ldr     r0, [fp, #-16]
        bl      my_strlen
        mov     r3, r0
        str     r3, [fp, #-8]
	@ Create variable *p with malloc(length + 1)
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        mov     r0, r3
        bl      malloc
        mov     r3, r0
        str     r3, [fp, #-12]
	@ if (variable p && variable length)
        ldr     r3, [fp, #-12]
        cmp     r3, #0
        beq     .STRDUP55
        ldr     r3, [fp, #-8]
        cmp     r3, #0
        beq     .STRDUP55
	@ Use memcpy (variable p, variable s, variable length)
        ldr     r2, [fp, #-8]
        ldr     r1, [fp, #-16]
        ldr     r0, [fp, #-12]
        bl      memcpy
	@ index p[length] = null terminator
        ldr     r2, [fp, #-12]
        ldr     r3, [fp, #-8]
        add     r3, r2, r3
        mov     r2, #0
        strb    r2, [r3]
.STRDUP55:
	@ return the p variable
        ldr     r3, [fp, #-12]
.STRDUP54:
	@ exit the function
        mov     r0, r3
        sub     sp, fp, #4
        pop     {fp, lr}
        bx      lr
.endfunc

.func
memchr:
	@ Store void s*, int c, and int n
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        sub     sp, sp, #28
        str     r0, [fp, #-16]
        str     r1, [fp, #-20]
        str     r2, [fp, #-24]
	@ Create variable char *p and = (char*)s
        ldr     r3, [fp, #-16]
        str     r3, [fp, #-8]
	@ Branch to while loop
        b       .MEMCHR57
.MEMCHR60:
	@ if *p != (char)c
        ldr     r3, [fp, #-8]
        ldrb    r2, [r3]
        ldr     r3, [fp, #-20]
        and     r3, r3, #255
        cmp     r2, r3
        beq     .MEMCHR58
	@ Increment cariable p
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        str     r3, [fp, #-8]
        b       .MEMCHR57
.MEMCHR58:
	@ return variable p
        ldr     r3, [fp, #-8]
        b       .MEMCHR59
.MEMCHR57:
	@ while (n--)
        ldr     r3, [fp, #-24]
        sub     r2, r3, #1
        str     r2, [fp, #-24]
        cmp     r3, #0
        bne     .MEMCHR60
	@ return 0
        mov     r3, #0
.MEMCHR59:
	@ Exit function
        mov     r0, r3
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.endfunc

.func my_strndup
my_strndup:
	@ Store char *s and int n
        push    {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #16
        str     r0, [fp, #-16]
        str     r1, [fp, #-20]
	@ Create variable char *p and = memchr(s, null terminator, n)
        ldr     r3, [fp, #-20]
        mov     r2, r3
        mov     r1, #0
        ldr     r0, [fp, #-16]
        bl      memchr
        str     r0, [fp, #-8]
	@ if (p != NULL)
        ldr     r3, [fp, #-8]
        cmp     r3, #0
        beq     .STRNDUP62
	@ n = p - s
        ldr     r2, [fp, #-8]
        ldr     r3, [fp, #-16]
        sub     r3, r2, r3
        str     r3, [fp, #-20]
.STRNDUP62:
	@ p = malloc(n + 1)
        ldr     r3, [fp, #-20]
        add     r3, r3, #1
        mov     r0, r3
        bl      malloc
        mov     r3, r0
        str     r3, [fp, #-8]
	@ if (p != NULL)
        ldr     r3, [fp, #-8]
        cmp     r3, #0
        beq     .STRNDUP63
	@ memcpy(p, s, n)
        ldr     r3, [fp, #-20]
        mov     r2, r3
        ldr     r1, [fp, #-16]
        ldr     r0, [fp, #-8]
        bl      memcpy
	@ variable index p[n] = null terminator
        ldr     r3, [fp, #-20]
        ldr     r2, [fp, #-8]
        add     r3, r2, r3
        mov     r2, #0
        strb    r2, [r3]
.STRNDUP63:
	@ return the variable p
        ldr     r3, [fp, #-8]
	@ Exit the function
        mov     r0, r3
        sub     sp, fp, #4
        pop     {fp, lr}
        bx      lr
.endfunc

.func my_strlen
my_strlen:
	@ Store variable char *s
        str     fp, [sp, #-4]!
        add     fp, sp, #0
        sub     sp, sp, #20
        str     r0, [fp, #-16]
	@ Create variable length = 0
        mov     r3, #0
        str     r3, [fp, #-8]
        mov     r3, #0
	@ Create variable i and Branch to for loop
        str     r3, [fp, #-12]
        b       .STRLEN15
.STRLEN16:
	@ Increment variable Length
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        str     r3, [fp, #-8]
	@ Increment Variable i
        ldr     r3, [fp, #-12]
        add     r3, r3, #1
        str     r3, [fp, #-12]
.STRLEN15:
	@ check s[i] != Null terminator
        ldr     r3, [fp, #-12]
        ldr     r2, [fp, #-16]
        add     r3, r2, r3
        ldrb    r3, [r3]
        cmp     r3, #0
        bne     .STRLEN16
	@ return variable length
        ldr     r3, [fp, #-8]
	@ Exit function
        mov     r0, r3
        add     sp, fp, #0
        ldr     fp, [sp], #4
        bx      lr
.endfunc

.func my_strstr
my_strstr:
	@ Store variables char *x and char *y
        push    {fp, lr}
        add     fp, sp, #4
        sub     sp, sp, #16
        str     r0, [fp, #-16]
        str     r1, [fp, #-20]
	@ if (*y == null terminator)
        ldr     r3, [fp, #-20]
        ldrb    r3, [r3]
        cmp     r3, #0
        bne     .STRSTR66
	@ Return variable x and Branch
        ldr     r3, [fp, #-16]
        b       .STRSTR67
.STRSTR66:
	@ Create variable i and Branch to for loop
        mov     r3, #0
        str     r3, [fp, #-8]
        b       .STRSTR68
.STRSTR72:
	@ if (*(x + i) == *y)
        ldr     r3, [fp, #-8]
        ldr     r2, [fp, #-16]
        add     r3, r2, r3
        ldrb    r2, [r3]
        ldr     r3, [fp, #-20]
        ldrb    r3, [r3]
        cmp     r2, r3
        bne     .STRSTR69
	@ Create variable char* pointer and = my_strstr(x + i + 1, y + 1)
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        ldr     r2, [fp, #-16]
        add     r2, r2, r3
        ldr     r3, [fp, #-20]
        add     r3, r3, #1
        mov     r1, r3
        mov     r0, r2
        bl      my_strstr
        str     r0, [fp, #-12]
	@ return variable pointer if pointer - 1, else NULL
        ldr     r3, [fp, #-12]
        cmp     r3, #0
        beq     .STRSTR70
        ldr     r3, [fp, #-12]
        sub     r3, r3, #1
        b       .STRSTR67
.STRSTR70:
        mov     r3, #0
        b       .STRSTR67
.STRSTR69:
	@ Increment variable i in for loop
        ldr     r3, [fp, #-8]
        add     r3, r3, #1
        str     r3, [fp, #-8]
.STRSTR68:
	@ Check if i < my_strlen(x)
        ldr     r0, [fp, #-16]
        bl      my_strlen
        mov     r2, r0
        ldr     r3, [fp, #-8]
        cmp     r3, r2
        blt     .STRSTR72
	@ return NULL
        mov     r3, #0
.STRSTR67:
	@ Exit function
        mov     r0, r3
        sub     sp, fp, #4
        pop     {fp, lr}
        bx      lr
.endfunc
