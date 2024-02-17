int main(){
    int a,b,c[3],x;
    a=1*(2+3)%3;
    b= 1<5;
    c[0]=2;
    x=a && !b;
    println(x);

    if(a && b)
    {
        c[0]++;
        c[1]=205;
    }
    else
        c[1]=c[0];
    println(a);
    println(b);
    a=c[0];
    println(a);
    b=c[1];
    println(b);
}
