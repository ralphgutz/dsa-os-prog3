#include <stdio.h>
#define MAXSIZE 20

int queue[MAXSIZE];
int front = 0, rear = -1;

bool isfull(){
	if(rear == MAXSIZE-1)
		return true;
	else
		return false;
}

bool isempty(){
	if(front < 0 || front > rear)
		return true;
	else
		return false;
}

int peek(){
	return queue[front];
}

int enqueue(int data){
	if(isfull())
		return 0;

	rear = rear + 1;
	queue[rear] = data;
	
	
	
	return 1;
}

int dequeue(){
	if(isempty())
		return 0;
		
	int data = queue[front];
	front = front + 1;
	
	printf("\n Dequeued %d", data);
	return data;
}

int print(){
	printf("ITEMS: ");
	for(int i=front; i<MAXSIZE; i++){
		printf(" %d", queue[i]);
	}
	printf("\n");
}

int main(){
	int operation;
	int data;
	
	printf("\n1 - Enqueue\n2 - Dequeue\n>");
	scanf("%d", &operation);
	
	if(operation == 1){
		printf("Data: ");
		scanf(" %d", &data);
		enqueue(data);
		printf("\nfront: %d, back: %d\n", queue[front], queue[rear]);
		print();
		main();
	}
	else if(operation == 2){
		dequeue();
		printf("\nfront: %d, back: %d\n", queue[front], queue[rear]);
		print();
		main();
	}
	else{
		return 0;
	}
	
}
