#include <stdio.h>
#include <string.h>

void check_password(char *password) {
    if (strcmp(password, "reverseme") == 0) {
        printf("Correct! The flag is: flag{reverse_engineering_is_fun}\n");
    } else {
        printf("Incorrect password!\n");
    }
}

int main() {
    char password[100];
    printf("Enter the password: ");
    scanf("%s", password);
    check_password(password);
    return 0;
}
