

#include <vector>
#include <string>


using namespace std;
// class FuncDetails
// {
// private:
//     string returnType;
//     string name;
//     vector<string> parameterTypes;
//     bool isDefined;

// public:
//     FuncDetails(/* args */);
//     ~FuncDetails();
// };

// FuncDetails::FuncDetails(/* arg*/)
// {
// }

// FuncDetails::~FuncDetails()
// {
// }


class FuncDetails {
private:
    string returnType;
    string name;
    //vector<SymbolInfo*> parameterTypes;
    bool isDefined;
    int declaredLine,definedLine;

public:
    
    FuncDetails() : isDefined(false) {declaredLine=-1;definedLine=-1;}

    FuncDetails(const string& returnType, const string& name, bool isDefined=false,int decl=-1,int defl=-1)
        : returnType(returnType), name(name), isDefined(isDefined) {declaredLine=decl;definedLine=defl;}

    
    ~FuncDetails() {}

    
     string getReturnType() const {
        return returnType;
    }

    string getName() const {
        return name;
    }



    bool getIsDefined() const {
        return isDefined;
    }

    
    void setReturnType(const string& newReturnType) {
        returnType = newReturnType;
    }

    void setName(const string& newName) {
        name = newName;
    }



    void setIsDefined(bool newIsDefined=true) {
        isDefined = newIsDefined;
    }

    int getDeclaredLine(){
        if(declaredLine==-1)return definedLine;
        return declaredLine;}
    int getDefinedLine(){
        if(definedLine==-1)return declaredLine;
        return definedLine;}
    void setDeclaredLine(int newDeclaredLine) {declaredLine = newDeclaredLine;}
    void setDefinedLine(int newDefinedLine) {definedLine = newDefinedLine;}



    // bool matches(FuncDetails* details){
    //     if(returnType!=details->getReturnType()){return false;}
    //     if(name!=details->getName()){return false;}
    //     if(parameterTypes.size()!=details->getparameters().size()){return false;}
    //     vector<SymbolInfo*> dpam=details->getparameters();
    //     for(int i=0; i<parameterTypes.size();i++){
    //         if(parameterTypes[i]->getVarType()!=dpam[i]->getVarType())return false;
    //     }
    //     return true;

    // }

};
