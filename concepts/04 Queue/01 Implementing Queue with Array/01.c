// Implementing Queue with Array

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

void enqueue(int x);
void dequeue();
void peek();
void display();

// Global Variables

#define N 5
int queue[N];
int front = -1;
int rear = -1;

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

void enqueue(int x)
{
    if (front == -1 && rear == -1)
    {
        front = rear = 0;
        queue[rear] = x;
    }
    else if ((rear + 1) % N == front)
    {
        printf("Overflow\n");
    }
    else
    {
        rear = (rear + 1) % N;
        queue[rear] = x;
    }
}

void dequeue()
{
    if (front == -1 && rear == -1)
    {
        printf("Underflow\n");
    }
    else if (front == rear)
    {
        printf("Removed element is %d\n", queue[front]);
        front = rear = -1;
    }
    else
    {
        printf("Removed element is %d\n", queue[front]);
        front = (front + 1) % N;
    }
}

void peek()
{
    if (front == -1 && rear == -1)
    {
        printf("Queue is empty\n");
    }
    else
    {
        printf("Front element is %d\n", queue[front]);
    }
}

void display()
{
    if (front == -1 && rear == -1)
    {
        printf("Empty queue\n");
    }
    else
    {
        printf("Elements of queue are:\n");
        int i = front;
        while (i != rear)
        {
            printf(" %d", queue[i]);
            i = (i + 1) % N;
        }
        printf(" %d\n", queue[i]);
    }
}
