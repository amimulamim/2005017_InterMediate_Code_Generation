#pragma once
#include <iostream>
#include <cstdlib>
#include <fstream>
#include <cstring>
#include <cmath>
#include <vector>
#include <map>
#include <stack>
#include <stack>
#include "SymbolTable/SymbolTable.h"
#include "ParseTree.h"
#include "optUtil.h"

#define CODE_FILE_NAME "code.asm"
#define OPT_CODE_FILE_NAME "optimized_code.asm"

// bool conditionality = false;
//  bool returned = false;
ofstream asmOut;
int stack_offset = 0;
int label = 0;
vector<map<string, int>> offsetmap;
stack<string> exitLabel;
bool notFlag = false;
// bool needed = false;
// int stack_excess = 0;

void printDebug(ParserNode *p, bool c, bool ne)
{
    asmOut << ";" << p->getRule() << " " << p->getFirstLine() << " f: " << c << "," << ne << endl;
}
void printOffsetMap()
{
    for (int i = 0; i < offsetmap.size(); i++)
    {
        for (auto x : offsetmap[i])
        {
            // cout << "(" << x.first << ", " << x.second << ")"
            //<< "  ";
        }
        // cout << endl;
    }
}

bool isPrinterCalled = false;

string newLineProc()
{
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
string printlnProc()
{
    string assemblyCode = R"(println proc  ;print what is in ax
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
    if (offsetmap.empty())
    {
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
        auto it = mp.find(vname);
        if (it != mp.end())
        {
            // //cout<<"returning "<<it->second<<" for "<<vname<<endl;
            return it->second;
        }
        idx--;
    }
    return -1;
}

string getVarAddressName(string vname)
{
    int offset = getVariableOffset(vname);
    if (offset == -1)
        return vname;
    return "[BP" + (offset ? ((offset > 0 ? "-" : "+") + to_string(abs(offset))) : "") + "]";
}

void PrintNewLabel()
{
    asmOut << "Label" << label++ << " : " << endl;
}

string getNewLabel()
{
    string lab = "L" + to_string(label);
    label++;
    return lab;
}

void printLabel(string label, ofstream &out = asmOut)
{
    if (label == "fall")
        return;
    out << label << ":\n";
}

void genCode(std::string s, bool tab = true)
{
    if (tab)
        asmOut << "\t";
    asmOut << s << endl;
}

void push(std::string reg, std::string comment = "")
{
    asmOut << "\t"
           << "PUSH " << reg;
    if (comment.length() > 0)
    {
        // cout << " ; " << comment;
    }
    // stack_excess++;

    asmOut << endl;
}

void push(int val, std::string comment = "")
{
    asmOut << "\t"
           << "PUSH " << val;
    if (comment.length() > 0)
    {
        asmOut << " ; " << comment;
    }
    asmOut << endl;
    // stack_excess++;
}

void pop(std::string reg, std::string comment = "")
{
    asmOut << "\t"
           << "POP " << reg;
    if (comment.length() > 0)
    {
        asmOut << "; " << comment;
    }

    asmOut << endl;
    // stack_excess--;
}

void genStartCode(ParserNode *node, SymbolTable *table)
{
    asmOut.open(CODE_FILE_NAME);
    string c = ".MODEL SMALL\n\
.STACK 1000H\n\
.Data\n\
\tnumber DB \"00000$\"";
    asmOut << c << endl;

    bool conditionality = false;
    bool needed = false;

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

    node->processCode(asmOut, conditionality, needed);

    if (isPrinterCalled)
    {
        string libStart = R"(
;-------------------------------
;         print library         
;-------------------------------
)";
        asmOut << libStart << endl;
        asmOut << newLineProc() << endl;
        asmOut << printlnProc() << endl;
        asmOut << ";--------------------------------\n";
    }
    asmOut << "END main\n";
    asmOut.close();
    offsetmap.clear();
    optimizeCode(CODE_FILE_NAME, OPT_CODE_FILE_NAME);
}

///////////////////////////////////////////////

class var_declaration : public ParserNode
{
public:
    var_declaration(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &asmOut, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        for (auto x : this->getSubordinate())
        {
            x->processCode(asmOut, conditionality, needed);
        }

        if (this->isGlobalScope() == false)
        {

            for (SymbolInfo *si : this->getDeclarations())
            {

                asmOut << "\tSUB SP," << si->getWidth() << endl;
                stack_offset += si->getWidth();
                // //cout<<"before mapping \n";
                addToOffsetMap(si->getName(), stack_offset);
                // //cout<<"after mapping \n";
            }
        }
    }
};

/// @func_definition ///////////////////////////////////////

