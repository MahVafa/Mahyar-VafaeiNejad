set i index of houses /1*20/ ;
set j index of potential Firestations /1,2,3,4/ ;
Parameters f(j)  /1=100,2=100,3=200,4=300/
c(j) /1=150,2=100,3=50,4=100/
d(i) /1=10,2=10,3=10,4=10,5=10,6=10,7=10,8=10,9=10,10=10,11=10,12=10,13=10,14=10,15=10,16=10,17=10,18=10,19=10,20=10/;
Variables
z
binary Variables
x(j)
a(i,j)
;
Equations
obj
co1(i)
co2(j)
;

obj  ..    z =e= sum(j,f(j)*x(j));
co1(i)   ..   sum(j,a(i,j)*x(j)) =e=1 ;
co2(j)  ..  sum(i,d(i)*a(i,j)) =l= c(j)*x(j)

Model SetCovering /all/;
Solve SetCovering using MINLP min z;
Display  x.l,a.l,z.l  ;
