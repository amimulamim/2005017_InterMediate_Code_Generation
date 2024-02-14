#pragma once
#include <iostream>
#include <cstdlib>
#include <fstream>
#include <cstring>
#include <cmath>
#include <vector>
#include <map>
#include "SymbolTable/SymbolTable.h"
#include "ParseTree.h"

ofstream asmOut;
int stack_offset = 0;
int label = 1;
vector<map<string, int>> offsetmap;

bool isPrinterCalled = false;

string newLineProc(){
        std::string assemblyCode = R"(
new_line proc
    push ax
    push dx
    mov ah,2
    mov dl,0Dh
    int 21h
    mov ah,2
    mov dl,0Ah
    int 21h
    pop dx
    pop ax
    ret
new_line endp
)";
    return assemblyCode;
}
string printlnProc(){
    string assemblyCode =R"(println proc  ;print what is in ax
    push ax
    push bx
    push cx
    push dx
    push si
    lea si,number
    mov bx,10
    add si,4
    cmp ax,0
    jnge negate
    print:
    xor dx,dx
    div bx
    mov [si],dl
    add [si],'0'
    dec si
    cmp ax,0
    jne print
    inc si
    lea dx,si
    mov ah,9
    int 21h
    call new_line
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    negate:
    push ax
    mov ah,2
    mov dl,'-'
    int 21h
    pop ax
    neg ax
    jmp print
    println endp)";
    return assemblyCode;
}

void addToOffsetMap(string v, int offs)
{   
    if (offsetmap.empty()) {
        offsetmap.push_back(map<string, int>());
    }
    int idx = offsetmap.size() - 1;


    offsetmap[idx].insert(make_pair(v, offs));
}

int getVariableOffset(string vname)
{
    int idx = offsetmap.size() - 1;
    while (idx >= 0)
    {
        auto mp = offsetmap[idx];
        auto it=mp.find(vname);
        if(it != mp.end()){
            cout<<"returning "<<it->second<<" for "<<vname<<endl;
            return it->second;
        }
        idx--;
    }
    return -1;
}

string getVarAddressName(string vname){
    int offset = getVariableOffset(vname);
    if(offset == -1)return vname;
     return "[BP" + (offset ? ((offset > 0 ? "-" : "+") + to_string(abs(offset))) : "") + "]";
}

