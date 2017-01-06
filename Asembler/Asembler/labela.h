#pragma once
#include<iostream>
#include<string>

using namespace std;

class labela{
private:
	string name;
	int value;
public:
	labela(string n, int val)
	{
		name = n;
		value = val;
	}

	string getName()
	{
		return name;
	}

	int getValue()
	{
		return value;
	}
};

