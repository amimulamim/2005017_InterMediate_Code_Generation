#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

class ParserNode
{
    int firstLine;
    int lastLine;
    string matchedRule;
    string dataType, value;
    vector<ParserNode *> subordinates;
    bool isNonTerminal, isError, isErrRootPrinted;
    vector<SymbolInfo *> declarations;
    bool isGlobal;
    ofstream asmOut;
    SymbolInfo *symbolInfo;
    string trueLabel, falseLabel, nextLabel;
    string op;
    // int isCondit;
    // bool cf;
   //

public:
   // bool conditionality;
    ParserNode(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
    {
       // cout << "const called for parserNode\n";
        this->firstLine = firstLine;
        this->lastLine = lastLine;
        this->matchedRule = matchedRule;
        this->dataType = dataType;
        this->value = value;
        vector<ParserNode *> children;
        subordinates = children;

        isNonTerminal = false;
        isErrRootPrinted = false;
        isError = false;
        isGlobal = true;
        symbolInfo = nullptr;
        trueLabel = "";
        falseLabel = "";
        nextLabel = "";
        op = "";
        //conditionality=false;
       // isc="false";
       
        // size_t found = matchedRule.find("error");
        // isError|= (found != std::string::npos);
        // If found is not equal to std::string::npos, it means "error" was found
    }
    ~ParserNode()
    {   

        cout <<endl<< "--------------------------------destructor--------------------------------" << endl<< endl;
        for (auto p : subordinates)
        {
            delete p;
        }
    }


    string getTrueLabel()
    {
        return trueLabel;
    }
    ParserNode *setTrueLabel(string label)
    {
        this->trueLabel = label;
        if (this->trueLabel != "")
            // cout<<"setTrueLabel to "<<this->trueLabel<<" for "<<this->getRule()<<" at line "<<firstLine<<endl;
            return this;
    }
    string getFalseLabel()
    {
        return falseLabel;
    }
    ParserNode *setFalseLabel(string label)
    {
        this->falseLabel = label;
        if (this->falseLabel != "")
            // cout<<"setFalseLabel to "<<this->falseLabel<<" for "<<this->getRule()<<" at line "<<firstLine<<endl;
            return this;
    }
    string getNextLabel() { return nextLabel; }
    ParserNode *setNextLabel(string label)
    {
        this->nextLabel = label;
        
            // cout<<"setNextLabel to "<<this->nextLabel<<" for "<<this->getRule()<<" at line "<<firstLine<<endl;
            return this;
    }
    int getFirstLine() { return firstLine; }
    int getLastLine() { return lastLine; }
    ParserNode *setErrorFlag()
    {
        isError = true;
        return this;
    }
    bool isErrorFlag()
    {
        return isError;
    }
    ParserNode *addSubordinate(ParserNode *child)
    {
        isNonTerminal = true;
        subordinates.push_back(child);
        isError = child->isErrorFlag() | isError;
        isErrRootPrinted = child->isErrorPrinted() | isErrRootPrinted;

        return this;
    }
    bool isErrorPrinted()
    {
        return isErrRootPrinted;
    }
    void print(ofstream &out, int offset = 0)
    {
        for (int i = 0; i < offset; i++)
        {
            out << " ";
        }
        if (!isNonTerminal)
        {
            out << matchedRule << " \t"
                << "<Line: " << firstLine << ">\n";
            return;
        }
        out << matchedRule << " \t"
            << "<Line: " << firstLine << "-" << lastLine << ">(" << trueLabel << "," << falseLabel << "," << nextLabel << ")\n";
        if (subordinates.size() == 0)
        {
            return;
        }

        for (int i = 0; i < subordinates.size(); i++)
        {
            ParserNode *p = subordinates[i];
            p->print(out, offset + 1);
        }
    }

    void print(int offset = 0)
    {
        for (int i = 0; i < offset; i++)
        {
            cout << " ";
        }
        if (!isNonTerminal)
        {
            cout << matchedRule << " \t"
                 << "<Line: " << firstLine << ">\n";
            return;
        }
        cout << matchedRule << " \t"
             << "<Line: " << firstLine << "-" << lastLine << ">(" << trueLabel << "," << falseLabel << "," << nextLabel << ")\n";
        if (subordinates.size() == 0)
        {
            return;
        }

        for (int i = 0; i < subordinates.size(); i++)
        {
            ParserNode *p = subordinates[i];
            p->print(offset + 1);
        }
    }

    void setDataType(string dataType)
    {
        this->dataType = dataType;
    }
    string getDataType()
    {
        return this->dataType;
    }
    // int getFirstLine(){return this->firstLine;}
    void setValue(string val) { value = val; }
    string getValue() { return this->value; }

    vector<ParserNode *> getSubordinate() { return this->subordinates; }
    ParserNode *setSubordinate(vector<ParserNode *> &children)
    {
        for (int i = 0; i < children.size(); i++)
        {
            subordinates[i] = children[i];
        }

        return this;
    }

    string getRule() { return this->matchedRule; }

    ParserNode *addDeclarations(SymbolInfo *declarations)
    {
        this->declarations.push_back(declarations);
        return this;
    }

    vector<SymbolInfo *> getDeclarations()
    {
        return this->declarations;
    }
    ParserNode *setGlobal(bool global)
    {
        this->isGlobal = global;
        return this;
    }

    bool isGlobalScope() { return this->isGlobal; }

    ParserNode *setSymbolInfo(SymbolInfo *info)
    {
        this->symbolInfo = info;
        return this;
    }
    SymbolInfo *getSymbolInfo() { return this->symbolInfo; }

    virtual void processCode(ofstream &asmOut)
    {
        // cout<<"Processing "<<this->getRule()<<"..."<<endl;
        copyLabelsToChild(1);
        for (auto x : this->getSubordinate())
        {
            // processNode(x);
            x->processCode(asmOut);
        }
    }
    ParserNode *getSubordinateNth(int n)
    {
        if (n > subordinates.size())
            return nullptr;
        else
            return subordinates[n - 1];
    }

    virtual string getOperator()
    {
        return op;
    }
    virtual ParserNode *setOperator(string s)
    {
        this->op = s;
        return this;
    }
    ParserNode *replaceSubordinate(int n, ParserNode *sub)
    {
        if (n > subordinates.size())
            return this;
        subordinates[n - 1] = sub;
        return this;
    }

    ParserNode *copyLabelsToChild(int n)
    {
        if (n > subordinates.size())
            return this;
        subordinates[n - 1]->setTrueLabel(trueLabel);
        subordinates[n - 1]->setFalseLabel(falseLabel);
        subordinates[n - 1]->setNextLabel(nextLabel);
        return this;
    }
    ParserNode *copyOppositeLabelsToChild(int n)
    {
        if (n > subordinates.size())
            return this;
        subordinates[n - 1]->setTrueLabel(falseLabel);
        subordinates[n - 1]->setFalseLabel(trueLabel);
        subordinates[n - 1]->setNextLabel(nextLabel);
        return this;
    }
    ParserNode *copyNextLabelsToChild(int n)
    {
        if (n > subordinates.size())
            return this;

        subordinates[n - 1]->setNextLabel(nextLabel);
        return this;
    }
    ParserNode *copyBooleanLabelsToChild(int n)
    {
        if (n > subordinates.size())
            return this;
        subordinates[n - 1]->setTrueLabel(falseLabel);
        subordinates[n - 1]->setFalseLabel(trueLabel);

        return this;
    }

    ParserNode *setLabelsToChild(int n,string t,string f,string nl){
            if (n > subordinates.size())
            return this;
            if(!t.empty())
            subordinates[n - 1]->setTrueLabel(t);
            if(!f.empty())
            subordinates[n - 1]->setFalseLabel(f);
            if(!nl.empty())
            subordinates[n - 1]->setNextLabel(nl);
            return this;

    }

};