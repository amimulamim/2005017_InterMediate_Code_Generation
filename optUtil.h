#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <sstream>

using namespace std;


vector<string> validJumpOperations = {
    "JMP",
    "JE",
    "JNE",
    "JZ",
    "JNZ",
    "JS",
    "JNS",
    "JO",
    "JNO",
    "JB",
    "JNB",
    "JBE",
    "JA",
    "JAE",
    "JL",
    "JLE",
    "JG",
    "JGE"
};

vector<string> validRegisters = {
"AX","BX","CX","DX","BP","SP","SI","DI"
};

bool isValidRegister(const string& str){
    return find(validRegisters.begin(), validRegisters.end(), str) != validRegisters.end();
}


bool isValidJumpOperation(const string& str) {

    return find(validJumpOperations.begin(), validJumpOperations.end(), str) != validJumpOperations.end();
}



void printLine(string &processedLine, ofstream &outputFile)
{
    if (processedLine[0] != '.' && processedLine.find("PROC") == string::npos && processedLine.find(":") == string::npos && processedLine[0]!=';')
    {
        outputFile << "\t";
    }
    outputFile << processedLine << endl;
}

string trim(const string &str)
{
    size_t start = str.find_first_not_of(" \t\n\r\f\v");

    if (start == string::npos)
    {
        return "";
    }
    size_t end = str.find_last_not_of(" \t\n\r\f\v");

    string trimmed = str.substr(start, end - start + 1);

    bool inWhitespace = false;
    string ret = "";
    for (char c : trimmed)
    {
        if (isspace(c))
        {
            if (!inWhitespace)
            {
                ret.push_back(' ');
                inWhitespace = true;
            }
        }
        else
        {
            ret.push_back(c);
            inWhitespace = false;
        }
    }

    return ret;
}


string filterComment(const string& line) {
    
    size_t commentPos = line.find(';');

   
    if (commentPos != string::npos) {
        return line.substr(0, commentPos);
    }

   
    return line;
}

vector<string> tokenizeAndFilter(const string& line) {
    vector<string> tokens;
    stringstream ss(line);
    string token;

    while (ss >> token) { 

        token = filterComment(token);

        istringstream tokenStream(token);
        string intermediateToken;
        while (getline(tokenStream, intermediateToken, ',')) {
            
            if (!intermediateToken.empty()) {
                tokens.push_back(trim(intermediateToken));
            }
        }
    }

    return tokens;
}

//retrun value is the number of lines to be removed.
//If "MOV a,AX\
    MOV AX,a" then  The first line should exist as we can read a later

int checkRedundantMoves(string& line1, string& line2){
    vector<string> t1=tokenizeAndFilter(line1);
    vector<string> t2=tokenizeAndFilter(line2);

    if(t1.size()!=3 || t2.size()!=3 ||   t1[0]!="MOV" || t2[0]!="MOV")return 0;

    if(t1[1]==t2[2] && t1[2]==t2[1]){
        if(isValidRegister(t1[1]))return 2;
        else return 1;

    }
    return 0;

}

bool isRedundantPushPop(string& line1, string& line2){
        vector<string> t1=tokenizeAndFilter(line1);
    vector<string> t2=tokenizeAndFilter(line2);

    if(t1.size()!=2 || t2.size()!=2 ||   t1[0]!="PUSH" || t2[0]!="POP")return false;

    if(t1[1]==t2[1])return true;
    return false;

}

bool isValidThreeOperation(const string& str) {

    static const vector<string> validOperations = {"ADD", "SUB", "OR"};

    return find(validOperations.begin(), validOperations.end(), str) != validOperations.end();
}

bool isValidMulopOperation(const string& str) {
    static const vector<string> validOperations = {"MUL", "DIV", "IMUL","IDIV"};
    
    return find(validOperations.begin(), validOperations.end(), str) != validOperations.end();
}

bool checkRedundantOperations(string& line1){
    vector<string> t1=tokenizeAndFilter(line1);

    if(t1.size()==3){
        if(isValidThreeOperation(t1[0]) && (t1[2]=="0" || t1[2]=="0x0" || t1[2]=="0X0"))return true; 
    }
    if(t1.size()==2){
        if(isValidMulopOperation(t1[0]) && (t1[1]=="1" || t1[1]=="0X1"))return true;
    }


    return false;

}

