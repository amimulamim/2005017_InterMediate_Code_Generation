void main(){
    int a;
    a=1;
    if(a>0){
        a=10;
    }
    //println(a);
    if(a<0){
        a=-10+(a<0 && a>-10);
    }

    println(a);
}