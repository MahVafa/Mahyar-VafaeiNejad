// Recursive Function

#include <iostream>
#include <conio.h>
using namespace std;

void f(int );

int main()
{
  int n;
  cout << "Please Enter A Number: " << " ";
  cin >> n;
  f(n);
  getch() ;
} 

void f(int x)
{
   if (x < 10)	
      cout << x;   //1
    else
	   {
    	 cout<< x % 10 ;   // 3      2
    	 f(x / 10);         //f(12)  f(1)
       }
}
