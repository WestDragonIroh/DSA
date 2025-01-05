// Implementing DEQue with Array

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

void enqueueFront(int x);
void enqueueRear(int x);
void dequeueFront();
void dequeueRear();
void peekFront();
void peekRear();
void display();

// Global Variables

#define N 5
int queue[N];
int front = -1;
int rear = -1;

// Main

int main() {
    while (1) {
        int i;
        printf(
            "Input command for following operations in queue.\n"
            "1 enqueueFront\n2 enqueueRear\n3 dequeueFront\n"
            "4 dequeueRear\n5 peekFront\n6 peekRear\n7 display\n"
            "0 exit\n");
        scanf("%d", &i);
        if (i == 1 || i == 2) {
            int x;
            printf("Enter data\n");
            scanf("%d", &x);
            if (i == 1) {
                enqueueFront(x);
            } else {
                enqueueRear(x);
            }
        } else if (i == 3) {
            dequeueFront();
        } else if (i == 4) {
            dequeueRear();
        } else if (i == 5) {
            peekFront();
        } else if (i == 6) {
            peekRear();
        } else if (i == 7) {
            display();
        } else {
            break;
        }
    }
    return 0;
}

void enqueueFront(int x) {
    if (front == -1 && rear == -1) {
        front = rear = 0;
        queue[front] = x;
    } else if ((front - 1) % N == rear) {
        printf("Overflow\n");
    } else {
        front = (front - 1 + N) % N;
        queue[front] = x;
    }
}

void enqueueRear(int x) {
    if (front == -1 && rear == -1) {
        front = rear = 0;
        queue[rear] = x;
    } else if ((rear + 1) % N == front) {
        printf("Overflow\n");
    } else {
        rear = (rear + 1) % N;
        queue[rear] = x;
    }
}

void dequeueFront() {
    if (front == -1 && rear == -1) {
        printf("Underflow\n");
    } else if (front == rear) {
        printf("Removed element is %d\n", queue[front]);
        front = rear = -1;
    } else {
        printf("Removed element is %d\n", queue[front]);
        front = (front + 1) % N;
    }
}

void dequeueRear() {
    if (front == -1 && rear == -1) {
        printf("Underflow\n");
    } else if (front == rear) {
        printf("Removed element is %d\n", queue[rear]);
        front = rear = -1;
    } else {
        printf("Removed element is %d\n", queue[rear]);
        rear = (rear - 1 + N) % N;
    }
}

void peekFront() {
    if (front == -1 && rear == -1) {
        printf("Queue is empty\n");
    } else {
        printf("Front element is %d\n", queue[front]);
    }
}

void peekRear() {
    if (front == -1 && rear == -1) {
        printf("Queue is empty\n");
    } else {
        printf("Rear element is %d\n", queue[rear]);
    }
}

void display() {
    if (front == -1 && rear == -1) {
        printf("Empty queue\n");
    } else {
        printf("Elements of queue are:\n");
        int i = front;
        while (i != rear) {
            printf(" %d", queue[i]);
            i = (i + 1) % N;
        }
        printf(" %d\n", queue[i]);
    }
}
