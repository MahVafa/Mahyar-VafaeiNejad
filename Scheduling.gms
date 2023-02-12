set i  index of Machines /1,2/  ;
set j  index of Jobs /1,2,3,4,5,6,7,8,9,10/ ;
Table t(i,j)  Processing times
     1    2   3   4   5   6   7   8   9   10
1    3    5   1   8   9   2   10  4   25  3
2    4    1   17  3   4   2   10  6   6   7
;

Parameters  f(i)   /1=20,2=30/;
Variable Z objective function ;
binary variable
x(i,j) ;
Equation
obj
co1(i)
co2(j)
;
obj  ..  Z =e= sum((i,j),x(i,j)*t(i,j)) ;
co1(i) ..  sum(j,x(i,j)*t(i,j)) =l= f(i);
co2(j) ..  sum(i,x(i,j))=e= 1
Model Scheduling /All/;
Solve Scheduling using MIP min Z;
display Z.l,x.l;
