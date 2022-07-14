# include <iostream>
# include <conio.h>
# include <math.h>
using namespace std;


void Aval(int a[] , int n)
  {
  	int i , j , c;
  	for (i = 0; i < n; i ++)
   {
   	 c = 0;
   	 a[i] = i + 1;
   	 for (j = 1; j <= a[i] ; j ++)
   	   {
   	   	  if (a[i] % j == 0)
   	   	    c += 1;
   	   }
   	   	    if (c > 2 || a[i] == 1)
   	   	      cout << a[i]  << '\n';
   	   	    else 
   	   	      cout << a[i] << " " << "*Prime*" << '\n';	 
   }
  }
  
//void Aval(int [] , int); //prototype

main()
{
   int n ;
   cout << "Please Enter A Number: ";
   cin >> n;
   int a[n];
   Aval(a , n);
}
 
