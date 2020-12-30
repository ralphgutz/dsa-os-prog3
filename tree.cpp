#include <stdio.h>
#include <stdlib.h>
#define MAX 10

struct node *queue[MAX];
int front = 0, rear = -1;
bool isempty();
int enqueue(struct node*);
int dequeue();
int display();

struct node{
	char data;
	struct node *left;
	struct node *right;
};

struct node *root = NULL;

struct node *newnode(char data){
    struct node *node = (struct node*) malloc(sizeof(struct node));
    node->data = data;
    node->left = NULL;
    node->right = NULL;
    
    return node;
}

struct node *insert(char data, char left, char right){
	front = 0, rear = -1;
	
	if(root == NULL){
		root = newnode(data);
		root->left = newnode(left);
		root->right = newnode(right);
	}
	else{
		enqueue(root);

		while(!isempty()){
			struct node *temp = queue[front];
			dequeue();
			
			printf("\n - evaluating %c", temp->data);
			
			if(temp->left->data == data){
				
				temp->left->left = newnode(left);

				temp->left->right = newnode(right);
				
				printf("\n - added left");
				break;
			}
			else{
				printf("\n - not found, pushing %c (left)", temp->left->data);
				enqueue(temp->left);
			}
			
			if(temp->right->data == data){

				temp->right->left = newnode(left);
				
				temp->right->right = newnode(right);

				printf("\n - added right");
				break;
			}
			else{
				printf("\n - not found, pushing %c (right)", temp->right->data);
				enqueue(temp->right);
			}
			
			printf("\n");
		}
	}
}


void preorderTraversal(struct node *node){
	if(node != NULL){
		if(node->data != NULL)
			printf("%c ", node->data);
			
		preorderTraversal(node->left);
		preorderTraversal(node->right);
	}
}

void inorderTraversal(struct node *node){
	if(node != NULL){
		inorderTraversal(node->left);
		
		if(node->data != NULL)
			printf("%c ", node->data);
			
		inorderTraversal(node->right);
	}
}

void postorderTraversal(struct node *node){
	if(node != NULL){
		postorderTraversal(node->left);
		postorderTraversal(node->right);
		
		if(node->data != NULL)
			printf("%c ", node->data);
	}
}


char roots[10], left[10], right[10];
int i = 0;

int output(struct node *node){
	if(node == NULL)
		return 0;

	if(node->data != NULL){
		if(node->left != NULL && node->right != NULL){
			roots[i] = node->data;
			left[i] = node->left->data;
			right[i] = node->right->data;
		}

		i++;
	}
	
	output(node->left);
	output(node->right);
}

int printOutput(){
	printf("\nNode  L-Subtree  R-Subtree");
	for(int i=0; i<10; i++){
		if(roots[i] != NULL){
			if(left[i] == NULL || right[i] == NULL){
				if(left[i] == NULL)
					printf("\n%c     null\t %c", roots[i], right[i]);
				if(right[i] == NULL)
					printf("\n%c     %c\t\t null", roots[i], left[i]);
			}
			else
				printf("\n%c     %c\t\t %c", roots[i], left[i], right[i]);
		}
	}
	
	printf("\n\nRoot of the Tree: %c", root->data);
	printf("\n\nPreorder Traversal: ");
	preorderTraversal(root);
	printf("\nInorder Traversal: ");
	inorderTraversal(root);
	printf("\nPostorder Traversal: ");
	postorderTraversal(root);
}

bool isfull(){
	if(rear == MAX-1)
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

int enqueue(struct node *tempNode){
	if(isfull() || tempNode->data == NULL)
		return 0;

	rear = rear + 1;
	queue[rear] = tempNode;
	
	return 1;
}

int dequeue(){
	if(isempty())
		return 0;
		
	front = front + 1;
}


int main(){
	printf("Format: root,left-subtree,right-subtree\n");
	
//	while(1){
//		char input[10];
//		char data[2];
//		int j = 0;
//		int size = sizeof(input) / sizeof(input[0]);
//		printf("\n>");
//		scanf("%s", input);
//		
//		if(input[0] == '0'){
//			printf("\nPreorder Traversal: ");
//			preorderTraversal(root);
//			printf("\nInorder Traversal: ");
//			inorderTraversal(root);
//			printf("\nPostorder Traversal: ");
//			postorderTraversal(root);
//			break;
//		}
//	
//		for(int i=0; i<size; i++){
//			if((input[i] == 'n' && input[i+1] == 'u' && input[i+2] == 'l' && input[i+3] == 'l')){
//				data[j] = NULL;
//				j++;
//				i = i + 3;
//			}
//			else if(input[i] == ','){
//				continue;
//			}
//			else{
//				data[j] = input[i];
//				j++;
//			}
//		}
//
//		insert(data[0], data[1], data[2]);
//		
//	}
	


	insert('A', 'B', 'E');
	insert('B', 'C',  NULL);
	insert('C', NULL, 'D');
	insert('E', 'F', 'H');
	insert('F', NULL, 'G');
	insert('H', 'I', 'J');
	printf("\n\n");
	output(root);
	printOutput();
}
