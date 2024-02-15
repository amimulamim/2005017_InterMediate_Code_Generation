void cc(int a);

void d(int a);
void e(int a);

void f(int x,int b){
    int p,q,r;
    x=x*3+10;
   println(x);
   // a=17;
   cc(b);
   p=2;
   q=3;
}

void cc(int a){
    int x,y;
    a=a*2;
    println(a);
    d(a);
    y=11;
    println(y);
}
void d(int a){
    int q,s;
    a=a*2;
    println(a);
    e(a);
    println(a);
    s=55;
    println(s);
    

}
void testing(int z,int y){
    
  
}

void e(int z){
    z=z*2;
    println(z);
    testing(z*3,10);
    //a=a*4;
}

int a,b;
void k(){
    int c;
    
    c=17;
    println(c);
    a=26;
    f(13,a);
    println(a);
    b=a%10;
    

}
void main(){
    k();
    println(b);
}