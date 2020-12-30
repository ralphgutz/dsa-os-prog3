#include <stdio.h>
#include <stdlib.h>

int m = 1;
int n = 5;

struct node{
	int data;
	struct node *next;
};

struct node *head = NULL, *rear = NULL;

struct node *newnode(int data){
	struct node *temp = (struct node*) malloc(sizeof(struct node));
	temp->data = data;
	temp->next = NULL;
	return temp;
}

bool isempty(){
	if(head != NULL) return false;
}

int enqueue(int data){
	struct node *temp = newnode(data);
	
	if(head == NULL && rear == NULL)
		head = rear = temp;
	else{
		rear->next = temp;
		temp->next = head;
		rear = temp;
	}
	
	rear->next = head;
}

int dequeue(){
	struct node *temp = head;
	int data = temp->data;
	
	if(head == rear)
		head = rear = NULL;
	
	if(head != NULL){
		head = head->next;
		free(temp);
	}
	
	return data;
}

int josephus(){
	printf("\nOrder of elimination: ");
	
	while (!isempty()) {
        for (int i = 0; i < m + 1; i++){
        	if(i < m){
        		int data = dequeue();
        		enqueue(data);
			}
			else{
				int data = dequeue();
				
				if(head == NULL){
					printf("\nWinner: %d", data);
					return 0;
				}
				
				printf("%d ", data);
			}
		}	
    } 
}

int main(){
	printf("N (people): ");
	scanf("%d", &n);
	
	printf("M (passes): ");
	scanf("%d", &m);
	
	for(int i = 1; i <= n; i++)
		enqueue(i);
	
	josephus();
}