string getSubstringUpToColon(const string& s,bool &isLabel) {

    size_t colonPos = s.find(':');


    if (colonPos != string::npos) {
        isLabel=true;
        return s.substr(0, colonPos);
    }

    isLabel=false;
    return s;
}


bool redundantGotos(string& line1,string& line2){
        vector<string> t1=tokenizeAndFilter(line1);
    vector<string> t2=tokenizeAndFilter(line2);

    if(t1.size()!=2)return false;

    if(!isValidJumpOperation(t1[0]))return false;

    string label1=t1[1];
    bool isLabel=false;
    string label2=getSubstringUpToColon(t2[0],isLabel);

    if(!isLabel)return false;

    if(label1==label2)return true;

    return false;

    


}


int findNextNonCommentLineIndex(const vector<string> &lines, int startIndex)
{
    
    if (startIndex < 0 || startIndex >= lines.size() - 1)
        return -1;

    for (int i = startIndex + 1; i < lines.size(); ++i)
    {
        
        if (i >= 0 && i < lines.size())
        {
            if (!lines[i].empty() && lines[i][0] != ';')
            {
                return i; 
            }
        }
        else
        {
            return -1; 
        }
    }
    return -1; 
}



int findSubstring(const string &str, const string &substr, size_t pos = 0)
{
    size_t found = str.find(substr, pos);
    if (found != string::npos)
    {
        return static_cast<int>(found); 
    }
    else
    {
        return -1;
    }
}


string removeCommentAndTrim(const string &line)
{
    
    size_t commentPos = line.find(';');

    
    string processedLine = line; 

    // Trim leading and trailing spaces
    processedLine.erase(processedLine.begin(), find_if(processedLine.begin(), processedLine.end(), [](unsigned char ch)
                                                            { return !isspace(ch); }));
    processedLine.erase(find_if(processedLine.rbegin(), processedLine.rend(), [](unsigned char ch)
                                     { return !isspace(ch); })
                            .base(),
                        processedLine.end());

    return processedLine;
}

int optimizeCode(const string& codeFile,const string& OptCodeFile)
{
    
    ifstream inputFile(codeFile);
    if (!inputFile)
    {
        cerr << "Error: Unable to open input file." << endl;
        return 1;
    }

    
    vector<string> processedLines;

    
    string line;
    while (getline(inputFile, line))
    {
        
        string processedLine = removeCommentAndTrim(line);

        
        if (!processedLine.empty())
        {
            processedLines.push_back(processedLine);
        }
    }

    
    inputFile.close();

    
    ofstream outputFile(OptCodeFile);
    if (!outputFile)
    {
        cerr << "Error: Unable to open output file." << endl;
        return 1;
    }



    vector<bool> toBePrinted(processedLines.size(), true);

    for (int i = 0; i < processedLines.size(); i++)
    {

        string processedLine = processedLines[i];

        if (!toBePrinted[i])
            continue;


        if(checkRedundantOperations(processedLine)){
            toBePrinted[i] = false;
            continue;
        }    

        int next = findNextNonCommentLineIndex(processedLines, i);



        if(next>=0){
            string nextLine = processedLines[next];
            int checkMove=checkRedundantMoves(processedLine,nextLine);
 
            if(isRedundantPushPop(processedLine, nextLine)){
                toBePrinted[i]=false;
                toBePrinted[next]=false;
            }
            else if(checkMove==2){
                //mov ax,a mov a,ax case
                toBePrinted[i]=false;
                toBePrinted[next]=false;
            }
            else if(checkMove==1){
                //mov a,ax  mov ax,a  case
                toBePrinted[next]=false;
            }
            else if(redundantGotos(processedLine,nextLine)){ 

                toBePrinted[i]=false;
                //toBePrinted[next]=false;  //the label may be referred by someone else

            }
            


        }
        
    }

    for(int i=0; i<toBePrinted.size(); i++){
        if(toBePrinted[i]){
            printLine(processedLines[i],outputFile);
        }

    }
  
outputFile.close();

cout << "Output written to OptimzedFile" << endl;

return 0;

}


