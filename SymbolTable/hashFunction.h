 #include <iostream>
 #include <string>
 using namespace std;
typedef unsigned long long ll;
ll sdbm(string& str) {
    ll hash = 0;
   // int c;

   // while ((c = *str++)) {
   for(char c:str) {
        hash = c + (hash << 6) + (hash << 16) - hash;
    }

    return hash;
}

unsigned long
    djabHash(unsigned char *str)
    {
        unsigned long hash = 5381;
        int c;

        while (c = *str++)
            hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

        return hash;
    }

    unsigned long
    loseloseHash(unsigned char *str)
    {
	unsigned int hash = 0;
	int c;

	while (c = *str++)
	    hash += c;

	return hash;
    }