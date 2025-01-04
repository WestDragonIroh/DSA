// Implementing Stack with Singly Linked List

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct SinglyLinkedListNode typedef SLLNode;
void push(int x);
void pop();
void peek();
void display();

// Global Variables

SLLNode *top = NULL;

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
            int x;
            printf("Enter data\n");
            scanf("%d", &x);
            push(x);
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

struct SinglyLinkedListNode
{
    int value;
    struct SinglyLinkedListNode *next;
} typedef SLLNode;

void push(int x)
{
    SLLNode *new_node = (SLLNode *)malloc(sizeof(SLLNode));
    new_node->value = x;
    new_node->next = top;
    top = new_node;
}

void pop()
{
    if (top == NULL)
    {
        printf("Underflow\n");
    }
    else
    {
        SLLNode *temp = top;
        top = top->next;
        printf("Removed element is %d\n", temp->value);
        free(temp);
    }
}

void peek()
{
    if (top == NULL)
    {
        printf("Stack is empty\n");
    }
    else
    {
        printf("Top element is %d\n", top->value);
    }
}

void display()
{
    if (top == NULL)
    {
        printf("Empty stack\n");
    }
    else
    {
        printf("Elements of stack are:\n");
        SLLNode *temp = top;
        while (temp != NULL)
        {
            printf("%d\n", temp->value);
            temp = temp->next;
        }
    }
}