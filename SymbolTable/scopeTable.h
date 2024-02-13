
#include "SymbolInfo.h"
//#include "hashFunction.h"
#include<fstream>
typedef unsigned long long ll;

//using namespace std;
//typedef long long ll;

// enum probType
// {
//     LINEAR = 0,
//     QUADRATIC = 1,
//     DOUBLE = 2,
//     CUSTOM = 3,
// };

// class HashTable
// {
// protected:
//     int bucket,size;
//     // Prime_Numbers prime;
//     void init(int bucket)
//     {
//         this->bucket = bucket;
//         size = 0;

//     }

// public:

//     HashTable(int bucket=11)
//     {

//         init(bucket);
//     }

//     virtual bool insert(string name,string key) = 0;
//     virtual int find(string name) = 0;

//     virtual bool remove(string name ) = 0;
//     virtual void print() const = 0;
// };

class ScopeTable //: public HashTable
{

private:
    //ll (*hash_function)(string &name);

    SymbolInfo **table;
    int bucket, size, children;
    string id;
    ScopeTable *parentScope;
    ll hash_function(string& str) {
    ll hash = 0;
    
   // int c;

   // while ((c = *str++)) {
   for(char c:str) {
        hash = c + (hash << 6) + (hash << 16) - hash;
    }

    return hash;
}


public:
    ScopeTable(int n){
        this->bucket = n;
        this->id = "1";

        parentScope = nullptr;
        children = 0;

        size = 0;
        //setHashFunc(sdbm);
        table = new SymbolInfo *[bucket];

        for (int i = 0; i < bucket; i++)
        {
            table[i] = nullptr;
        }


    }



    ScopeTable(int bucket, string &id, ScopeTable *parent) //: HashTable(bucket)
    {
        this->bucket = bucket;
        this->id = id;

        parentScope = parent;
        children = 0;

        size = 0;
        // setHashFunc(func);
        table = new SymbolInfo *[bucket];

        for (int i = 0; i < bucket; i++)
        {
            table[i] = nullptr;
        }
    }

    // void setHashFunc(ll (*func)(string &name))
    // {
    //     this->hash_function = func;
    // }

    ~ScopeTable()
    {
        for (int i = 0; i < bucket; i++)
        {
            SymbolInfo *current = table[i];
            while (current != nullptr)
            {
                SymbolInfo *temp = current;
                current = current->getNext();
                delete temp;
            }
        }

        delete[] table;
    }

    void setId(string& id){
        this->id = id;
    }

    string getId() const{
        return this->id;
    }

    void setParent(ScopeTable* parent){
        parentScope=parent;
    }

    ScopeTable* getParent() const{
        return parentScope;
    }

    string generateNewChildId(){
        string child=this->id;
        child+=".";
        child+=to_string(this->children+1);
        return child;
    }

    void incrementChildrenCount(){children++; }


    bool insert(string name, string type)
    {
        if (find(name) >= 0)
            return false;
        SymbolInfo *newSymbol = new SymbolInfo(name, type);

        ll ind = hash_function(name) % bucket;

        if (table[ind] == nullptr)
        {
            table[ind] = newSymbol;
            //cout<<"\t"<<"Inserted  at position "<<"<"<<ind+1<<", "<<1<<"> of ScopeTable# "<<getId()<<endl;
            return true;
        }
        SymbolInfo *current = table[ind];
        int c=1;
        while (current->getNext() != nullptr)
        {
            current = current->getNext();
            c++;
        }
        current->setNext(newSymbol);
        size++;
        //cout<<"\t"<<"Inserted  at position "<<"<"<<ind+1<<", "<<c+1<<"> of ScopeTable# "<<getId()<<endl;
       // Inserted  at position <7, 1> of ScopeTable# 1

        return true;
    }
        bool insert(SymbolInfo *newSymbol)
    {   
        string name = newSymbol->getName();
        if (find(name) >= 0)
            return false;
       

        ll ind = hash_function(name) % bucket;

        if (table[ind] == nullptr)
        {
            table[ind] = newSymbol;
            //cout<<"\t"<<"Inserted  at position "<<"<"<<ind+1<<", "<<1<<"> of ScopeTable# "<<getId()<<endl;
            return true;
        }
        SymbolInfo *current = table[ind];
        int c=1;
        while (current->getNext() != nullptr)
        {
            current = current->getNext();
            c++;
        }
        current->setNext(newSymbol);
        size++;
        //cout<<"\t"<<"Inserted  at position "<<"<"<<ind+1<<", "<<c+1<<"> of ScopeTable# "<<getId()<<endl;
       // Inserted  at position <7, 1> of ScopeTable# 1

        return true;
    }

