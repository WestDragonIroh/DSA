// Doubly Circular Linked List

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct DoublyCircularLinkedListNode typedef DCLLNode;
DCLLNode *initDCLL(int arr[], int size);
DCLLNode *insertDCLL(DCLLNode *head, int value, int index);
DCLLNode *deleteDCLL(DCLLNode *head, int index);
DCLLNode *reverseDCLL(DCLLNode *head);
void printDCLL(DCLLNode *head);
DCLLNode *freeDCLL(DCLLNode *head);

// Main

int main()
{
    int arr[] = {1, 2, 3, 4, 5};
    int size = sizeof(arr) / sizeof(arr[0]);
    DCLLNode *head = initDCLL(arr, size);
    printDCLL(head);
    head = insertDCLL(head, 10, 3);
    printDCLL(head);
    head = deleteDCLL(head, 3);
    printDCLL(head);
    head = reverseDCLL(head);
    printDCLL(head);
    head = freeDCLL(head);
    return 0;
}

struct DoublyCircularLinkedListNode
{
    int value;
    struct DoublyCircularLinkedListNode *prev;
    struct DoublyCircularLinkedListNode *next;
} typedef DCLLNode;

DCLLNode *initDCLL(int arr[], int size)
{
    DCLLNode *head, *new_node, *temp;
    head = NULL;
    for (int i = 0; i < size; i++)
    {
        new_node = (DCLLNode *)malloc(sizeof(DCLLNode));
        new_node->value = arr[i];
        new_node->prev = NULL;
        new_node->next = NULL;
        if (head == NULL)
        {
            head = temp = new_node;
            temp->prev = temp;
            temp->next = temp;
        }
        else
        {
            new_node->prev = temp;
            temp->next = new_node;
            temp = new_node;
        }
    }
    if (head != NULL)
    {
        head->prev = temp;
        temp->next = head;
    }
    return head;
}

DCLLNode *insertDCLL(DCLLNode *head, int value, int index)
{
    if (index < 0)
    {
        printf("Index out of bound\n");
    }
    else
    {
        DCLLNode *new_node, *temp;
        temp = head;
        new_node = (DCLLNode *)malloc(sizeof(DCLLNode));
        new_node->value = value;

        if (head != NULL)
        {
            int i = 0;
            while (temp->next != head)
            {
                if (i + 1 == index)
                {
                    new_node->next = temp->next;
                    temp->next = new_node;
                    new_node->prev = temp;
                }
                i++;
                temp = temp->next;
            }
            if (index == 0)
            {
                new_node->next = temp->next;
                temp->next = new_node;
                head = new_node;
            }
            else if (index >= i)
            {
                printf("Index out of bound\n");
                free(new_node);
            }
        }
        else if (head == NULL && index == 0)
        {
            new_node->prev = new_node;
            new_node->next = new_node;
            head = new_node;
        }
        else
        {
            printf("Index out of bound\n");
            free(new_node);
        }
    }
    return head;
}

DCLLNode *deleteDCLL(DCLLNode *head, int index)
{
    DCLLNode *temp, *next_node;
    if (index < 0 || head == NULL)
    {
        printf("Index out of bound\n");
    }
    else
    {
        int i = 0;
        temp = head;
        while (temp->next != head && ((index == 0) ^ (i + 1 < index)))
        {
            temp = temp->next;
            i++;
        }
        if (temp->next == head && index != 0)
        {
            printf("Index out of bound\n");
        }
        else
        {
            next_node = temp->next;
            next_node->next->prev = temp;
            temp->next = temp->next->next;
            free(next_node);
            if (index == 0)
            {
                head = temp->next;
            }
        }
    }
    return head;
}

DCLLNode *reverseDCLL(DCLLNode *head)
{
    if (head != NULL && head->next != head)
    {
        DCLLNode *curr_node, *next_node;
        curr_node = head;
        while (curr_node->next != head)
        {
            next_node = curr_node->next;
            curr_node->next = curr_node->prev;
            curr_node->prev = next_node;
            curr_node = next_node;
        }
        curr_node->next = curr_node->prev;
        curr_node->prev = head;
        head->next = curr_node;
        head = curr_node;
    }
    return head;
}

void printDCLL(DCLLNode *head)
{
    printf("The linked list is:\n");
    if (head == NULL)
    {
        printf("NULL\n");
    }
    else
    {
        DCLLNode *temp = head;
        while (temp->next != head)
        {
            printf("%d -> ", temp->value);
            temp = temp->next;
        }
        printf("%d -> HEAD\n", temp->value);
    }
}

DCLLNode *freeDCLL(DCLLNode *head)
{
    DCLLNode *temp = head;
    if (head != NULL)
    {
        while (temp->next != head)
        {
            DCLLNode *to_free = temp;
            temp = temp->next;
            free(to_free);
        }
        free(temp);
    }
    return head;
}
