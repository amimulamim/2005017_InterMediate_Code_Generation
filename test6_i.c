int w[10];
int main(){
 
	int i; 
	int x[10];	
	w[0]=-2;
	x[0]=w[0];
	i=x[0];	
	println(i);
	x[1]=w[0]++;
	i=x[1];	
	println(i);
	i=w[0];
	println(i);	
	
	i=i+0;
	i=i-0;
	i=i*1;
	println(i);	
    int j;
    j=i<10;
    println(j);
    int a,b;
    a=1;
    b=5;
    if(a && b){
        i=i*5;
        println(i);
    }
    b=0;
    if(a && !b){
        i=i%10+20;
        println(i);
    }

	if((i>0 && j) || (i<0 && i>-10))
		i=100;
	else 
		i=200;
	println(i);	
	
	return 0;
}

