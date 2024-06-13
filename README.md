# Introduction to CTFs

## Build and Run Docker Container
1. Build the Docker image: `docker build -t mini-ctf .`
2. Run the Docker container: `docker run -d -p 8080:80 mini-ctf`
3. Access the web challenge in your browser at http://localhost:8080 or through the console with `docker exec -it <container_id> /bin/bash`

## Challenge Walkthroughs
### Web Exploitation
**Description:** A web application with a login form vulnerable to SQL injection.

**Walkthrough:**
1. Navigate to http://localhost:8080.
2. Enter `' OR '1'='1'--` as the username and anything as the password.
3. This should bypass the login and display the flag.

**Flag:** flag{web_exploitation_success}

### Reverse Engineering
**Description:** A binary file that requires a specific input to produce the flag.

**Walkthrough:**
1. Access the Docker container: `docker exec -it <container_id> /bin/bash`
2. Use strings and gdb to analyze the reverseme binary.
3. `gdb reverseme`
4. Identify the correct input by analyzing the binary. The correct input is reverseme.
```bash
(gdb) break main
Breakpoint 1 at 0x11ba: file /ctf/reverseme.c, line 14.
(gdb) run
Starting program: /ctf/reverseme
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 1, main () at /ctf/reverseme.c:14
14      /ctf/reverseme.c: No such file or directory.
(gdb) break check_point
Function "check_point" not defined.
Make breakpoint pending on future shared library load? (y or [n]) n
(gdb) break check_password
Breakpoint 2 at 0x555555555175: file /ctf/reverseme.c, line 5.
(gdb) continue
Continuing.
Enter the password: password

Breakpoint 2, check_password (password=0x7fffffffea30 "password") at /ctf/reverseme.c:5
5       in /ctf/reverseme.c
(gdb) disassemble check_password
Dump of assembler code for function check_password:
   0x0000555555555169 <+0>:     push   %rbp
   0x000055555555516a <+1>:     mov    %rsp,%rbp
   0x000055555555516d <+4>:     sub    $0x10,%rsp
   0x0000555555555171 <+8>:     mov    %rdi,-0x8(%rbp)
=> 0x0000555555555175 <+12>:    mov    -0x8(%rbp),%rax
   0x0000555555555179 <+16>:    lea    0xe88(%rip),%rdx        # 0x555555556008
   0x0000555555555180 <+23>:    mov    %rdx,%rsi
   0x0000555555555183 <+26>:    mov    %rax,%rdi
   0x0000555555555186 <+29>:    call   0x555555555050 <strcmp@plt>
   0x000055555555518b <+34>:    test   %eax,%eax
--Type <RET> for more, q to quit, c to continue without paging--
   0x000055555555518d <+36>:    jne    0x5555555551a0 <check_password+55>
   0x000055555555518f <+38>:    lea    0xe82(%rip),%rax        # 0x555555556018
   0x0000555555555196 <+45>:    mov    %rax,%rdi
   0x0000555555555199 <+48>:    call   0x555555555030 <puts@plt>
   0x000055555555519e <+53>:    jmp    0x5555555551af <check_password+70>
   0x00005555555551a0 <+55>:    lea    0xea8(%rip),%rax        # 0x55555555604f
   0x00005555555551a7 <+62>:    mov    %rax,%rdi
   0x00005555555551aa <+65>:    call   0x555555555030 <puts@plt>
   0x00005555555551af <+70>:    nop
   0x00005555555551b0 <+71>:    leave
   0x00005555555551b1 <+72>:    ret
--Type <RET> for more, q to quit, c to continue without paging--
End of assembler dump.
(gdb) break *0x555555555186
Breakpoint 3 at 0x555555555186: file /ctf/reverseme.c, line 5.
(gdb) run
The program being debugged has been started already.
Start it from the beginning? (y or n) y
Starting program: /ctf/reverseme
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 1, main () at /ctf/reverseme.c:14
14      in /ctf/reverseme.c
(gdb) continue
Continuing.
Enter the password: password

Breakpoint 2, check_password (password=0x7fffffffea30 "password") at /ctf/reverseme.c:5
5       in /ctf/reverseme.c
(gdb) continue
Continuing.

Breakpoint 3, 0x0000555555555186 in check_password (password=0x7fffffffea30 "password") at /ctf/reverseme.c:5
5       in /ctf/reverseme.c
(gdb) x/s 0x555555556008
0x555555556008: "reverseme"
```
5. Run the binary with the correct input: `./reverseme reverseme`

**Flag:** flag{reverse_engineering_is_fun}

##  Forensics
**Description:** An image file that contains hidden data using steganography.

**Walkthrough:**
1. Access the Docker container: `docker exec -it <container_id> /bin/bash`
2. Extract the hidden message using steghide: `steghide extract -sf not_a_flag.jpg`
3. Enter the passphrase (password) as ``. (empty)
4. Open the extracted file (flag.txt) to view the flag: `cat flag.txt`

**Flag:** flag{stego_is_fun}

## Cryptography
**Description:** An encrypted message using a Caesar cipher with a shift of 3.

**Walkthrough:**
1. Access the Docker container: `docker exec -it <container_id> /bin/bash`
2. The encrypted message is in the crypto.txt file: `cat crypto.txt`
3. Decrypt the message by shifting each letter 3 places back in the alphabet.
```python
def decrypt_caesar_cipher(text, shift):
    result = ""
    for char in text:
        if char.isalpha():
            shift_base = ord('a') if char.islower() else ord('A')
            result += chr((ord(char) - shift_base - shift) % 26 + shift_base)
        else:
            result += char
    return result

encrypted_message = "Wkh Iodj lv: Iodj{vlpsoh_fdhvdu_flskhu}"

# Decrypt the message with a shift of 3
decrypted_message = decrypt_caesar_cipher(encrypted_message, 3)
print("Decrypted message:", decrypted_message)
```
4. Decrypted message: `The flag is: flag{simple_caesar_cipher}`

**Flag:** flag{simple_caesar_cipher}

## Binary Exploitation
**Description:** A vulnerable program that can be exploited via buffer overflow.

**Walkthrough:**
1. Access the Docker container: `docker exec -it <container_id> /bin/bash`
2. Analyze the vuln binary with gdb to identify the buffer overflow vulnerability: `gdb vuln`
3. Or type `strings vuln` to see the hardcoded flag.
```bash
root@78874e355351:/ctf# strings vuln
/lib64/ld-linux-x86-64.so.2
puts
gets
__libc_start_main
__cxa_finalize
printf
libc.so.6
GLIBC_2.2.5
GLIBC_2.34
_ITM_deregisterTMCloneTable
__gmon_start__
_ITM_registerTMCloneTable
PTE1
u+UH
Congratulations! The flag is: flag{buffer_overflow_success}
Enter your input:
```
   
**Flag:** flag{binary_exploitation_success}
