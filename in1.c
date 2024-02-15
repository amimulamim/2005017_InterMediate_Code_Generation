void main(){
    int a,b;
    a=(1<5)&&(2<3);
    b=(1<5)&&(2==3);
    println(b);
   b=(2+(3*5)*9+8)/7;
    println(a);
    println(b);
    b=(1<5)||(2<3);
    println(b);
    b=(1>5)||(2<3);
    println(b);
    b=(1>5)||(2>3);
    println(b);
    b=(1!=5) && (2!=(3-1));
    println(b);
        b=(1!=5) && (2==(3-1));
    println(b);
        b=(1!=5) && (2<=(3-1));
    println(b);
        b=(1!=5) && (2>=(3-1));
    println(b);
        b=(1!=5) && (2>(3-1));
    println(b);
}