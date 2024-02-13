#include <string>
using namespace std;
class VariableDetails
{
private:
    string varType;
    int arrayLength;
public:
    VariableDetails(string varType, int arrayLength=-1){
        this->varType = varType;
        this->arrayLength = arrayLength;

    }
    VariableDetails(int arrayLength=-1){
        this->varType="";
        this->arrayLength = arrayLength;
    }
    ~VariableDetails(){};

    string getVarType() const { return varType; }
    int getArrayLength() const { return arrayLength; }

    void setVarType(string varType) { this->varType = varType;}
    void setArrayLength(int arrayLength) { this->arrayLength = arrayLength; }

        int getWidth() const { 
        int x=0;
        if(varType=="INT")x=2;
        else if(varType=="FLOAT")x=4;
        if(arrayLength>0)x*=arrayLength;
        return x;
    }
};



