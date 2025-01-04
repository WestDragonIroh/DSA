// Implementing Stack with Array

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

void push();
void pop();
void peek();
void display();

// Global Variables

#define N 5
int stack[N];
int top = -1;

// Main

int main()
{
    while (1)
    {
        int i;
        printf("Input command for following operations in stack.\n"
               "1 push\n2 pop\n3 peek\n4 display\n0 exit\n");
        scanf("%d", &i);
        if (i == 1)
        {
            push();
        }
        else if (i == 2)
        {
            pop();
        }
        else if (i == 3)
        {
            peek();
        }
        else if (i == 4)
        {
            display();
        }
        else
        {
            break;
        }
    }

    return 0;
}

void push()
{
    int x;
    printf("Enter data\n");
    scanf("%d", &x);
    if (top == N - 1)
    {
        printf("Overflow\n");
    }
    else
    {
        top++;
        stack[top] = x;
    }
}

void pop()
{
    if (top == -1)
    {
        printf("Underflow\n");
    }
    else
    {
        printf("Removed element is %d\n", stack[top]);
        top--;
    }
}

void peek()
{
    if (top == -1)
    {
        printf("Stack is empty\n");
    }
    else
    {
        printf("Top element is %d\n", stack[top]);
    }
}

void display()
{
    printf("Elements of stack are:\n");
    for (int i = top; i >= 0; i--)
    {
        printf("%d\n", stack[i]);
    }
}
