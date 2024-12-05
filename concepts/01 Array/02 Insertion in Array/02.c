// Insertion in Array

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
    int num, pos;
    printf("Enter data you want to insert: ");
    scanf("%d", &num);
    printf("Enter the position to enter data: ");
    scanf("%d", &pos);
    if (pos >= 0 && pos < size)
    {
        for (int i = size; i > pos; i--)
        {
            a[i] = a[i - 1];
        }
        a[pos] = num;
        size += 1;
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
