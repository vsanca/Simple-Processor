#include "asembler.h"

#pragma once
#include<fstream>
#include<string>
#include<sstream>

using namespace std;

bool parse(string file_name)
{
	ifstream program;
	ofstream data, instruction;
	string d = "data_ram.vhd", i = "instr_rom.vhd";

	program.open(file_name);

	data.open(d);
	if (data.is_open())
	{
		append_source("data_template1.txt", data);
		data_scanner(program, data, "data:", "end");
		append_source("data_template2.txt", data);

		data.close;
	}
	else return false;

	instruction.open(i);
	if (instruction.is_open())
	{
		append_source("instruction_template1.txt", instruction);
		instruction_scanner(program, data, "instruction:", "end");
		append_source("instruction_template2.txt", instruction);

		instruction.close;
	}
	else return false;

}

//appends designated text file to the file
bool append_source(string source_name, ofstream &file)
{
	ifstream source;
	source.open(source_name);

	if (source.is_open)
	{
		while (source.getline != NULL)
			file << source.getline;
	}
	else
		return false;

	source.close;
}

//writes translated code to the final source file
bool data_scanner(ifstream &file, ofstream &data, string token1, string token2)
{
	string tmp = "";

	int i = 0;

	while (file.getline != token1)
		file.getline;

	while ((tmp = file.getline) != token2)
	{
		data << "sRAM(" + to_string(i) + ")<=";

		if ((tmp[0] == 'd') || (tmp[0] == 'D'))
			data << "std_logic_vector(to_unsigned(" + tmp.substr(1, tmp.length) + ",16));" << endl;
		else
			data << tmp << endl;

		i++;
	}

	while (i < 31)
	{
		data << "sRAM(" + to_string(i) + ")<=(others=>'0');";
		i++;
	}
}

bool instruction_scanner(ifstream &file, ofstream &data, string token1, string token2)
{
	string tmp;
	int i = 0;

	while (file.getline != token1)
		file.getline;

	while ((tmp = file.getline) != token2)
	{
		data << "sINSTRUKCIJE(" + to_string(i) + ")<=";
		data << tokenize(tmp) << endl;
		i++;
	}

	while (i < 31)
	{
		data << "sINSTRUKCIJE(" + to_string(i) + ")<=" << endl;
		i++;
	}
}

//decides which instruction is written to the final source file
string& tokenize(string line)
{
	stringstream sline(line);
	string split[4];
	int i = 0;

	while (sline.good() && i < 4)
	{
		sline >> split[i];
		++i;
	}

	string ret_val;

	if (i == 2)
	{
		ret_val = split[0] + "&" + split[1];
	}

	else if (i == 3)
	{
		if (split[0] == "ld")
			ret_val = split[0] + "&" + split[1] + "&" + "000" + "&" + split[2];

		else if ((split[0] == "st") || (split[0] == "cmp"))
			ret_val = split[0] + "&" + "000" + "&" + split[2] + "&" + split[1];

		else
			ret_val = split[0] + "&" + split[1] + "&" + split[2] + "&" + "000";
	}

	else
	{
		ret_val = split[0] + "&" + split[1] + "&" + split[2] + "&" + split[3];
	}


}