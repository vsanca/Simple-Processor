#pragma once
#include<fstream>
#include<string>
#include<sstream>
#include<iostream>
#include <algorithm>
#include"labela.h"
#include"konstanta.h"
#include<vector>
#include<bitset>

using namespace std;

bool append_source(string source_name, ofstream &file);
bool data_scanner(ifstream &file, ofstream &data, string token1, string token2, vector<konstanta> konstante);
bool instruction_scanner(ifstream &file, ofstream &data, string token1, string token2, vector<labela> labele, vector<konstanta> konstante);
vector<labela> label_scanner(ifstream &file, string token1, string token2);
vector<konstanta> const_scanner(ifstream &file, string token1, string token2);
string tokenize(string line, vector<labela> labele, vector<konstanta> konstante);


bool parse(string file_name)
{
	ifstream program;
	ofstream data, instruction;
	string d = "data_ram.vhd", i = "instr_rom.vhd";
	vector<labela> labele;
	vector<konstanta> konstante;

	program.open(file_name);
	if (program.is_open())
	{
		konstante = const_scanner(program, "constants:", "end");
		labele = label_scanner(program, "instruction:", "end");
		program.close();
	}
	else
		return false;

	program.open(file_name);

	if (!program.is_open())
		return false;

	data.open(d);
	if (data.is_open())
	{
		append_source("data_template1.txt", data);
		data_scanner(program, data, "data:", "end", konstante);
		append_source("data_template2.txt", data);
		
		data.close();
	}
	else return false;

	instruction.open(i);
	if (instruction.is_open())
	{
		append_source("instruction_template1.txt", instruction);
		instruction_scanner(program, instruction, "instruction:", "end", labele, konstante);
		append_source("instruction_template2.txt", instruction);
		
		instruction.close();
	}
	else return false;

	return true;
}

//appends designated text file to the file
bool append_source(string source_name, ofstream &file)
{
	string line;
	ifstream source;
	source.open(source_name);

	if (source.is_open())
	{
		while (getline(source,line))
			file << line << endl;
	}
	else
		return false;

	source.close();

	return true;
}

//writes translated code to the final source file
bool data_scanner(ifstream &file, ofstream &data, string token1, string token2, vector<konstanta> konstante)
{
	string tmp="", line;

	int i = 0;

	while ((getline(file, line)) && (line != token1))
		getline(file, line);

	while ((getline(file,tmp)) && (tmp!= token2))
	{
		tmp.erase(remove_if(tmp.begin(), tmp.end(), isspace), tmp.end());
		if (!tmp.empty())
		{
			data << "		" << "sRAM(" + to_string(i) + ")<=";

			tmp.erase(remove_if(tmp.begin(), tmp.end(), isspace), tmp.end());

			for (int j = 0; j < konstante.size(); j++)
			{
				if (tmp == konstante.at(j).getName())
				{
					tmp = konstante.at(j).getValue();
					break;
				}
			}

			if (tmp.find('d') != -1 || tmp.find('D') != -1)
				data << "std_logic_vector(to_unsigned(" << tmp.substr(1) << ",16));" << endl;

			else
				data << "\"" << tmp << "\";" << endl;
			
			i++;
		}
	}

	while (i <= 31)
	{
		data << "		" << "sRAM(" << i << ")<=(others=>'0');"<<endl;
		i++;
	}

	return true;
}

bool instruction_scanner(ifstream &file, ofstream &data, string token1, string token2, vector<labela> labele, vector<konstanta> konstante)
{
	string tmp, line;
	int i = 0;

	getline(file, line);

	while (line != token1)
	{
		getline(file, line);
	}
		

	while ((getline(file,tmp)) && (tmp!= token2))
	{
		if (!tmp.empty())
		{
			if (tmp.find(':') == -1)
			{
				data << "		" << "sINSTRUKCIJE(" << i << ")<=";
				data << tokenize(tmp, labele, konstante) << endl;
				i++;
			}
		}
		
	}

	while (i <= 31)
	{
		data << "		" << "sINSTRUKCIJE(" << i << ")<=(others=>'0');" << endl;
		i++;
	}

	return true;
}

