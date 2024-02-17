int f(int a){
    if(a<=1)return 1;
    return a*f(a-1);
}


int g(){
    return 1;
}
void main(){
    int x,y;
    x=f(5);
    println(x);
    x=g();
    y=x;
    println(x);
    println(y);
}