#include<iostream>
#include<string>
#include <cctype>

using namespace std;

string toUppercase(string str) {
    for (int i = 0; i < str.length(); i++) {
        str[i] = std::toupper(static_cast<unsigned char>(str[i]));
    }
    return str;
}
