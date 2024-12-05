// Array and Pointers

#include <stdio.h>

int main()
{
    int a[] = {6, 2, 1, 5, 3};
    int *p = a;
    printf("%p %p\n", a, p);
    p++;
    printf("%p %d\n", p, *p);
    int i = 2;
    printf("%d %d\n", a[i], i[a]);
    printf("%p %p\n", a+1, &a + 1);
    printf("%d %d", *(a+1), *a + 1);
}