std::string trim(const std::string &str)
{
    size_t start = str.find_first_not_of(" \t\n\r\f\v");

    if (start == std::string::npos)
    {
        return "";
    }
    size_t end = str.find_last_not_of(" \t\n\r\f\v");

    std::string trimmed = str.substr(start, end - start + 1);

    bool inWhitespace = false;
    string ret = "";
    for (char c : trimmed)
    {
        if (std::isspace(c))
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
void PrintNewLabel()
{
    asmOut << "Label" << label++ << " : " << endl;
}

string getNewLabel(){
    string lab= "l"+to_string(label);
    label++;
    return lab;
}

void genCode(std::string s,bool tab=true)
{   
    if(tab)asmOut << "\t";
    asmOut << s << endl;
}

void push(std::string reg,std::string comment=""){
    asmOut << "\t" << "PUSH " << reg ;
    if(comment.length()>0){cout<<" ; " << comment ;}
    
    asmOut<< endl;
}

void push(int val,std::string comment=""){
    asmOut << "\t" << "PUSH " << val;
    if(comment.length()>0){cout<<" ; " << comment ;}
    asmOut<< endl;
}

void pop(std::string reg,std::string comment=""){
    asmOut << "\t" << "POP " << reg ;
    if(comment.length()>0)cout<<" ; " << comment ;
    asmOut<< endl;
}


void genStartCode(ParserNode *node, SymbolTable *table)
{
    asmOut.open("code.asm");
    string c = ".MODEL SMALL\n\
.STACK 1000H\n\
.Data\n\
number DB \"00000$\"";
    asmOut << c << endl;

    for (SymbolInfo *info : table->getSymbols())
    {
        string s = "";
        if (info->getArrayLength() > 0)
        {
            // string s ="abc DW 20 DUP (0000H)
            s = info->getName() + " DW " + to_string(info->getArrayLength()) + " DUP (0000H)";
        }
        else if (!info->isFunction())
        {

            s = info->getName() + " DW 1 DUP (0000H)";
        }
        if (s.length() > 0)
        {
            asmOut << "\t" << s << endl;
        }
    }
    asmOut << ".CODE\n";

    node->processCode(asmOut);
    
    if(isPrinterCalled){
        asmOut <<newLineProc()<<endl;
        asmOut <<printlnProc()<<endl;
    }
    asmOut << "END main\n";
    asmOut.close();
    offsetmap.clear();
}

///////////////////////////////////////////////

class var_declaration : public ParserNode
{
public:
    var_declaration(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &asmOut)
    {
        for (auto x : this->getSubordinate())
        {
            x->processCode(asmOut);
        }

        if (this->isGlobalScope() == false)
        {

            for (SymbolInfo *si : this->getDeclarations())
            {

                asmOut << "\tSUB SP," << si->getWidth() << endl;
                stack_offset += si->getWidth();
                cout<<"before mapping \n";
                addToOffsetMap(si->getName(), stack_offset);
                cout<<"after mapping \n";
            }
        }
    }
};

/// @func_definition ///////////////////////////////////////

class func_definition : public ParserNode
{   
    vector<SymbolInfo*> params;
    void genFunctioninitCode()
    {
        string func_name = this->getValue();
        genCode(func_name + " PROC");
        if (func_name == "main")
        {
            genCode("\tMOV AX, @DATA");
            genCode("\tMOV DS, AX");
        }
        genCode("\tPUSH BP");
        genCode("\tMOV BP, SP");

        //////////////////
        //////////////////////change after compound_statement,then exclude it
        offsetmap.push_back(map<string, int>());

                    cout << "si = " << *(this->getSymbolInfo()) << endl;
            params = this->getSymbolInfo()->getParameters();
            cout << "params: " << params.size() << endl;
            int offx=-4;
            ///////////////////////////params upore thake,caller push kore..so -(-) e + hobe
        for(int i=params.size()-1; i>=0; i--)
{
    string parName=params[i]->getName();
    addToOffsetMap(parName, offx);
    cout<<"offx for "<<parName<<" is "<<offx<<endl;
    offx-=2;



}

    }
    void funcCompleted()
    {
        string func_name = this->getValue();
        PrintNewLabel();
        if (stack_offset > 0)
        {
            genCode("\tADD SP, " + to_string(stack_offset));
        }
        genCode("\tPOP BP");

        if (func_name == "main")
        {
            genCode("\tMOV AX, 4CH");
            genCode("\tINT 21H");
        }

        else
        {
  
    if (params.size() != 0)
                genCode("\tRET " + to_string(params.size() * 2));
            else
                genCode("\tRET");
            // genCode("\tRET");
        }
        genCode(func_name + " ENDP");

        if(stack_offset > 0) offsetmap.pop_back();
        stack_offset = 0;
       
    }

public:
    func_definition(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
        // parameterCount = 0;
    }
    void processCode(ofstream &asmOut)
    {
        genFunctioninitCode();
        for (auto x : this->getSubordinate())
        {
            x->processCode(asmOut);
        }

        funcCompleted();
    }
};

class variable: public ParserNode{

    void varHandler(ofstream& out){

        
        SymbolInfo* si=this->getSymbolInfo();
        cout<<"-------------------------------- variable: "<<*si<<endl;
        if(si->isArray()){
            if(getVariableOffset(si->getName())==-1){
                pop("CX");//getting index
                genCode("LEA SI,"+si->getName());
                genCode("SHL CX,1");
                genCode("ADD SI,CX");
               // genCode("MOV AX,[SI]");


            }
            else{
                pop("CX");//getting index
                genCode("SHL CX,1");
                genCode("ADD CX,"+to_string(getVariableOffset(si->getName())));
                genCode("MOV DI,BP");
                genCode("SUB DI,CX");
                //genCode("MOV AX,[DI]");

            }

        }
        else{
            //genCode("MOV AX,"+getVarAddressName(si->getName()));
        }

       // push("AX");

    }

    public:
        variable(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream& out){

            for(auto x:this->getSubordinate()){
                x->processCode(out);

            }
            varHandler(out);
        
    }
};


class factor: public ParserNode{
     public:
        factor(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
};

class var_incDec: public factor{
        public:
        string op;
        var_incDec(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : factor(firstLine, lastLine, matchedRule, dataType, value)
    {
        op="INC";
        cout<<"varINCDEC construction\n";
    }
    var_incDec* setOperator(string op){
        cout<<"setOperator = "<<op<<endl;
        if(op=="--"){
            this->op="DEC";
        }
        else this->op="INC";
        cout<<"setOperator done\n";
        return this;
    }
    void processCode(ofstream& out){
        for(auto x:this->getSubordinate()){
            x->processCode(out);
        }

        ParserNode* node=getSubordinateNth(1);
        SymbolInfo* sym=node->getSymbolInfo();

        cout<<"operator is : "<<op<<" at line = "<<this->getFirstLine()<<endl;

         if (!sym->isArray()) {
        string address = getVarAddressName(sym->getName());
        genCode("MOV AX, " + address);
        genCode("PUSH AX");
        genCode(op + " W." + address);
    } else {
        int offset=getVariableOffset(sym->getName());
        
        if (offset == -1) {
           
            genCode("MOV AX, [SI]");
            genCode("PUSH AX");
            genCode(op + " W.[SI]");
        } else {
            // element of some local array, index is in CX
           
            genCode("MOV AX, [DI]");
            genCode("PUSH AX");
            genCode(op + " W.[DI]");
        }
    }

    }




};
class variable_factor:public factor{
    public:
         variable_factor(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : factor(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }
    void processCode(ofstream& out){
        for(auto x: this->getSubordinate()){
            x->processCode(out);
        }

    ParserNode* var=this->getSubordinateNth(1);
     SymbolInfo* si=var->getSymbolInfo();
        cout<<"-------------------------------- variable_factor: "<<*si<<endl;
        if(si->isArray()){
            if(getVariableOffset(si->getName())==-1){

                genCode("MOV AX,[SI]");


            }
            else{
              
                genCode("MOV AX,[DI]");

            }

        }
        else{
            genCode("MOV AX,"+getVarAddressName(si->getName()));
        }

        push("AX");
        
    }
    // void processCode(ofstream& out){
    //     ParserNode* var=this->getSubordinateNth(1);
    //     SymbolInfo* si=var->getSymbolInfo();
    //     cout<<"-------------------------------- varFac: "<<*si<<endl;
    //     if(si->isArray()){
    //         if(getVariableOffset(si->getName())==-1){
    //             pop("CX");//getting index
    //             genCode("LEA SI,"+si->getName());
    //             genCode("SHL CX,1");
    //             genCode("ADD SI,CX");
    //             genCode("MOV AX,[SI]");


    //         }
    //         else{
    //             pop("CX");//getting index
    //             genCode("SHL CX,1");
    //             genCode("ADD CX,"+to_string(getVariableOffset(si->getName())));
    //             genCode("MOV DI,BP");
    //             genCode("SUB DI,CX");
    //             genCode("MOV AX,[DI]");

    //         }

    //     }
    //     else{
    //         genCode("MOV AX,"+getVarAddressName(si->getName()));
    //     }

    //     push("AX");
    // }


};
class int_factor : public factor {
        public:
         int_factor(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : factor(firstLine, lastLine, matchedRule, dataType, value)
    {
        cout<<"int_factor constructor\n";
    }
    void processCode(ofstream& out){

        //ParserNode* var=this->getSubordinateNth(1);
        
        SymbolInfo* si=this->getSymbolInfo();
        cout<<" constant "<<*si<<endl;
        out<<"MOV AX,"<<si->getName()<<endl;
        push("AX");
    }
};

class lpExprRp : public factor {
       public:
         lpExprRp(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : factor(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }
    void processCode(ofstream& out){
        ParserNode* sub=this->getSubordinateNth(2);
        sub->setTrueLabel(this->getTrueLabel());
        sub->setFalseLabel(this->getFalseLabel());
        sub->setNextLabel(this->getNextLabel());

        for (auto x : this->getSubordinate())
        {
            x->processCode(out);
        }


    }

};
class funcCall_factor : public factor{
     public:
         funcCall_factor(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : factor(firstLine, lastLine, matchedRule, dataType, value)
    {
        //cout<<"funcCall_factor constructor------------------------------\n"<<endl;
    }
    void processCode(ofstream& out){
        //cout<<"funcCall_factor processCode ----------------------------------------------------------------\n"<<endl;
        for(auto x : this->getSubordinate()){
            x->processCode(out);
        }
        string name=this->getSymbolInfo()->getName();
        cout<<" name="<<name<<endl<<endl;
        if(name=="println"){
            isPrinterCalled=true;
            cout<<"this is a printer\n"<<endl;
            SymbolInfo* info=this->getSubordinateNth(3)->getSymbolInfo();
            cout<<"println info = "<<*info<<endl;
            genCode("MOV AX,"+getVarAddressName(info->getName()));
        

            push("AX");


        }
        genCode("CALL "+name);
        push("AX");//return value pushing
    }

};

class unary_expression : public ParserNode{
       public:
         unary_expression(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }
};

class addop_unary : public unary_expression{
       public:
         addop_unary(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : unary_expression(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }
    void processCode(ofstream& out){
           for(auto x : this->getSubordinate()){
            x->processCode(out);
        }

        if(this->getOperator() =="-"){
            pop("AX");
            genCode("NEG AX");
            push("AX");

        }
    }



};

class not_unary : public unary_expression {
          public:
         not_unary(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : unary_expression(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }
    void processCode(ofstream& out){
           for(auto x : this->getSubordinate()){
            x->processCode(out);
        }

        
           // pop("AX");
            string label1=getNewLabel();
             string label2=getNewLabel();

		genCode("\tPOP AX");
		genCode("\tCMP AX, 0");
		genCode("\tJNE " + label1);
		genCode("\tPUSH 1");
		genCode("\tJMP " + label2);
		genCode(label1 + ":");
		genCode("\tPUSH 0");
		genCode(label2 + ":");


            // genCode("CMP AX,0");
             
            // genCode("JE "+l1);
            // genCode("MOV AX,0");
            
            // genCode("JMP "+l2);
            // out<<l1<<" : ";
            // genCode("MOV AX,1");
            // out<<l2<<" : ";
            // push("AX");







        
    }

};

// class factor_unary: public unary_expression{



// };
class term :public ParserNode{
      public:
         term(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }

  

};

class term_mulop_unary : public term{
    public:
       term_mulop_unary(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : term(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }

    void processCode(ofstream& out){
            for(auto x : this->getSubordinate()){
            x->processCode(out);
        }
        pop("BX");
        pop("AX");
        if(this->getOperator() =="*"){
            genCode("IMUL BX");
        }
        else{
            genCode("CWD");
            genCode("IDIV BX");
            if(this->getOperator()=="%"){
                genCode("MOV AX,DX");
            }
        }
        push("AX");
        
    }

};
class simple_expr :public ParserNode{
      public:
         simple_expr(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }

  

};
class simple_expr_addop_term : public simple_expr{

      public:
       simple_expr_addop_term(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : simple_expr(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }

    void processCode(ofstream& out){
            for(auto x : this->getSubordinate()){
            x->processCode(out);
        }
        pop("BX");
        pop("AX");
        if(this->getOperator() =="+"){
            genCode("ADD AX,BX");
        }
        else{
            genCode("SUB AX,BX");
        }
        push("AX");
    }
        

};

class expression: public ParserNode{
      public:
 expression(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }

};

class var_assignop_logic : public expression {
    void assignHandler(ofstream& out){
        pop("AX");
        SymbolInfo* si=this->getSubordinateNth(1)->getSymbolInfo();
        cout<<"-------------------------------- variable assignop : "<<*si<<endl;
        if(si->isArray()){
            if(getVariableOffset(si->getName())==-1){
                genCode("MOV [SI],AX");
            }
            else{
                genCode("MOV [DI],AX");
            }

        }
        else{
            genCode("MOV "+getVarAddressName(si->getName())+",AX");
        }

        push("AX");
    }


    public:
     var_assignop_logic(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : expression(firstLine, lastLine, matchedRule, dataType, value)
    {
        
    }
    void processCode(ofstream& out){
      

        for(int i=this->getSubordinate().size(); i>0; i--){
            ParserNode* x=getSubordinateNth(i);
            x->processCode(out);

        }

        assignHandler(out);



    }
};