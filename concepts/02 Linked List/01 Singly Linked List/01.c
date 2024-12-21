// Singly Linked List

#include <stdio.h>
#include <stdlib.h>

typedef struct SinglyLinkedListNode
{
    int value;
    struct SinglyLinkedListNode *next;
} SLLNode;

int main()
{
    SLLNode *head, *new_node, *temp;
    head = NULL;
    int choice = 1;
    while (choice)
    {
        new_node = (SLLNode *)malloc(sizeof(SLLNode));
        printf("Enter data: ");
        scanf("%d", &new_node->value);
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
        printf("Do you want to continue(0, 1)? )");
        scanf("%d", &choice);
    }
    temp = head;
    printf("The linked list is:\n");
    while (temp != NULL)
    {
        printf("%d -> ", temp->value);
        temp = temp->next;
    }
    printf("NULL\n");

    temp = head;
    while (temp != NULL)
    {
        SLLNode *to_free = temp;
        temp = temp->next;
        free(to_free);
    }
    return 0;
}
