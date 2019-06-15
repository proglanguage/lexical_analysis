//> addapted from https://www.techiedelight.com/stack-implementation/
#include "stack.h"

// Utility function to initialize stack
stack* newStack(int capacity)
{
    stack *pt = (stack*)malloc(sizeof(stack));

    pt->max = capacity;
    pt->top = -1;
    pt->items = (char**)malloc(sizeof(char*) * capacity);

    return pt;
}

// Utility function to return the size of the stack
int size(stack *pt)
{
    return pt->top + 1;
}

// Utility function to check if the stack is empty or not
int isEmpty(stack *pt)
{
    return pt->top == -1;   // or return size(pt) == 0;
}

// Utility function to check if the stack is full or not
int isFull(stack *pt)
{
    return pt->top == pt->max - 1;  // or return size(pt) == pt->maxsize;
}

// Utility function to add an element x in the stack
void push(stack *pt, char* x)
{
    // check if stack is already full. Then inserting an element would
    // lead to stack overflow
    if (isFull(pt))
    {
        printf("OverFlow\nProgram Terminated\n");
        exit(EXIT_FAILURE);
    }

    printf("Inserting %s\n", x);

    // add an element and increments the top index
    pt->items[++pt->top] = x;
}

// Utility function to return top element in a stack
char* top(stack *pt)
{
    // check for empty stack
    if (!isEmpty(pt))
        return pt->items[pt->top];
    else
        exit(EXIT_FAILURE);
}

// Utility function to pop top element from the stack
char* pop(stack *pt)
{
    // check for stack underflow
    if (isEmpty(pt))
    {
        printf("UnderFlow\nProgram Terminated\n");
        exit(EXIT_FAILURE);
    }

    printf("Removing %s\n", top(pt));

    // decrement stack size by 1 and (optionally) return the popped element
    return pt->items[pt->top--];
}
