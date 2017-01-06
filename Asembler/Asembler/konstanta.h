#pragma once
#include<iostream>
#include<string>

using namespace std;

class konstanta{
private:
	string name;
	string value;
public:
	konstanta(string n, string val)
	{
		name = n;
		value = val;
	}

	string getName()
	{
		return name;
	}

	string getValue()
	{
		return value;
	}
};

