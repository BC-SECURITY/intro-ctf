#include <stdio.h>
#include <string.h>

void print_flag() {
    printf("Congratulations! The flag is: flag{buffer_overflow_success}\n");
}

void vuln() {
    char buffer[64];
    printf("Enter your input: ");
    gets(buffer);
    printf("You entered: %s\n", buffer);
}

int main() {
    vuln();
    return 0;
}