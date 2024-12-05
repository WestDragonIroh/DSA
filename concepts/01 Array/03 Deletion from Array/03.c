// Deletion from Array

#include <stdio.h>

int main()
{
    int a[50], size;
    printf("Enter size of array: ");
    scanf("%d", &size);
    printf("Enter array elements:\n");
    for (int i = 0; i < size; i++)
    {
        scanf("%d", &a[i]);
    }
    int pos;
    printf("Enter the position to delete data: ");
    scanf("%d", &pos);
    if (pos >= 0 && pos < size)
    {
        for (int i = pos; i < size; i++)
        {
            a[i] = a[i + 1];
        }
        size--;
    }
    else
    {
        printf("Position out of bound");
    }
    for (int i = 0; i < size; i++)
    {
        printf("%d ", a[i]);
    }
    return 0;
}
