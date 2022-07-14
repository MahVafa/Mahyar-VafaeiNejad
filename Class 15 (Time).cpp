# include <iostream>
# include <iomanip>
# include <conio.h>
# include <cstring>

using namespace std;

class Time
{
	
  private :
  	int hour, minute , second;
  	
  public :
  	Time ()
  	{
  		hour = 0; minute = 0; second = 0;
  		cout << "Constructor was called" << endl;
  	}
  	
  	~ Time ()
  	{
  		cout << "Destructor was called" << endl;
  	}
  	
  	
  	void SetTime ()
  	{
  	  int h , m , s;
  	  cout << "Please Enter An Hour " << endl;
	  cin >> h;
	  cout << "Please Enter A Minute " << endl;
	  cin >> m;
	  cout << "Please Enter A Second " << endl;
	  cin >> s;
	  hour = h;
	  minute = m;
	  second = s;
	  	
  	}
  	
	friend Time AddTimes (Time a , Time b);
	
  	friend void PrintTime(Time c);
  
};

Time AddTimes(Time a , Time b)
{
	Time Total;
	Total.hour = a.hour + b.hour;
	Total.minute = a.minute + b.minute;
	Total.second = a.second + b.second;
	
	while (Total.second >= 60)
	{
	  Total.second -= 60;
	  Total.minute += 1;
	}
	
	while (Total.minute >= 60)
	{
	  Total.minute -= 60;
	  Total.hour += 1;	
	}
	while (Total.hour >= 24)
	{
	  int Discrepancy = Total.hour - 24;	
	  Total.hour = Discrepancy;
	}
	return Total;
}


void PrintTime(Time c)
{
	if (c.hour <= 11)
	  cout << "The Final Time is: " << setfill('0') << setw(2) << c.hour << ":" << setfill('0') << setw(2) << c.minute << ":" << setfill('0') << setw(2) << c.second << " " << "A.M" << endl;
	else
	  cout << "The Final Time is: " << setfill('0') << setw(2) << c.hour << ":" << setfill('0') << setw(2) <<  c.minute << ":" << setfill('0') << setw(2) << c.second << "  " << "P.M" << endl;
}


main()
{

	{
		Time a;
	    PrintTime(a);
	}
	
	Time t1 , t2, T;
	t1. SetTime();
	t2. SetTime();
	T = AddTimes(t1 , t2);
	PrintTime(T);
	
	getch();
}


