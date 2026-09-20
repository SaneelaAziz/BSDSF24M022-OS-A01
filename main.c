#include <stdio.h>
#include <stdlib.h>
#include "mystrfunctions.h"
#include "myfilefunctions.h"

int main() {
    printf("--- Testing String Functions ---\n");
    char str1[50] = "Hello";
    char str2[] = " World!";

    printf("Length of '%s': %d\n", str1, mystrlen(str1));
    mystrcat(str1, str2);
    printf("Concatenated: %s\n", str1);

    char copy_target[50];
    mystrcpy(copy_target, "Copied String");
    printf("Copied String: %s\n", copy_target);

    printf("\n--- Testing File Functions ---\n");
    FILE* temp_file = fopen("test_dummy.txt", "w+");
    if (temp_file) {
        fputs("Hello World\nOperating Systems Assignment\nHello again!", temp_file);
        rewind(temp_file);

        int lines = 0, words = 0, chars = 0;
        wordCount(temp_file, &lines, &words, &chars);
        printf("WordCount -> Lines: %d, Words: %d, Chars: %d\n", lines, words, chars);

        rewind(temp_file);
        char** matches = NULL;
        int count = mygrep(temp_file, "Hello", &matches);
        printf("Grep found %d matching lines for 'Hello':\n", count);
        for (int i = 0; i < count; i++) {
            printf("  Matching line %d: %s", i + 1, matches[i]);
            free(matches[i]);
        }
        free(matches);
        fclose(temp_file);
        remove("test_dummy.txt");
    }

    return 0;
}