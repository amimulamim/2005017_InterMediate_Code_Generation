void main(){
    int d[20],t;
    d[2]=5;
    t=d[2];
    println(t);
    //d[3]=d[2];
    d[3]=7;
    t=d[3]+d[2];
    println(t);
    d[3]=d[2];
    t=d[3]+d[2];

    println(t);

}