            bool replace(SymbolInfo *newSymbol)
    {   
        string name = newSymbol->getName();
        if (find(name) < 0)
            return false;
       

        ll ind = hash_function(name) % bucket;

        if (table[ind]->getName() == name)
        {
            newSymbol->setNext((table[ind])->getNext());
            table[ind] = newSymbol;
            //cout<<"\t"<<"Inserted  at position "<<"<"<<ind+1<<", "<<1<<"> of ScopeTable# "<<getId()<<endl;
            return true;
        }
        SymbolInfo *current = table[ind];
        int c=1;
        while (current->getNext() != nullptr )
        {   
            if(current->getNext()->getName()==name){
                newSymbol->setNext(current->getNext()->getNext());
                current->setNext(newSymbol);

                return true;
            }

            current = current->getNext();
            c++;
        }
        //current->setNext(newSymbol);
       // size++;
        //cout<<"\t"<<"Inserted  at position "<<"<"<<ind+1<<", "<<c+1<<"> of ScopeTable# "<<getId()<<endl;
       // Inserted  at position <7, 1> of ScopeTable# 1

        return true;
    }













    int find(string key)
    {
        ll ind = hash_function(key) % bucket;
        SymbolInfo *current = table[ind];
        int c = 1;
        while (current != nullptr)
        {
            if (current->getName() == key)
                return c;
            current = current->getNext();
            c++;
        }
        return -1;
    }
    SymbolInfo *lookup(string key)
    {
        ll ind = hash_function(key) % bucket;
        SymbolInfo *current = table[ind];
        int c = 1;
        while (current != nullptr)
        {
            if (current->getName() == key)
                {   //'23' found at position <5, 1> of ScopeTable# 1
                    //cout<<"\t"<<"'"<<key<<"' found at position "<<"<"<<ind+1<<", "<<c<<"> of ScopeTable# "<<getId()<<endl;
                    ////cout<<"\t"<<"'23' found at position <5, 1> of ScopeTable# 1"<<endl;


                    return current;
                }
            current = current->getNext();
            c++;
        }
        return nullptr;
    }
    SymbolInfo *lookup(string key,int& index,int& c)
    {
        ll ind = hash_function(key) % bucket;
        index = ind;
        SymbolInfo *current = table[ind];
        c = 1;
        while (current != nullptr)
        {
            if (current->getName() == key)
                return current;
            current = current->getNext();
            c++;
        }

        
        return nullptr;
    }

    bool remove(string key)
    {
        ll ind = hash_function(key) % bucket;
        
        SymbolInfo *current = table[ind];
        
        if (current != nullptr && current->getName() == key)
        {
            SymbolInfo *temp = current;
            table[ind] = current->getNext();
            delete temp;
            size--;

            //Deleted '==' from position <2, 1> of ScopeTable# 1.1
            ////cout<<"\t"<<"Deleted '==' from position <2, 1> of ScopeTable# 1.1"<<endl;
            //cout<<"\t"<<"Deleted '"<<key<<"' from position "<<"<"<<ind+1<<", "<<1<<"> of ScopeTable# "<<getId()<<endl;
            return true;
        }
        int c=2;
        while (current != nullptr)
        {
            if (current->getNext()!=nullptr && current->getNext()->getName() == key)
            {
                SymbolInfo *temp = current->getNext();
                current->setNext(temp->getNext());
                delete temp;
                size--;
                //cout<<"\t"<<"Deleted '"<<key<<"' from position "<<"<"<<ind+1<<", "<<1<<"> of ScopeTable# "<<getId()<<endl;
                return true;
            }
            current = current->getNext();
            c++;
        }
        return false;
    }

    void print(ofstream& output) const
    {   
        output<<"\t"<<"ScopeTable# "<<id<<endl;
        for (int i = 0; i < bucket; ++i)
        {

            SymbolInfo *current = table[i];
            if(current!=nullptr){
            output<<"\t";
            output<<i+1;
            output<<"--> ";

            while (current != nullptr)
            {
                
                output << *current<<" ";
                //7 --> (<=,RELOP) --> (foo,FUNCTION)
                current = current->getNext();
            }

            output<< endl;
            }
        }
    }
    vector<SymbolInfo*> getSymbols(){
        vector<SymbolInfo*> vx;
         for (int i = 0; i < bucket; ++i)
        {

            SymbolInfo *current = table[i];
            if(current!=nullptr){
           

            while (current != nullptr)
            {
                
            
                //7 --> (<=,RELOP) --> (foo,FUNCTION)
                vx.push_back(current);
                current = current->getNext();
            }

            
            }
        }

        return vx;

    }
};
