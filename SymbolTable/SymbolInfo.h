#include <iostream>
#include <string>
#include "FuncDetails.h"
#include "VariableDetails.h"
using namespace std;

class SymbolInfo
{
private:
    string Name;
    string Type;
    SymbolInfo *next;
    FuncDetails *f;
    VariableDetails *v;
    vector<SymbolInfo *> parameterTypes;
    int offset = 0;
    bool isParam;

public:
    SymbolInfo(string name, string type)
    {
        this->Name = name;
        this->Type = type;
        next = nullptr;
        f = nullptr;
        v = nullptr;
        vector<SymbolInfo *> p;
        parameterTypes = p;
        offset = 0;
        isParam = false;
    }
    SymbolInfo(const SymbolInfo &other) : Name(other.Name), Type(other.Type), next(other.next)
    {
        //   f=nullptr;
        //   v=nullptr;
        f = other.f;
        v = other.v;
        vector<SymbolInfo *> p;
        //parameterTypes = p;
        offset = other.offset;
        isParam = other.isParam;
        for (SymbolInfo *x : other.parameterTypes)
        {
           // cout << "old er params " << *x << endl;
            parameterTypes.push_back(x);

        }
        
    }
    ~SymbolInfo()
    {
        // cout<<"deleting symbol info "<<Name<<endl;
    }

    string getName() const { return Name; }
    string getType() const { return Type; }
    SymbolInfo *getNext() const { return next; }

    void setName(const string name) { Name = name; }
    void setType(const string type) { Type = type; }
    void setNext(SymbolInfo *next) { this->next = next; }

    void setVarDetails(VariableDetails *details)
    {
        v = details;
    }
    VariableDetails *getVarDetails() const { return v; }
    void setFuncDetails(FuncDetails *details)
    {
        f = details;
    }
    FuncDetails *getFuncDetails() const { return f; }

    void setArray(int sz = 0)
    {
        v = new VariableDetails(sz);
    }
    void setArray(string vtype, int sz = 0)
    {
        v = new VariableDetails(vtype, sz);
    }
    int getArrayLength() const
    {
        if (v == nullptr)
            return -1;
        return v->getArrayLength();
    }

    bool isArray() const
    {
        if (v == nullptr)
            return false;
        if (v->getArrayLength() < 0)
            return false;
        return true;
    }
    string getVarType() const
    {
        if (v == nullptr)
            return "";
        else
            return v->getVarType();
    }
    void setVarType(string vtype)
    {
        if (v == nullptr)
        {
            v = new VariableDetails(vtype);
            return;
        }
        v->setVarType(vtype);
    }
    void setFunction()
    {
        f = new FuncDetails();
    }
    void setFunction(string returntype, vector<SymbolInfo *> params)
    {
        f = new FuncDetails(returntype, Name);
        parameterTypes = params;
    }

    bool isFunction() const
    {
        if (f == nullptr)
            return false;
        return true;
    }
    bool isDefinedFunction() const
    {
        if (f == nullptr)
            return false;
        return (f->getIsDefined());
    }
    void setParameters(vector<SymbolInfo *> &params)
    {
        if (f == nullptr)
            return;
        setparameters(params);
    }
    void setDefinedFunction()
    {
        if (f == nullptr)
            return;
        f->setIsDefined(true);
    }

    // int getHashIndex(int bucket,) const { return

    vector<SymbolInfo *> getParameters() const
    {
        return parameterTypes;
    }
    SymbolInfo *addParameter(SymbolInfo *s)
    {
        parameterTypes.push_back(s);
        return this;
    }
    SymbolInfo *clearParameter(string s)
    {
        parameterTypes.clear();
        return this;
    }
    void setparameters(vector<SymbolInfo *> newparameters)
    {
        parameterTypes = newparameters;
    }
    string getReturnType() const
    {
        if (f == nullptr)
            return "";
        return f->getReturnType();
    }
    void setReturnType(string returnType)
    {

        f->setReturnType(returnType);
    }
    void setDecLine(int x)
    {
        if (f == nullptr)
            return;
        f->setDeclaredLine(x);
    }
    void setDefLine(int x)
    {
        if (f == nullptr)
            return;
        f->setDefinedLine(x);
    }
    int getDecLine()
    {
        if (f == nullptr)
            return -1;
        return f->getDeclaredLine();
    }
    int getDefLine()
    {
        if (f == nullptr)
            return -1;
        return f->getDefinedLine();
    }

    friend std::ostream &operator<<(std::ostream &os, const SymbolInfo &symbol)
    {
        // os << "SymbolInfo: Lexeme = " << symbol.lexeme << ", Type = " << symbol.type;

        if (symbol.f != nullptr)
        {
            if (symbol.getName() == "main")
            {
                os << "";
                return os;
            }

            os << "<" << symbol.getName() << ",FUNCTION," << symbol.getReturnType() << ">";

            return os;
        }
        if (symbol.v != nullptr)
        {
            if (symbol.isArray())
            {
                os << "<" << symbol.getName() << ",ARRAY>";
            }
            else
            {
                os << "<" << symbol.getName() << "," << symbol.getVarType() << ">";
            }
            return os;
        }
        os << "<" << symbol.getName() << "," << symbol.getType() << ">";
        return os;
    }
    SymbolInfo &operator=(const SymbolInfo &other)
    {
        if (this != &other)
        { // Avoid self-assignment
            this->Name = other.Name;
            this->Type = other.Type;
            this->next = other.next;
            FuncDetails *fc = other.f;
            this->f = new FuncDetails(fc->getReturnType(), fc->getName(), fc->getIsDefined(), fc->getDeclaredLine(), fc->getDefinedLine());
            VariableDetails *vd = other.v;
            this->v = new VariableDetails(vd->getVarType(), vd->getArrayLength());
            // this->parameterTypes=other.parameterTypes;
            vector<SymbolInfo *> pm;
            this->parameterTypes = pm;
            for (auto x : other.parameterTypes)
            {
                this->parameterTypes.push_back(x);
            }
        }
        return *this;
    }
    int getWidth() const
    {
        if (v == nullptr)
            return 0;

        return v->getWidth();
    }
    int getOffset()
    {
        return offset;
    }
    void setOffset(int offset)
    {
        this->offset = offset;
    }

    void setIsParam()
    {
        isParam = true;
    }
    bool getIsParam()
    {
        return isParam;
    }
    // void details(){
    //     cout<<"printing details..."<<endl;
    //     cout<<*this<<endl;
    //     cout<<"function parameters..."<<endl;
    //     cout<<"parameter size= "<<parameterTypes.size()<<endl;
    //     if(parameterTypes.size()){
    //     for(auto v:parameterTypes){
    //         cout<<*v<<", ";
    //     }
    //     cout<<endl;
    //     }
    //     cout<<endl;
    // }
};
