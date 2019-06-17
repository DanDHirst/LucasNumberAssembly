// mixedProject.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
#include "pch.h"
#include <iostream>
using namespace std;
extern "C" void addFunc();
extern "C" int readInteger() {
	int i;
	cin >> i;
	return i;
}
extern "C" void printInteger(int i) {
	cout << i << endl;
}
extern "C" void printString(char* s) {
	cout << s;
	return;
}
// main stub driver
int main() {
	addFunc();
	return 0;
}