// Test script for RADIANCE C&DH
// Find data type sizes in C++
// Write data to a binary file and analyze file size vs size of data

#include <iostream>
#include <fstream>
#include <sys/stat.h>
using namespace std;

int main () {
	// Print some stuff to stdout
	cout << "Hello World!\n";
	std::cout << "Size of int:      " << sizeof(int) << "\n";
	std::cout << "Size of double:   " << sizeof(double) << "\n";
	std::cout << "Size of char:     " << sizeof(char) << "\n";
	std::cout << "Size of short:     " << sizeof(short) << "\n";
	std::cout << "Size of long:     " << sizeof(long) << "\n";
	// Create arrays of varying sizes of random numbers and print their sizes
	char carray100[100];
	char carray100k[100000];
	std::cout << "Size of 100 char array: " << sizeof(carray100) << "\n";
	std::cout << "Size of 100k char array: " << sizeof(carray100k) << "\n";
	// Write array data to binary files
	ofstream out1;
	out1.open("char100.bin", ios::out | ios::binary);
	out1.write(carray100,100);
	out1.close();
	ofstream out2;
	out2.open("char100k.bin", ios::out | ios::binary);
	out2.write(carray100k,100000);
	out2.close();
	// Get file sizes
	struct stat results1;
	struct stat results2;
	if (stat("char100.bin", &results1) == 0) {
		std::cout << "Size of char100.bin: " << results1.st_size << "\n";
	}
	if (stat("char100k.bin", &results2) == 0) {
		std::cout << "Size of char100k.bin: " << results2.st_size << "\n";
	}

	// Test with double type
	double array[10000];
	cout << "\nSize of 10,000 element double array: " << sizeof(array) << "\n";
	// Write to binary file
	ofstream out;
	out.open("double_array.bin", ios::out | ios::binary);
	out.write(array, sizeof(array));
	out.close();
	// Get file size
	struct stat results;
	if(stat("double_array.bin", &results) == 0) {
		cout << "Size of double array binary file: " << results.st_size << "\n";
	}


}