class func_definition : public ParserNode
{
    vector<SymbolInfo *> params;
    void genFunctioninitCode()
    {
        string func_name = this->getValue();
        genCode(func_name + " PROC", false);
        // asmOut<<func_name<<" PROC"<<endl;
        if (func_name == "main")
        {
            genCode("MOV AX, @DATA");
            genCode("MOV DS, AX");
        }
        genCode("PUSH BP");
        genCode("MOV BP, SP");

        //////////////////
        //////////////////////change after compound_statement,then exclude it
        offsetmap.push_back(map<string, int>());

        // //cout << "si = " << *(this->getSymbolInfo()) << endl;
        params = this->getSymbolInfo()->getParameters();
        // //cout << "params: " << params.size() << endl;
        int offx = -4;
        ///////////////////////////params upore thake,caller push kore..so -(-) e + hobe
        for (int i = params.size() - 1; i >= 0; i--)
        {
            string parName = params[i]->getName();
            // //cout<<"adding to offset map : "<<parName<<" "<<offx<<" from "<<func_name<<endl;
            addToOffsetMap(parName, offx);
            // //cout<<"offx for "<<parName<<" is "<<offx<<endl;
            offx -= 2;
        }
    }
    void funcCompleted()
    {
        string func_name = this->getValue();

        printLabel(getNewLabel());

        // if (stack_offset > 0)
        // {
        //     genCode("ADD SP, " + to_string(stack_offset));
        // }
        genCode("MOV SP,BP");
        genCode("POP BP");

        if (func_name == "main")
        {
            genCode("MOV AX, 4CH");
            genCode("INT 21H");
        }

        else
        {

            if (params.size() != 0)
                genCode("RET " + to_string(params.size() * 2));
            else
                genCode("RET");
            // genCode("RET");
        }
        genCode(func_name + " ENDP\n\n");

        // if(stack_offset > 0){
        //   //cout<<"popping for "<<func_name<<endl;
        offsetmap.pop_back();

        // }
        stack_offset = 0;
    }

public:
    func_definition(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
        // parameterCount = 0;
    }
    void processCode(ofstream &asmOut, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        genFunctioninitCode();
        for (auto x : this->getSubordinate())
        {
            x->processCode(asmOut, conditionality, needed);
        }

        funcCompleted();
    }
};

class variable : public ParserNode
{

    void varHandler(ofstream &out)
    {

        SymbolInfo *si = this->getSymbolInfo();
        // //cout<<"-------------------------------- variable: "<<*si<<endl;
        if (si->isArray())
        {
            if (getVariableOffset(si->getName()) == -1)
            {
                pop("CX"); // getting index
                genCode("LEA SI," + si->getName());
                genCode("SHL CX,1");
                genCode("ADD SI,CX");
                // genCode("MOV AX,[SI]");
            }
            else
            {
                pop("CX"); // getting index
                genCode("SHL CX,1");
                genCode("ADD CX," + to_string(getVariableOffset(si->getName())));
                genCode("MOV DI,BP");
                genCode("SUB DI,CX");
                // genCode("MOV AX,[DI]");
            }
        }
        else
        {
            // genCode("MOV AX,"+getVarAddressName(si->getName()));
        }

        // push("AX");
    }

public:
    variable(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }
        varHandler(out);
    }
};

