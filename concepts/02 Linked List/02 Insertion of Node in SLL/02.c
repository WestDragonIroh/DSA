// Insertion of Node in SLL

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct SinglyLinkedListNode typedef SLLNode;
SLLNode *initSLL(int arr[], int size);
SLLNode *insertSLL(SLLNode *head, int value, int index);
void printSLL(SLLNode *head);
void freeSLL(SLLNode *head);

int main()
{
    int arr[] = {1, 2, 3, 4, 5};
    int size = sizeof(arr) / sizeof(arr[0]);
    SLLNode *head = initSLL(arr, size);
    printSLL(head);
    head = insertSLL(head, 10, 3);
    printSLL(head);
    freeSLL(head);
    return 0;
}

struct SinglyLinkedListNode
{
    int value;
    struct SinglyLinkedListNode *next;
} typedef SLLNode;

SLLNode *initSLL(int arr[], int size)
{
    SLLNode *head, *new_node, *temp;
    head = NULL;
    for (int i = 0; i < size; i++)
    {
        new_node = (SLLNode *)malloc(sizeof(SLLNode));
        new_node->value = arr[i];
        new_node->next = NULL;
        if (head == NULL)
        {
            head = temp = new_node;
        }
        else
        {
            temp->next = new_node;
            temp = new_node;
        }
    }
    return head;
}

SLLNode *insertSLL(SLLNode *head, int value, int index)
{
    SLLNode *new_node, *temp;
    temp = head;
    new_node = (SLLNode *)malloc(sizeof(SLLNode));
    new_node->value = value;
    if (index < 0)
    {
        printf("Index out of bound\n");
        free(new_node);
    }
    else if (index == 0)
    {
        new_node->next = head;
        head = new_node;
    }
    else
    {
        int i = 0;
        while (temp != NULL)
        {
            if (i + 1 == index)
            {
                new_node->next = temp->next;
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

void printSLL(SLLNode *head)
{
    printf("The linked list is:\n");
    while (head != NULL)
    {
        printf("%d -> ", head->value);
        head = head->next;
    }
    printf("NULL\n");
}

void freeSLL(SLLNode *head)
{
    while (head != NULL)
    {
        SLLNode *to_free = head;
        head = head->next;
        free(to_free);
    }
}
