// Implementing Queue with Singly Linked List

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct SinglyLinkedListNode typedef SLLNode;
void enqueue(int x);
void dequeue();
void peek();
void display();

// Global Variables

SLLNode *front = NULL;
SLLNode *rear = NULL;

// Main

int main()
{
    while (1)
    {
        int i;
        printf("Input command for following operations in queue.\n"
               "1 enqueue\n2 dequeue\n3 peek\n4 display\n0 exit\n");
        scanf("%d", &i);
        if (i == 1)
        {
            int x;
            printf("Enter data\n");
            scanf("%d", &x);
            enqueue(x);
        }
        else if (i == 2)
        {
            dequeue();
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

void enqueue(int x)
{
    SLLNode *new_node = (SLLNode *)malloc(sizeof(SLLNode));
    new_node->value = x;
    if (rear == NULL)
    {
        front = rear = new_node;
    }
    else
    {
        rear->next = new_node;
        rear = new_node;
    }
}

void dequeue()
{
    if (front == NULL)
    {
        printf("Underflow\n");
    }
    else
    {

        printf("Removed element is %d\n", front->value);
        SLLNode *to_free = front;
        if (front == rear)
        {
            front = rear = NULL;
        }
        else
        {
            front = front->next;
        }
        free(to_free);
    }
}

void peek()
{
    if (front == NULL)
    {
        printf("Queue is empty\n");
    }
    else
    {
        printf("Front element is %d\n", front->value);
    }
}

void display()
{
    if (front == NULL)
    {
        printf("Empty queue\n");
    }
    else
    {
        printf("Elements of queue are:\n");
        SLLNode *temp = front;
        while (temp != NULL)
        {
            printf(" %d", temp->value);
            temp = temp->next;
        }
        printf("\n");
    }
}