class factor : public ParserNode
{
public:
    factor(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
};

class var_incDec : public factor
{
public:
    string op;
    var_incDec(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : factor(firstLine, lastLine, matchedRule, dataType, value)
    {
        op = "INC";
        // //cout<<"varINCDEC construction\n";
    }
    var_incDec *setOperator(string op)
    {
        // //cout<<"setOperator = "<<op<<endl;
        if (op == "--")
        {
            this->op = "DEC";
        }
        else
            this->op = "INC";
        // //cout<<"setOperator done\n";
        return this;
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyLabelsToChild(1);
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }

        ParserNode *node = getSubordinateNth(1);
        SymbolInfo *sym = node->getSymbolInfo();

        // //cout<<"operator is : "<<op<<" at line = "<<this->getFirstLine()<<endl;

        if (!sym->isArray())
        {
            string address = getVarAddressName(sym->getName());
            genCode("MOV AX, " + address);
            // genCode("PUSH AX");
            // genCode("PUSH AX");
            push("AX");
            genCode(op + " W." + address);
        }
        else
        {
            int offset = getVariableOffset(sym->getName());

            if (offset == -1)
            {

                genCode("MOV AX, [SI]");
                push("AX");
                push("AX");
                genCode(op + " W.[SI]");
            }
            else
            {
                // element of some local array, index is in CX

                genCode("MOV AX, [DI]");
                push("AX");
                push("AX");
                genCode(op + " W.[DI]");
            }
        }
    }
};
class variable_factor : public factor
{
public:
    variable_factor(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : factor(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyLabelsToChild(1);
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }

        ParserNode *var = this->getSubordinateNth(1);
        SymbolInfo *si = var->getSymbolInfo();
        // //cout<<"-------------------------------- variable_factor: "<<*si<<endl;
        if (si->isArray())
        {
            if (getVariableOffset(si->getName()) == -1)
            {

                genCode("MOV AX,[SI]");
            }
            else
            {

                genCode("MOV AX,[DI]");
            }
        }
        else
        {
            genCode("MOV AX," + getVarAddressName(si->getName()));
        }

        push("AX");
    }
};
class int_factor : public factor
{
public:
    int_factor(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : factor(firstLine, lastLine, matchedRule, dataType, value)
    {
        // //cout<<"int_factor constructor\n";
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        copyLabelsToChild(1);
        // ParserNode* var=this->getSubordinateNth(1);
        // printDebug(this, conditionality, needed);
        SymbolInfo *si = this->getSymbolInfo();
        // //cout<<" constant "<<*si<<endl;
        out << "\tMOV AX, " << si->getName() << endl;
        push("AX");
    }
};

class lpExprRp : public factor
{
public:
    lpExprRp(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : factor(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        this->copyLabelsToChild(2);
        bool neededBefore = needed;
        //    needed=false;

        // //out<<";----------------------------------------------------------------setting needed false for factor:lp exp rp";

        ParserNode *pn = this->getSubordinateNth(2);
        notFlag = false;
       // out << ";setting notF false from " << getRule() << endl;
        // //cout<<"fact (E)"<<" "<<pn->getTrueLabel()<<" "<<pn->getFalseLabel()<<pn->getNextLabel()<<endl;
        // needed=false;
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }

        // needed=neededBefore;
    }
};
class funcCall_factor : public factor
{
public:
    funcCall_factor(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : factor(firstLine, lastLine, matchedRule, dataType, value)
    {
        //////cout<<"funcCall_factor constructor------------------------------\n"<<endl;
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        //////cout<<"funcCall_factor processCode ----------------------------------------------------------------\n"<<endl;
        // printDebug(this, conditionality, needed);
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, false, needed);
        }
        string name = this->getSymbolInfo()->getName();

        genCode("CALL " + name);
        string retType = this->getSymbolInfo()->getVarType();

        push("AX"); // return value
    }
};

class unary_expression : public ParserNode
{
public:
    unary_expression(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
};

class addop_unary : public unary_expression
{
public:
    addop_unary(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : unary_expression(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyLabelsToChild(2);
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }

        if (this->getOperator() == "-")
        {
            pop("AX");
            genCode("NEG AX");
            push("AX");
        }
    }
};

class not_unary : public unary_expression
{
public:
    not_unary(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : unary_expression(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);

        this->copyOppositeLabelsToChild(2);
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }

        if (this->getTrueLabel() == "")
        {
            this->setTrueLabel(getNewLabel());
        }
        if (this->getFalseLabel() == "")
        {
            this->setFalseLabel(getNewLabel());
        }
        // pop("AX");
        string label1 = getFalseLabel();
        string label2 = getTrueLabel();

