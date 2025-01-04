// Singly Circular Linked List

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct SinglyCircularLinkedListNode typedef SCLLNode;
SCLLNode *initSCLL(int arr[], int size);
SCLLNode *insertSCLL(SCLLNode *head, int value, int index);
SCLLNode *deleteSCLL(SCLLNode *head, int index);
SCLLNode *reverseSCLL(SCLLNode *head);
void printSCLL(SCLLNode *head);
SCLLNode *freeSCLL(SCLLNode *head);

// Main

int main()
{
    int arr[] = {1, 2, 3, 4, 5};
    int size = sizeof(arr) / sizeof(arr[0]);
    SCLLNode *head = initSCLL(arr, size);
    printSCLL(head);
    head = insertSCLL(head, 10, 3);
    printSCLL(head);
    head = deleteSCLL(head, 3);
    printSCLL(head);
    head = reverseSCLL(head);
    printSCLL(head);
    head = freeSCLL(head);
    return 0;
}

struct SinglyCircularLinkedListNode
{
    int value;
    struct SinglyCircularLinkedListNode *next;
} typedef SCLLNode;

SCLLNode *initSCLL(int arr[], int size)
{
    SCLLNode *head, *new_node, *temp;
    head = NULL;
    for (int i = 0; i < size; i++)
    {
        new_node = (SCLLNode *)malloc(sizeof(SCLLNode));
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
    temp->next = head;
    return head;
}

SCLLNode *insertSCLL(SCLLNode *head, int value, int index)
{
    SCLLNode *new_node, *temp;
    temp = head;
    new_node = (SCLLNode *)malloc(sizeof(SCLLNode));
    new_node->value = value;
    if (index < 0)
    {
        printf("Index out of bound\n");
        free(new_node);
    }
    else
    {
        int i = 0;
        while (temp->next != head)
        {
            if (i + 1 == index)
            {
                new_node->next = temp->next;
                temp->next = new_node;
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
    return head;
}

SCLLNode *deleteSCLL(SCLLNode *head, int index)
{
    SCLLNode *temp, *next_node;
    if (index < 0)
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

SCLLNode *reverseSCLL(SCLLNode *head)
{
    if (head != NULL && head->next != head)
    {
        SCLLNode *prev_node, *curr_node, *next_node;
        prev_node = head;
        curr_node = next_node = head->next;
        while (next_node != head)
        {
            next_node = next_node->next;
            curr_node->next = prev_node;
            prev_node = curr_node;
            curr_node = next_node;
        }
        curr_node->next = prev_node;
        head = prev_node;
    }
    return head;
}

void printSCLL(SCLLNode *head)
{
    printf("The linked list is:\n");
    if (head == NULL)
    {
        printf("NULL\n");
    }
    else
    {
        SCLLNode *temp = head;
        while (temp->next != head)
        {
            printf("%d -> ", temp->value);
            temp = temp->next;
        }
        printf("%d -> HEAD\n", temp->value);
    }
}

SCLLNode *freeSCLL(SCLLNode *head)
{
    SCLLNode *temp = head;
    if (head != NULL)
    {
        while (temp->next != head)
        {
            SCLLNode *to_free = temp;
            temp = temp->next;
            free(to_free);
        }
        free(temp);
    }
    return head;
}
