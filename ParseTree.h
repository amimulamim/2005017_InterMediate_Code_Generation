#include<iostream>
#include<fstream>
#include<string>
#include<vector>

using namespace std;

class ParserNode{
    int firstLine;
    int lastLine;
    string matchedRule;
    string dataType,value;
    vector<ParserNode*> subordinates;
    bool isNonTerminal,isError,isErrRootPrinted;
    vector<SymbolInfo*> declarations;
    bool isGlobal;
    ofstream asmOut;
    SymbolInfo* symbolInfo;
    string trueLabel,falseLabel,nextLabel;

    public:
    ParserNode(int firstLine, int lastLine,string matchedRule,string dataType="",string value=""){
        this->firstLine = firstLine;
        this->lastLine = lastLine;
        this->matchedRule = matchedRule;
        this->dataType = dataType;
        this->value = value;
        vector<ParserNode*> children;
        subordinates=children;
        isNonTerminal=false;
        isErrRootPrinted=false;
        isError=false;
        isGlobal=true;
        symbolInfo=nullptr;
        trueLabel="";
        falseLabel="";
        nextLabel="";
            // size_t found = matchedRule.find("error");
            // isError|= (found != std::string::npos);
    // If found is not equal to std::string::npos, it means "error" was found
    
    }
    ~ParserNode(){
        for(auto p:subordinates){
            delete p;
        }

    }
    string getTrueLabel(){
        return trueLabel;
    }
    ParserNode* setTrueLabel(string label){
        this->trueLabel=label;
    }
    string getFalseLabel(){
        return falseLabel;
    }
    ParserNode* setFalseLabel(string label){
        this->falseLabel=label;
    }
    string getNextLabel(){return nextLabel;}
    ParserNode* setNextLabel(string label){
        this->nextLabel=label;
    }
    int getFirstLine(){return firstLine;}
    int getLastLine(){return lastLine;}
    ParserNode* setErrorFlag(){
        isError=true;
    }
    bool isErrorFlag(){
        return isError;
    }
    ParserNode* addSubordinate(ParserNode* child){
        isNonTerminal=true;
        subordinates.push_back(child);
        isError=child->isErrorFlag()|isError;
        isErrRootPrinted=child->isErrorPrinted()|isErrRootPrinted;

        return this;
    }
    bool isErrorPrinted(){
        return isErrRootPrinted;
    }
    void print(ofstream& out,int offset=0){
        for(int i=0;i<offset;i++){
            out<<" ";
        }
        if(!isNonTerminal){
            out<<matchedRule<<" \t"<<"<Line: "<<firstLine<<">\n";
            return;
        }
        out<<matchedRule<<" \t"<<"<Line: "<<firstLine<<"-"<<lastLine<<">\n";
        if(subordinates.size()==0){return;}
        
        for(int i=0;i<subordinates.size();i++){
            ParserNode* p = subordinates[i];
            p->print(out,offset+1);
        }
        

    }
    void setDataType(string dataType){
        this->dataType = dataType;
    }
    string getDataType(){
        return this->dataType;
    }
   // int getFirstLine(){return this->firstLine;}
    void setValue(string val){value=val;}
    string getValue(){return this->value;}

    vector<ParserNode*> getSubordinate(){return this->subordinates;}


    string getRule(){return this->matchedRule;}

    ParserNode* addDeclarations(SymbolInfo* declarations){
        this->declarations.push_back(declarations);
    }

    vector<SymbolInfo*> getDeclarations(){
        return this->declarations;
    }
    ParserNode* setGlobal(bool global){this->isGlobal=global;}

    bool isGlobalScope() {return this->isGlobal;}

    ParserNode* setSymbolInfo(SymbolInfo* info){this->symbolInfo=info;}
    SymbolInfo* getSymbolInfo(){return this->symbolInfo;}
    
    virtual void processCode(ofstream& asmOut){
        //cout<<"Processing "<<this->getRule()<<"..."<<endl;
         for (auto x : this->getSubordinate())
        {
            //processNode(x);
            x->processCode(asmOut);
        }
    }
    ParserNode* getSubordinateNth(int n){
        if(n>subordinates.size())return nullptr;
        else return subordinates[n-1];
    }

    ParserNode* replaceSubordinate(int n,ParserNode* sub){
        if(n>subordinates.size())return this;
        subordinates[n-1]=sub;
        return this;

    }

};