int i,j;
int main(){
 
  int k,ll,m,n,o,p;

  p=1;
  for(k=1;k<=5;k++)p=p*k;

  println(p);

  p=0;
  k=6;
  while(k--)p=p+k;

  println(p);


 
  i = 1;
  i=3+5+6+8;
  println(i);
  
  j = 5 + 8;
  println(j);
  
  k = i + 2*j;
  println(k);

  m = k%9;
  println(m);
 
  n = m <= ll;
  println(n);
 
  o = i != j;
  println(o);
 
  p = n || o;
  println(p);
 
  p = n && o;
  println(p);
  
  p++;
  println(p);
 
  k = -p;
  println(k);
 
  return 0;
}