        if (!conditionality)
        {
            //out << ";no conditionality on not unary operator\n";
            pop("AX");
            genCode("CMP AX, 0");
            if (label1 != "fall")
                genCode("JNE " + label1);
            push(1);
            if (label2 != "fall")
                genCode("JMP " + label2);
            if (label1 != "fall")
                genCode(label1 + ":", false);
            push(0);
            if (label2 != "fall")
                genCode(label2 + ":", false);
        }
        else
        {
            notFlag = true;
           // out << ";setting NOT TRUE FROM NOT UNARY\n";
            // if (label1 != "fall")
            //     genCode("JNE " + label1);
            // if (label2 != "fall")
            //     genCode("JE " + label2);
        }
    }
};

// class factor_unary: public unary_expression{

// };
class term : public ParserNode
{
public:
    term(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
};

class term_mulop_unary : public term
{
public:
    term_mulop_unary(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : term(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyLabelsToChild(1);
        copyLabelsToChild(3);
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }
        pop("BX");
        pop("AX");
        if (this->getOperator() == "*")
        {
            genCode("IMUL BX");
        }
        else
        {
            genCode("CWD");
            genCode("IDIV BX");
            if (this->getOperator() == "%")
            {
                genCode("MOV AX, DX");
            }
        }
        push("AX");
    }
};
class simple_expr : public ParserNode
{
public:
    simple_expr(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
};
class simple_expr_addop_term : public simple_expr
{

public:
    simple_expr_addop_term(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : simple_expr(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyLabelsToChild(1);
        copyLabelsToChild(3);

        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }
        pop("BX");
        pop("AX");
        if (this->getOperator() == "+")
        {
            genCode("ADD AX,BX");
        }
        else
        {
            genCode("SUB AX,BX");
        }
        push("AX");
    }
};

class expression : public ParserNode
{
public:
    expression(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
};

class var_assignop_logic : public expression
{
    void assignHandler(ofstream &out)
    {
        pop("AX");
        SymbolInfo *si = this->getSubordinateNth(1)->getSymbolInfo();
        // //cout<<"-------------------------------- variable assignop : "<<*si<<endl;
        if (si->isArray())
        {
            if (getVariableOffset(si->getName()) == -1)
            {
                genCode("MOV [SI], AX");
            }
            else
            {
                genCode("MOV [DI], AX");
            }
        }
        else
        {
            genCode("MOV " + getVarAddressName(si->getName()) + ",AX");
        }
        push("AX");
        ////////////////////////////////////////////////////push("AX");
    }

public:
    var_assignop_logic(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : expression(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyLabelsToChild(3);
        copyLabelsToChild(1);

        for (int i = this->getSubordinate().size(); i > 0; i--)
        {
            ParserNode *x = getSubordinateNth(i);
            x->processCode(out, false, needed);
        }

        assignHandler(out);



        //handling case like if(a=smth)  or while(x=smth) smth is an logic expression
        //if such cases needed,comment it out
        /*
        if(conditionality){
            pop("AX");
            genCode("CMP AX,0");
            string btrue=getTrueLabel();
            string bfalse=getFalseLabel();
            string label1 = btrue;
            string label2 = bfalse;

            if (btrue != "fall" && bfalse != "fall")
            {

                genCode("JNE " + label1);
                genCode("JMP " + label2);
            }
            else if (btrue != "fall")
            {

                genCode("JNE " + label1);
            }
            else if (bfalse != "fall")
            {
                // genCode(""+getFalseJumpInstruction()+" "+bfalse);
                genCode("JE " + label2);
            }
            needed = false;

        }
        */
    }
};

class expression_expression_statement : public ParserNode
{
public:
    expression_expression_statement(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyLabelsToChild(1);

        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }
        pop("AX");
    }
};

class statement : public ParserNode
{

public:
    statement(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
};

class printlnCaller : public statement
{
public:
    printlnCaller(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : statement(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }
        // string name=this->getSymbolInfo()->getName();

        isPrinterCalled = true;
        // //cout<<"this is a printer\n"<<endl;
        SymbolInfo *info = this->getSubordinateNth(3)->getSymbolInfo();
        // //cout<<"println info = "<<*info<<endl;
        genCode("MOV AX," + getVarAddressName(info->getName()));
        genCode("CALL println");
    }
};

class rel_expression : public ParserNode
{
public:
    rel_expression(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
};

class simp_relop_simp_relexp : public rel_expression
{

    string getJumpInstruction()
    {

        if (getOperator() == "==")
            return "JE";
        if (getOperator() == "!=")
            return "JNE";
        if (getOperator() == "<")
            return "JL";
        if (getOperator() == ">")
            return "JG";
        if (getOperator() == "<=")
            return "JLE";
        if (getOperator() == ">=")
            return "JGE";
    }
    string getFalseJumpInstruction()
    {
        if (getOperator() == "==")
            return "JNE";
        if (getOperator() == "!=")
            return "JE";
        if (getOperator() == "<")
            return "JGE";
        if (getOperator() == ">")
            return "JLE";
        if (getOperator() == "<=")
            return "JG";
        if (getOperator() == ">=")
            return "JL";
    }

    // string genJump(string label,string ji="JMP"){

