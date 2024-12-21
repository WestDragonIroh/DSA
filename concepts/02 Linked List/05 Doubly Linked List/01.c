// Doubly Linked List

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct DoublyLinkedListNode typedef DLLNode;
DLLNode *initDLL(int arr[], int size);
DLLNode *insertDLL(DLLNode *head, int value, int index);
DLLNode *deleteDLL(DLLNode *head, int index);
DLLNode *reverseDLL(DLLNode *head);
void printDLL(DLLNode *head);
DLLNode *freeDLL(DLLNode *head);

// Main

int main()
{
    int arr[] = {1, 2, 3, 4, 5};
    int size = sizeof(arr) / sizeof(arr[0]);
    DLLNode *head = initDLL(arr, size);
    printDLL(head);
    head = insertDLL(head, 10, 3);
    printDLL(head);
    head = deleteDLL(head, 3);
    printDLL(head);
    head = reverseDLL(head);
    printDLL(head);
    head = freeDLL(head);
    return 0;
}

struct DoublyLinkedListNode
{
    int value;
    struct DoublyLinkedListNode *prev;
    struct DoublyLinkedListNode *next;
} typedef DLLNode;

DLLNode *initDLL(int arr[], int size)
{
    DLLNode *head, *new_node, *temp;
    head = NULL;
    for (int i = 0; i < size; i++)
    {
        new_node = (DLLNode *)malloc(sizeof(DLLNode));
        new_node->value = arr[i];
        new_node->prev = NULL;
        new_node->next = NULL;
        if (head == NULL)
        {
            head = temp = new_node;
        }
        else
        {
            temp->next = new_node;
            new_node->prev = temp;
            temp = new_node;
        }
    }
    return head;
}

DLLNode *insertDLL(DLLNode *head, int value, int index)
{
    DLLNode *new_node, *temp;
    temp = head;
    new_node = (DLLNode *)malloc(sizeof(DLLNode));
    new_node->value = value;
    if (index < 0)
    {
        printf("Index out of bound\n");
        free(new_node);
    }
    else if (index == 0)
    {
        new_node->next = head;
        head->prev = new_node;
        head = new_node;
    }
    else
    {
        int i = 0;
        while (temp != NULL)
        {
            if (i + 1 == index)
            {
                new_node->prev = temp;
                new_node->next = temp->next;
                temp->next->prev = new_node;
                temp->next = new_node;
            }
            i++;
            temp = temp->next;
        }
        if (index >= i)
        {
            printf("Index out of bound\n");
            free(new_node);
        }
    }
    return head;
}

DLLNode *deleteDLL(DLLNode *head, int index)
{
    DLLNode *temp, *next_node;
    if (index < 0)
    {
        printf("Index out of bound\n");
    }
    else if (index == 0)
    {
        temp = head;
        head = head->next;
        head->prev = NULL;
        free(temp);
    }
    else
    {
        int i = 0;
        temp = head;
        while (temp->next != NULL && i + 1 < index)
        {
            temp = temp->next;
            i++;
        }
        if (i + 1 != index || temp->next == NULL)
        {
            printf("Index out of bound\n");
        }
        else
        {
            next_node = temp->next;
            temp->next = temp->next->next;
            next_node->next->prev = temp;
            free(next_node);
        }
    }
    return head;
}

DLLNode *reverseDLL(DLLNode *head)
{
    DLLNode *curr_node, *next_node;
    curr_node = head;
    while (curr_node != NULL)
    {
        next_node = curr_node->next;
        curr_node->next = curr_node->prev;
        curr_node->prev = next_node;
        if (next_node == NULL)
        {
            head = curr_node;
        }
        curr_node = next_node;
    }
    return head;
}

void printDLL(DLLNode *head)
{
    printf("The linked list is:\n");
    while (head != NULL)
    {
        printf("%d -> ", head->value);
        head = head->next;
    }
    printf("NULL\n");
}

DLLNode *freeDLL(DLLNode *head)
{
    while (head != NULL)
    {
        DLLNode *to_free = head;
        head = head->next;
        free(to_free);
    }
    return head;
}
