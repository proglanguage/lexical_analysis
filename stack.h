//> addapted from https://www.techiedelight.com/stack-implementation/
#ifndef __STACK_H__
#define __STACK_H__

#include <stdlib.h>

typedef struct stack{
    int max; // the max siz of the stack
    int top; // The element in top of the stack
    int* items; // vector of elements in the stack
}stack;

// Utility function to initialize stack
stack* newStack(int capacity);

// Utility function to return the size of the stack
int size(stack *pt);

// Utility function to check if the stack is empty or not
int isEmpty(stack *pt);

// Utility function to check if the stack is full or not
int isFull(stack *pt);

// Utility function to add an element x in the stack
void push(stack *pt, int x);

// Utility function to return top element in a stack
int top(stack *pt);

// Utility function to pop top element from the stack
int pop(stack *pt);

#endif /** __STACK_H__ **/