    // }
    void relHandler(bool conditionality)
    {


        if (this->getTrueLabel() == "")
        {
            this->setTrueLabel(getNewLabel());
        }
        if (this->getFalseLabel() == "")
        {
            this->setFalseLabel(getNewLabel());
        }

        string btrue = this->getTrueLabel();
        string bfalse = this->getFalseLabel();

        pop("DX");
        pop("AX");
        genCode("CMP AX, DX");

        // cout << "btrue ,bfalse = " << btrue << " " << bfalse << endl;
        // cout << "cond, tC =" << conditionality << " ," << this->getConditionality() << " : " << this->getRule() << " " << this->getFirstLine() << endl;
        if (conditionality)
        {
            string label1 = btrue;
            string label2 = bfalse;

           // genCode(";from relHandler of simp rel simp");

            if (btrue != "fall" && bfalse != "fall")
            {
                // genCode(""+getJumpInstruction()+" "+btrue);
                // genCode("JMP "+bfalse);
                genCode("" + getJumpInstruction() + " " + label1);
                genCode("JMP " + label2);
            }
            else if (btrue != "fall")
            {

                genCode("" + getJumpInstruction() + " " + label1);
            }
            else if (bfalse != "fall")
            {
                // genCode(""+getFalseJumpInstruction()+" "+bfalse);
                genCode("" + getFalseJumpInstruction() + " " + label2);
            }
        }

        
        if (!conditionality)
        {

            string label1 = btrue;
            string label2 = bfalse;
            // genCode("POP DX");
            // genCode("POP AX");
            // genCode("CMP AX, DX");
            if (label1 != "fall")
                genCode("" + getJumpInstruction() + " " + label1);
            // genCode("PUSH 0");
            push(0);
            if (label2 != "fall")
                genCode("JMP " + label2);
            if (label1 != "fall")
                genCode(label1 + ":", false);
            push(1);
            if (label2 != "fall")
                genCode(label2 + ":", false);

            // printLabel(btrue);
            // push(1);
            // string nextL=getNewLabel();
            // genCode("JMP "+nextL);
            // printLabel(bfalse);
            // push(0);
            // printLabel(nextL);
        }
        // conditionality = false;
        // cout << "relHandling done" << endl;
        // push("AX");
    }

public:
    simp_relop_simp_relexp(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : rel_expression(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyNextLabelsToChild(1);
        copyNextLabelsToChild(3);

 
        needed = false;
        // //out<<";needed being turned off by "<<getRule()<<endl;
        for (auto x : this->getSubordinate())
        {

            needed = false;
            // //out<<";needed being turned off by "<<getRule()<<endl;
            x->processCode(out, conditionality, needed);
            // needed = true;
        }

        relHandler(conditionality);
        // out<<";needed being turned off by " << getRule() << endl;
        needed = false;

        // cout << "exiting relop " << endl;
    }
};

class logic_expression : public ParserNode
{
public:
    logic_expression(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
};

class rel_logic : public logic_expression
{
public:
    rel_logic(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : logic_expression(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyLabelsToChild(1);

        if (conditionality && needed)
        {
            vector<ParserNode *> children = this->getSubordinate();
            int grandchild0 = children[0]->getSubordinateCount();

            if (grandchild0 != 1)
            {
                needed = false;
            }
            else
            {
                needed = true;
                // out<<"; needed turned on by "<<this->getRule()<<endl;
            }
            // needed = true;
        }
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }

        if (conditionality && needed)
        {

            string btrue = this->getTrueLabel();
            string bfalse = this->getFalseLabel();

            if (notFlag)
            {
                string temp = btrue;
                btrue = bfalse;
                bfalse = temp;
                //out << ";flipping booleans" << endl;
            }


            pop("AX");
            genCode("CMP AX, 0");
            string label1 = btrue;
            string label2 = bfalse;

            if (btrue != "fall" && bfalse != "fall")
            {

                genCode("JNE " + label1);
                genCode("JMP " + label2);
            }
            else if (btrue != "fall")
            {

                genCode("JNE " + label1);
            }
            else if (bfalse != "fall")
            {
                // genCode(""+getFalseJumpInstruction()+" "+bfalse);
                genCode("JE " + label2);
            }
            needed = false;
            // out<<"; needed being turned off by 1182" << getRule() << endl;
        }

       
    }
};
class rel_logicop_rel : public logic_expression
{
    vector<ParserNode *> children;

    void actionNeeded(string btrue, string bfalse, bool &needed)
    {

       // genCode(";from rel_logicop_rel action\n");
        pop("AX");
        genCode("CMP AX, 0");
        string label1 = btrue;
        string label2 = bfalse;

        if (btrue != "fall" && bfalse != "fall")
        {

            genCode("JNE " + label1);
            genCode("JMP " + label2);
        }
        else if (btrue != "fall")
        {

            genCode("JNE " + label1);
        }
        else if (bfalse != "fall")
        {
            // genCode(""+getFalseJumpInstruction()+" "+bfalse);
            genCode("JE " + label2);
        }
        needed = false;
        // genCode(";needed being turned off locally");
    }

    void orHandler()
    {

        if (getTrueLabel() != "fall")
        {
            children[0]->setTrueLabel(getTrueLabel());
        }
        else
        {
            children[0]->setTrueLabel(getNewLabel());
        }
        children[0]->setFalseLabel("fall");
        children[2]->setFalseLabel(getFalseLabel());
        children[2]->setTrueLabel(getTrueLabel());

    }

