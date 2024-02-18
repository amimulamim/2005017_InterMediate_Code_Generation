// int f(int a){
//     if(a<=1)return 1;
//     return a*f(a-1);
// }


// int g(){
//     return 1;
// }
void main(){
    int x,y,sum;
    // x=f(5);
    // println(x);
    // x=g();
    // y=x;
    
    // println(x);
    // println(y);
    
    sum=0;
    x=10;
    // while(x>0){
    //     sum=sum+x;
    //     x--;
    // }
   // println(sum);
    for(x=0;x<10;x++){
        sum=sum+x;
    }

    println(sum);
}