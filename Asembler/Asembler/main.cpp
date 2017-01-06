#include <iostream>
#include <string>
#include "asembler.h"

using namespace std;

int main()
{ 
	string file;
	cout << "BasicProcessor Assembly VHD creator:" << endl << "Enter file path/name:" << endl;
	cin >> file;

	if (parse(file))
		cout << "Files created.";
	else
		cout << "Error occurred.";

	cout << endl << "Press enter to continue..." << endl;
	
	cin.ignore();
	cin.get();

	return 0;
}