    void andHandler()
    {


        if (getFalseLabel() != "fall")
        {

            children[0]->setFalseLabel(getFalseLabel());
        }
        else
        {
            children[0]->setFalseLabel(getNewLabel());
           // genCode(";set new label to child0 " + children[0]->getFalseLabel());
        }
        children[0]->setTrueLabel("fall");

        children[2]->setFalseLabel(getFalseLabel());
        children[2]->setTrueLabel(getTrueLabel());
    }

    void LabelHandler()
    {

        children = this->getSubordinate();

        if (getOperator() == "||")
        {
            orHandler();
        }
        else if (getOperator() == "&&")
        {
            andHandler();
        }
        children[2]->setNextLabel(getNextLabel());
        children[0]->setNextLabel(getNextLabel());

        this->setSubordinate(children);
    }

    void orCoder()
    {
        // cout << "-------------------------------- orcoding\n"
        //<< endl;
        if (getTrueLabel() == "fall")
        {
            // genCode(";ORcoder--------------------------------");
            genCode(children[0]->getTrueLabel() + ":\n", false);
        }
    }

    void andCoder()
    {
        //genCode(";ANDcoder--------------------------------");
        if (getFalseLabel() == "fall")
        {
            genCode(children[0]->getFalseLabel() + ":\n", false);
        }
    }
    void Coder(bool conditionality)
    {
        if (getOperator() == "&&")
        {
            andCoder();
        }
        if (getOperator() == "||")
        {
            orCoder();
        }
        //  cout << "cond, tC =" << conditionality << " ," << this->getConditionality() << " : " << this->getRule() << " " << this->getFirstLine() << endl;

        if (!conditionality)
        {
            string label1 = this->getTrueLabel();
            string label2 = this->getFalseLabel();
            genCode(label1 + ":", false);
            string newL = getNewLabel();
            // genCode("PUSH 1");
            push(1);
            genCode("JMP " + newL);
            genCode(label2 + ":", false);
            push(0);
            genCode(newL + ":", false);
        }
        // conditionality = false;
    }

public:
    rel_logicop_rel(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : logic_expression(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        bool conditionalitybefore = conditionality;
        if (getTrueLabel() == "")
        {
            setTrueLabel(getNewLabel());
            // //out<<";created new TrueLabel ="<<getTrueLabel()<<"for rel logicop rel\n";
        }
        if (getFalseLabel() == "")
        {
            setFalseLabel(getNewLabel());
            // //out<<";created new FalseLabel ="<<getFalseLabel()<<"for rel logicop rel\n";
        }

        LabelHandler(); // set inherited labels to children

        

        vector<ParserNode *> children = this->getSubordinate();
        int grandchild0 = children[0]->getSubordinateCount();
        int grandchild2 = children[2]->getSubordinateCount();
        // out<<"; gc0,gc2 =" << grandchild0 << "," << grandchild2 << endl;
        bool n1 = needed;
        bool n2 = needed;

        if (grandchild0 != 1)
            n1 = false;
        else
            n1 = true;

        children[0]->processCode(out, true, n1);

        if (n1)
        {

            if (notFlag)
            {
                actionNeeded(children[0]->getFalseLabel(), children[0]->getTrueLabel(), n1);
                //out << ";flipping boolean labels\n";
            }
            else
            {
                actionNeeded(children[0]->getTrueLabel(), children[0]->getFalseLabel(), n1);
            }
            notFlag = false;
            //out << ";not flag always turned of after action\n";
        }

        children[1]->processCode(out, conditionality, needed);

        if (grandchild2 != 1)
            n2 = false;
        else
            n2 = true;

        // out<<";before, n2 =" << n2 << endl;
        children[2]->processCode(out, true, n2);

        // out<<";after, n2 =" << n2 << endl;

        if (n2)
        {
            if (notFlag)
            {
                actionNeeded(children[2]->getFalseLabel(), children[2]->getTrueLabel(), n1);
                //out << ";flipping boolean labels of children 2" << endl;
            }
            else
            {
                actionNeeded(children[2]->getTrueLabel(), children[2]->getFalseLabel(), n2);
            }
            notFlag = false;
            //out << ";not flag always turned of after action\n";
        }
        Coder(conditionality); // extra labels
        needed = false;
        // out<<"; needed off by " << this->getRule() << endl;
    }
};

class compound_statement_statement : public statement
{
public:
    compound_statement_statement(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : statement(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        offsetmap.push_back(map<string, int>());
        copyLabelsToChild(1);

        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }

        offsetmap.pop_back();
    }
};

class compound_statement : public ParserNode
{
public:
    compound_statement(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        string prevNext = getNextLabel();
        if (getNextLabel() == "")
        {
            // cout << "--------------------------------settting new label for compound statement..." << endl;
            this->setNextLabel(getNewLabel());
            // cout << "--------------------------------exitLabel pushing : " << getNextLabel() << endl;
            exitLabel.push(this->getNextLabel());
            // cout << "--------------------------------exitLabel pushing test: " << exitLabel.top() << endl;
        }

        this->copyLabelsToChild(2);

        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }
        if (prevNext == "")
        {
            exitLabel.pop();
            genCode(this->getNextLabel() + ":\n", false);
        }
    }
};

class statements : public ParserNode
{
public:
    statements(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : ParserNode(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
};

class statement_statements : public statements
{

public:
    statement_statements(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : statements(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyLabelsToChild(1);
        out << ";--------------------------------; LINE " << this->getSubordinateNth(1)->getFirstLine() << endl;
        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }
        // out<<getNextLabel()<<" :\n";
    }
};

class statements_statement_statements : public statements
{
public:
    statements_statement_statements(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : statements(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyBooleanLabelsToChild(1);
        copyBooleanLabelsToChild(2);
        copyLabelsToChild(2);

        vector<ParserNode *> children = getSubordinate();
        children[0]->setNextLabel(getNewLabel());
        // //cout<<"set next label for child0 at statements statement "<<children[0]->getNextLabel()<<endl;
        children[1]->setNextLabel(getNextLabel());

        // //cout<<"testing child1 at statements statement ";
        // children[0]->print();
        // children[1]->print();
        setSubordinate(children);

        children[0]->processCode(out, conditionality, needed);

        out << children[0]->getNextLabel() << ":\n";
        out << ";--------------------------------; LINE " << children[1]->getFirstLine() << endl;
        children[1]->processCode(out, conditionality, needed);
    }
};

class if_statement : public statement
{
public:
    if_statement(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : statement(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        this->setLabelsToChild(5, "", "", this->getNextLabel());
        this->setLabelsToChild(3, "fall", this->getNextLabel(), "");
        bool conditionalitybefore = conditionality;

        int i = 0;
        for (auto x : this->getSubordinate())
        {
            if (i == 2)
            {
                // conditionality = true;
                setConditonalityToChild(i + 1, true);

                needed = true;
                x->processCode(out, true, needed);
                // conditionality = conditionalitybefore;
            }

            // cout << x->getRule() << " LINE: " << x->getFirstLine() << x->getTrueLabel() << " " << x->getFalseLabel() << " " << x->getNextLabel() << endl;
            else
                x->processCode(out, conditionality, needed);



            i++;
            // conditionality = false;
        }
        conditionality = conditionalitybefore;
    }
};

class if_else_statement : public statement
{
public:
    if_else_statement(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : statement(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        this->setLabelsToChild(5, "", "", this->getNextLabel());
        this->setLabelsToChild(7, "", "", this->getNextLabel());
        bool conditionalitybefore = conditionality;

        this->setLabelsToChild(3, "fall", getNewLabel(), "");

        string btrue, bfalse;

        int i = 0;
        for (auto x : this->getSubordinate())
        {
            if (i == 2)
            {
                // conditionality = true;
                setConditonalityToChild(i + 1, true);
                btrue = x->getTrueLabel();
                bfalse = x->getFalseLabel();

                needed = true;
                x->processCode(out, true, needed);
            }

            // cout << x->getRule() << " LINE: " << x->getFirstLine() << x->getTrueLabel() << " " << x->getFalseLabel() << " " << x->getNextLabel() << endl;
            else
            {
                x->processCode(out, conditionality, needed);
            }


            if (i == 4)
            {
                genCode("JMP " + x->getNextLabel());
                genCode(bfalse + ":\n", false);
            }

            i++;
            // conditionality = false;
        }
        conditionality = conditionalitybefore;
    }
};

class for_statement : public statement
{
public:
    for_statement(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : statement(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        string loop = getNewLabel();
        string exec = getNewLabel();
        string incdec = getNewLabel();
        bool conditionalitybefore = conditionality;

        setLabelsToChild(4, exec, getNextLabel(), "");
        setLabelsToChild(7, "", "", incdec);
        setLabelsToChild(5, "", "", loop);

        vector<ParserNode *> children = this->getSubordinate();

        children[2]->processCode(out, conditionality, needed);
        out << loop << ":\n";

        // conditionality = true;
        setConditonalityToChild(3 + 1, true);

        needed = true;
        children[3]->processCode(out, true, needed);
        // conditionality = false;

        out << children[3]->getTrueLabel() << ":\n";
        children[6]->processCode(out, conditionality, needed);
        genCode("JMP " + children[6]->getNextLabel());

        out << incdec << ":\n";

        children[4]->processCode(out, conditionality, needed);

        // genCode(";popping for expression from for");
        pop("AX");
        genCode("JMP " + children[4]->getNextLabel());
        conditionality = conditionalitybefore;
    }


};

class while_statement : public statement
{
public:
    while_statement(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : statement(firstLine, lastLine, matchedRule, dataType, value)
    {
    }

    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        string begin = getNewLabel();
        this->setLabelsToChild(5, "", "", begin, true);
        this->setLabelsToChild(3, "fall", this->getNextLabel(), "", true);
        bool conditionalitybefore = conditionality;

        int i = 0;
        printLabel(begin);
        for (auto x : this->getSubordinate())
        {
            if (i == 2)
            {

                needed = true;
                x->processCode(out, true, needed);
                // conditionality = true;
                setConditonalityToChild(i + 1, true);
                // out<<";" << x->getRule() << " LINE: " << x->getFirstLine() << x->getTrueLabel() << " " << x->getFalseLabel() << " " << x->getNextLabel() << endl;
            }
            else
                x->processCode(out, conditionality, needed);



            if (i == 4)
            {
                genCode("JMP " + begin);
            }

            i++;
            // conditionality = false;
        }
        conditionality = conditionalitybefore;
    }
};

class return_statement : public statement
{

public:
    return_statement(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : statement(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);

        for (auto x : this->getSubordinate())
        {
            x->processCode(out, conditionality, needed);
        }
        pop("AX");
        string to_exit = "";
        // cout << "--exit Label size = " << exitLabel.size() << endl;
        if (exitLabel.size() > 0)
        {
            to_exit = exitLabel.top();
            // exitLabel.pop();
            // cout << " assigned to exit to :  " << to_exit << endl;
        }

        // returned=true;
        genCode("JMP " + to_exit);
    }
};

class simp_relexp : public rel_expression
{

    string getJumpInstruction()
    {

        return "JNE";
    }
    string getFalseJumpInstruction()
    {
        return "JE";
    }

    // string genJump(string label,string ji="JMP"){

    // }
    void relHandler(bool conditionality, bool &needed)
    {
        

        if (conditionality && needed)
        {
            genCode(";-------------------------------- simp of rel called--------------------------------\n");
            if (this->getTrueLabel() == "")
            {
                this->setTrueLabel(getNewLabel());
                genCode(";---------------------------simp created TRUE label =" + getTrueLabel() + "\n");
            }
            if (this->getFalseLabel() == "")
            {
                this->setFalseLabel(getNewLabel());
                genCode(";---------------------------simp created false label =" + getFalseLabel() + "\n");
            }

            string btrue = this->getTrueLabel();
            string bfalse = this->getFalseLabel();

            // pop("DX");

            // cout << "btrue ,bfalse = " << btrue << " " << bfalse << endl;
           // genCode(";conditionality of simple exp");
            pop("AX");
            genCode("CMP AX, 0");
            string label1 = btrue;
            string label2 = bfalse;

            if (btrue != "fall" && bfalse != "fall")
            {

                genCode("" + getJumpInstruction() + " " + label1);
                genCode("JMP " + label2);
            }
            else if (btrue != "fall")
            {

                genCode("" + getJumpInstruction() + " " + label1);
            }
            else if (bfalse != "fall")
            {
                // genCode(""+getFalseJumpInstruction()+" "+bfalse);
                genCode("" + getFalseJumpInstruction() + " " + label2);
            }
            // needed = false;
            genCode(";-------------------------------- simp of rel done--------------------------------\n");
        }
        needed = false;

    }

public:
    simp_relexp(int firstLine, int lastLine, string matchedRule, string dataType = "", string value = "")
        : rel_expression(firstLine, lastLine, matchedRule, dataType, value)
    {
    }
    void processCode(ofstream &out, bool conditionality, bool &needed)
    {
        // printDebug(this, conditionality, needed);
        copyLabelsToChild(1);
        // copyNextLabelsToChild(3);

        // //cout << "-------------------------------- simp of rel called--------------------------------" << endl;
        //  //cout << "is conditional = " << conditionality << endl;
        // ////out<<";--------------------------------simp_rel\n";
        // //out<<";needed for simp relexp = " << needed << endl;
        for (auto x : this->getSubordinate())
        {

            x->processCode(out, conditionality, needed);
        }
        relHandler(conditionality, needed);
        // ////out<<";--------------------------------simp of rel done" << endl;
        // cout << "exiting rel: sim" << endl;
    }
};