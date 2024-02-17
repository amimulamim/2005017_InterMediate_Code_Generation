void main(){
    int a,b,i;
    i=-1;
     a=1;
    b=5;
    if(a && b){
        i=i*5;
        println(i);
    }
    b=0;
    if(a && !(b>0)){
        i=i%10+20;
        println(i);
    }
    i=a && !(b>0);
    println(i);
    if((i>0 && i<10) || (i<0 && i>-10))
		i=100;
	else 
		i=200;
	println(i);
    if(!(a && !b)){
        i=212;
        println(i);
    }
}