//decides which instruction is written to the final source file
string tokenize(string line, vector<labela> labele, vector<konstanta> konstante)
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
	string addr;

	if (i == 2)
	{
		addr = split[1];
		
		for (int j = 0; j < labele.size(); j++)
		{
			if (labele.at(j).getName() == split[1])
			{
				addr = bitset<9>(labele.at(j).getValue()).to_string();
				break;
			}
		}

		ret_val = split[0] + "&\"" + addr + "\";";
	}

	else if (i == 3)
	{
		if (split[0] == "ld")
			ret_val = "i_ld&" + split[1] + "&" + "\"000\"" + "&" + split[2] + ";";

		else if (split[0] == "st")
			ret_val = "i_st&\"000\"&" + split[2] + "&" + split[1] + ";";

		else if (split[0] == "cmp")
			ret_val = split[0] + "&" + "\"000\"" + "&" + split[2] + "&" + split[1] + ";";

		else if (split[0] == "not")
			ret_val = "i_not&" + split[1] + "&" + split[2] + "&" + "\"000\";";

		else if (split[0] == "movc")
		{
			string split2;

			for (int j = 0; j < konstante.size(); j++)
			{
				if (split[2] == konstante.at(j).getName())
					split[2] = konstante.at(j).getValue();
			}

			if (split[2].find('d') != -1 || split[2].find('D') != -1)
				split2 = "std_logic_vector(to_unsigned(" + split[2].substr(1) + ",6))";
			else
				split2 = split[2];

			ret_val = split[0] + "&" + split[1] + "&" + split2 + ";";
		}

		else
			ret_val = split[0] + "&" + split[1] + "&" + split[2] + "&" + "\"000\";";
	}
	
	else
	{
		if (split[0] == "and")
			ret_val = "i_and&" + split[1] + "&" + split[2] + "&" + split[3] + ";";
		else if (split[0] == "or")
			ret_val = "i_or&" + split[1] + "&" + split[2] + "&" + split[3] + ";";
		else
			ret_val = split[0] + "&" + split[1] + "&" + split[2] + "&" + split[3] + ";";
	}

	return ret_val;
}

vector<labela> label_scanner(ifstream &file, string token1, string token2)
{
	vector<labela> lista;
	string tmp, line;
	int i = 0;

	getline(file, line);

	while (line != token1)
	{
		getline(file, line);
	}

	while ((getline(file, tmp)) && (tmp != token2))
	{
		if (!tmp.empty())
		{
			if (tmp.find(':') != -1)
			{
				tmp.erase(remove_if(tmp.begin(), tmp.end(), isspace), tmp.end());
				tmp.erase(remove(tmp.begin(), tmp.end(), ':'), tmp.end());
				lista.push_back(labela(tmp, i));
			}
			else
				i++;
		}

	}

	return lista;
}

vector<konstanta> const_scanner(ifstream &file, string token1, string token2)
	{
		vector<konstanta> lista;
		string tmp, line;

		getline(file, line);

		while (line != token1)
		{
			getline(file, line);
		}

		while ((getline(file, tmp)) && (tmp != token2))
		{

			if (!tmp.empty())
			{
				if (tmp.find(':') != -1)
				{
					stringstream sline(tmp);
					string split[2];
					int i = 0;

					while (sline.good() && i < 4)
					{
						sline >> split[i];
						++i;
					}


					split[0].erase(remove(split[0].begin(), split[0].end(), ':'), split[0].end());					
					split[1].erase(remove_if(split[1].begin(), split[1].end(), isspace), split[1].end());

					lista.push_back(konstanta(split[0],split[1]));

				}
			}

		}

		return lista;
	}