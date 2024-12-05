// Pointers and 2D Array

#include <stdio.h>

int main()
{
    int a[3][3] = {6, 2, 5, 0, 1, 3, 4, 9, 8};
    int *p = &a[0][0];
    printf("%p %p %p %p %p \n", p, &a, a[0], &a[0][0], *a); // 100 100 100
    printf("%p %p %p \n", &a + 1, &a[0] + 1, &a[0][0] + 1); // 136 112 104
    printf("%d %d\n", a[1][2], *(*(a + 1) + 2));            // 3 3
}
