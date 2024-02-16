%{
#include<iostream>
#include<cstdlib>
#include<fstream>
#include <memory>
#include "Terminal.h"
#include "ICG_util.h"

using namespace std;

typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1

int yyparse(void);
int yylex(void);
extern FILE *yyin;
FILE* fp;

//FILE *log_out, *error_out; 
ofstream logFileOutput,errorFileOutput;
ofstream parsetree_file;
int lastSyntaxError=-1;
string lastSyntaxErrorString="";
SymbolTable *table = new SymbolTable(11);

extern int line_count;
extern int error_count;
int current_line=0;

bool isGlobalScope=true;
int curr_offset=0;

vector<SymbolInfo*> symbols,parameters;
SymbolInfo* funcID=nullptr;
SymbolInfo* endingFunc=nullptr;
vector<string> argumentsList;
vector<SymbolInfo*> save;


void yyerror(char *s){
  //error_count++;
  //errorFileOutput<<"Line# "<<line_count<<": "<<s<<"Unexpected token "<<endl;
  
}
void errorMessage(string s,int line_no=line_count){
   error_count++;
  errorFileOutput<<"Line# "<<line_no<<": "<<s<<endl;
}

void syntaxErrorLog(string s,int line_no){
  if(line_no==lastSyntaxError && s==lastSyntaxErrorString )return;
  error_count++;
  logFileOutput<<"Error at line no "<<line_no<<" : syntax error"<<endl;
  errorFileOutput<<"Line# "<<line_no<<": "<<s<<endl;
  lastSyntaxError=line_no;
  lastSyntaxErrorString=s;
}


void logRule(string rule){
  logFileOutput<<rule<<endl;
}
void logSummary(){
    logFileOutput<<"Total Lines: "<<line_count<<endl;
    logFileOutput<<"Total Errors: "<<error_count<<endl;
}
void setTypeSpecifier(string s){
  for(auto v:symbols){
    v->setVarType(s);
  }
}

bool isRedclaredParam(SymbolInfo *info){
  for(auto v:parameters){
    if(v->getName()==info->getName()){
      string errMsg = "Redefinition of parameter '" + info->getName() + "'";
      errorMessage(errMsg);

       return true;
    }
  }
return false;
}


void insertParamNewScope(){
  table->enterScope();
  if(funcID==nullptr){return;}

  FuncDetails* ff=funcID->getFuncDetails();
  if(ff==nullptr){return;}
    for(auto v:funcID->getParameters()){
      if(v->getName()==""){
        v->setName("NN");
      }
    SymbolInfo *sif=new SymbolInfo(v->getName(),v->getType());
    sif->setVarType(v->getVarType());
    table->insert(sif);

  }
  save.push_back(funcID);
 // cout<<"save e save er try \n";
  endingFunc=funcID;


  return;
}

SymbolInfo* validVariableAdjust(SymbolInfo* info,int line_no){
  string search=info->getName();
  SymbolInfo* find=table->lookUp(search);
  if(find==nullptr){
    errorMessage("Undeclared variable '" + info->getName()+"'",line_no);
    return find;
  }
  info->setVarType(find->getVarType());
  if(find->isArray()){
    errorMessage("'"+info->getName()+ "' is an array",line_no);
    //errorMessage("Type mismatch for argument 1 of 'func'",line_no);
    return find;
  }
  return find;
  
}
bool isArrayCheckingMatching(SymbolInfo* info,bool isArray=false){
  string search=info->getName();
  SymbolInfo* find=table->lookUp(search);
  if((find->isArray() && !isArray)||(!find->isArray() && isArray) ){
    return false;
  }
  return true;

}
SymbolInfo* validArray(SymbolInfo* info,ParserNode* idx,int line_no){
  string search=info->getName();
  SymbolInfo* find=table->lookUp(search);
    if(find==nullptr){
    errorMessage("Undeclared variable '" + info->getName()+"'",line_no);
    return find;
  }
  info->setVarType(find->getVarType());
  if(!find->isArray()){
    errorMessage("'"+info->getName()+ "' is not an array",line_no);
    return find;
  }
  info->setArray(find->getVarType(),find->getArrayLength());
  if(idx->getDataType()!="INT"){
    errorMessage("Array subscript is not an integer",line_no);
  }
  return find;
  }




void setFuncDetails(SymbolInfo *sym,string returnType){

  sym->setFunction(returnType,parameters);
  parameters.clear();

}


bool funcMatching(SymbolInfo *curr,string returnType,vector<SymbolInfo*> ptypes,int line=line_count){
  if(curr==nullptr ) {
    return false;
  }
  if(curr->getFuncDetails()==nullptr)return false;
  FuncDetails* f=curr->getFuncDetails();
  bool ok=true;
  if(f->getReturnType()!=returnType){
    
    errorMessage("Conflicting types for '"+curr->getName()+"'",line);
    ok=false;
    
  }
  vector<SymbolInfo*> pt=curr->getParameters();
  
  if(pt.size()!=ptypes.size()){
    //errorMessage("Parameter count mismatch with function declaration",line);
    errorMessage("Conflicting types for '"+curr->getName()+"'",line);
    ok=false;
  }
  //cout<<"here"<<endl;
  for(int i=0;i<min(ptypes.size(),pt.size());i++){
    //cout<<"param type match :"<<pt[i]->getVarType()<<" "<<ptypes[i]->getVarType()<<endl;
    if(pt[i]->getVarType()!=ptypes[i]->getVarType()){
      ok=false;
      errorMessage("Parameter type mismatch with function declaration ",line);
    }
  }
  //cout<<"here2"<<endl;

  return ok;
}



void checkFunction(SymbolInfo* s,int line,bool isError,bool definition=false){
    //setFuncDetails(s,returnType);
    if(!definition && !isError){
      bool inserted=table->insert(s);
      if(inserted){
      funcID=s;
              SymbolInfo* chk=table->lookUp(s->getName());
        
      return;
      }
      errorMessage("Function '" + s->getName() + "' already declared",line);
      return;
    }
    
   
      s->setDefinedFunction();
      
      for(auto p:s->getParameters()){
        if(p->getName()=="")errorMessage("Unnamed parameter",line);
      }
  
    funcID=s;
    

    SymbolInfo* already=table->lookUp(s->getName());
    

    if(already==nullptr){
      funcID=s;
      return;
    }

    //cout<<"already was before : "<<*already<<endl;

    if(already->isFunction()==false){
      errorMessage("'"+already->getName()+"' redeclared as different kind of symbol",line);
      return;
    }
    if(already->isDefinedFunction()){
      errorMessage("Function '" + s->getName() + "' already defined",line);
      return;
    }

    FuncDetails* det=already->getFuncDetails();
    //cout<<"comp check : "<<already->getName()<<endl;
    bool funcCompatibility=funcMatching(s,det->getReturnType(),already->getParameters());


    if(s->getReturnType()!=det->getReturnType()){
      s->setReturnType(det->getReturnType());
    }
    int dl=already->getDecLine();
    s->setDecLine(dl);
    save.push_back(s);

    already=s;
   // s->details();
    

    funcID=already;
    s=funcID;
    table->replace(already);

}

void funcCallADjust(SymbolInfo* s,int line_no){
  SymbolInfo* news=table->lookUp(s->getName());
  if(news==nullptr){
errorMessage("Undeclared function '" + s->getName() +"'",line_no);
argumentsList.clear();return;
  }
  if(!news->isFunction()){
    errorMessage(s->getName() +" is not a function",line_no);
    argumentsList.clear();return;
  }
  if(!news->isDefinedFunction()){
    errorMessage(s->getName() +" is not defined",line_no);
    argumentsList.clear();
    s->setVarType(news->getReturnType());
    return;
  }
  //vector<SymbolInfo>* args=s->getParameters();
  bool ok=true;
  vector<SymbolInfo*> argb=news->getParameters();

  if(argumentsList.size()>argb.size()){
    errorMessage("Too many arguments to function '"+s->getName()+"'",line_no);
    ok=false;
  }
  else if(argumentsList.size()<argb.size()){
     errorMessage("Too few arguments to function '"+s->getName()+"'",line_no);ok=false;
  }
  else{
  //  cout<<"arg check for "<<s->getName()<<endl;
    for(int i=0;i<min(argb.size(),argumentsList.size());i++){
     // cout<<argumentsList[i]<<" arg check "<<*argb[i]<<" line= "<<line_no<<endl;
      if(argumentsList[i]!=argb[i]->getVarType() && argb[i]->getVarType()!=""){
        ok=false;
        //Type mismatch for argument 2 of 'correct_foo'
        errorMessage("Type mismatch for argument " + std::to_string(i+1) +" of '" + s->getName()+"'" ,line_no);
      }
    }
  }
  if(ok){
    s->setVarType(news->getReturnType());
  }
  argumentsList.clear();
}

string typeCasted(string t1,string t2) {
//cout<<"typeCasting "<<t1<<" , "<<t2<<" line: "<<line_count<<endl;
if(t1==t2){return t1;}

if(t1=="")return t2;
if(t2=="")return t1;
if(t1=="VOID" || t2=="VOID"){
  //errorMessage("Cannot perform operation on void type");
  return "VOID";
}
if((t1=="INT" && t2=="FLOAT")||(t1=="FLOAT" && t2=="INT")){
return "FLOAT";
}


}




// void errorRecovery(string s=""){

//   //yyclearin;
//   //yyerrok;
//   errorFileOutput<<"Line# "<<line_count<<": "<<s<<endl;
// }



ParserNode* parsing( YYLTYPE location, const std::string rule,string datatype="",string value="") {
    return (new ParserNode(location.first_line,location.last_line,rule,datatype,value));

}

func_definition* new_function_definition(YYLTYPE location, const std::string rule,string datatype="",string value=""){
  return (new func_definition(location.first_line,location.last_line,rule,datatype,value));
}

variable* new_variable(YYLTYPE location, const std::string rule,string datatype="",string value=""){
  return (new variable(location.first_line,location.last_line,rule,datatype,value));
}

var_incDec* new_var_incDec(YYLTYPE location, const std::string rule,string datatype="",string value=""){
  return (new var_incDec(location.first_line,location.last_line,rule,datatype,value));
}

variable_factor*  new_variable_factor(YYLTYPE location, const std::string rule,string datatype="",string value=""){
  return (new variable_factor(location.first_line,location.last_line,rule,datatype,value));
}

int_factor*  new_int_factor(YYLTYPE location, const std::string rule,string datatype="",string value=""){
  return (new int_factor(location.first_line,location.last_line,rule,datatype,value));
}

funcCall_factor* new_funcCall_factor(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new funcCall_factor(location.first_line,location.last_line,rule,datatype,value));
}

addop_unary* new_addop_unary(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new addop_unary(location.first_line,location.last_line,rule,datatype,value));
}

not_unary* new_not_unary(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new not_unary(location.first_line,location.last_line,rule,datatype,value));
}

term_mulop_unary*  new_term_mulop_unary(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new term_mulop_unary(location.first_line,location.last_line,rule,datatype,value));
}

simple_expr_addop_term* new_simple_expr_addop_term(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new simple_expr_addop_term(location.first_line,location.last_line,rule,datatype,value));
}

var_assignop_logic* new_var_assignop_logic(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new var_assignop_logic(location.first_line,location.last_line,rule,datatype,value));
}

printlnCaller* new_printlnCaller(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new printlnCaller(location.first_line,location.last_line,rule,datatype,value));
}

simp_relop_simp_relexp*  new_simp_relop_simp_relexp(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new simp_relop_simp_relexp(location.first_line,location.last_line,rule,datatype,value));
}

rel_logic* new_rel_logic(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new rel_logic(location.first_line,location.last_line,rule,datatype,value));
}

rel_logicop_rel* new_rel_logicop_rel(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new rel_logicop_rel(location.first_line,location.last_line,rule,datatype,value));
}

compound_statement* new_compound_statement(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new compound_statement(location.first_line,location.last_line,rule,datatype,value));
}

compound_statement_statement* new_compound_statement_statement(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new compound_statement_statement(location.first_line,location.last_line,rule,datatype,value));
}

statement_statements* new_statement_statements(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new statement_statements(location.first_line,location.last_line,rule,datatype,value));
}

statements_statement_statements* new_statements_statement_statements(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new statements_statement_statements(location.first_line,location.last_line,rule,datatype,value));
}

if_statement* new_if_statement(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new if_statement(location.first_line,location.last_line,rule,datatype,value));
}

if_else_statement* new_if_else_statement(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new if_else_statement(location.first_line,location.last_line,rule,datatype,value));
}

return_statement* new_return_statement(YYLTYPE location, const std::string rule,string datatype="",string value=""){
return (new return_statement(location.first_line,location.last_line,rule,datatype,value));
}

// logic_expression_expression* new_logic_expression_expression(YYLTYPE location, const std::string rule,string datatype="",string value=""){
// return (new logic_expression_expression(location.first_line,location.last_line,rule,datatype,value));
// }


%}

%locations



%union {
  ParserNode* parserNode;
  SymbolInfo* symbolInfo;
}


%token<symbolInfo> IF ELSE FOR WHILE DO BREAK MAIN RETURN SWITCH CASE DEFAULT CONTINUE LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON PRINTLN INCOP DECOP ASSIGNOP NOT
%token<symbolInfo> ID INT FLOAT DOUBLE CONST_INT CONST_FLOAT CHAR VOID ADDOP MULOP RELOP LOGICOP BITOP ERROR_NUM

%type <parserNode> start program unit var_declaration declaration_list type_specifier func_declaration parameter_list func_definition statements statement compound_statement
%type <parserNode>  arguments argument_list factor unary_expression term simple_expression rel_expression logic_expression expression
%type <parserNode> variable expression_statement 

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%start start

%%

start : program
  {
    logRule("start : program");
    logSummary();
    $$ =parsing(@$,"start : program")->addSubordinate($1);
    
    genStartCode($$,table);
    $$->print(parsetree_file);
    delete table;
  }
  
  ;

program : program unit 
  { 
    
    logRule("program : program unit ");
    $$ = parsing(@$,"program : program unit ")->addSubordinate($1)->addSubordinate($2);
  }
  | unit
  {
    logRule("program : unit ");
    $$ = parsing(@$,"program : unit ")->addSubordinate($1);
  }
  ;
  
unit : var_declaration
  {
    logRule("unit : var_declaration  ");
    $$ = parsing(@$,"unit : var_declaration  ")->addSubordinate($1);
  }
  | func_declaration
  {    logRule("unit : func_declaration ");
    $$ = parsing(@$,"unit : func_declaration ")->addSubordinate($1);
  }
  | func_definition{
      logRule("unit : func_definition ");
    $$ = parsing(@$,"unit : func_definition ")->addSubordinate($1);
  }| error{
    $$=parsing(@$,"unit : error ");
    if($$->isErrorFlag()==false)
   {syntaxErrorLog("Syntax error at unit ",@1.first_line);}
   $$->setErrorFlag();
    
    
  }

  
     ;     



var_declaration : type_specifier declaration_list SEMICOLON
     {
      logRule("var_declaration : type_specifier declaration_list SEMICOLON  ");
    
      //$$ = parsing(@$,"var_declaration : type_specifier declaration_list SEMICOLON  ");
      $$=new var_declaration(@$.first_line,@$.last_line,"var_declaration : type_specifier declaration_list SEMICOLON  ");
      $$->addSubordinate($1)->addSubordinate($2)->addSubordinate(parsing(@3,SEMICOLON_R));
      $$->setGlobal(isGlobalScope);
     // cout<<"checking global ="<<isGlobalScope<<" line ="<<@$.first_line<<endl;

      for(auto symb: symbols) {
        symb->setVarType($1->getDataType());
        

        if($1->getDataType()=="VOID"){
          string errMsg = "Variable or field '" + symb->getName() + "' declared void";
         
          errorMessage(errMsg,@$.first_line);
        }
        else{
          curr_offset+=symb->getWidth();
          symb->setOffset(curr_offset);
          $$->addDeclarations(new SymbolInfo(*symb));
        bool insertion=table->insert(symb);
        if(!insertion) {
          //string errMsg = "Redeclaration of variable '" + symb->getName() + "'";
          string errMsg = "Conflicting types for'"+symb->getName()+"'";
          errorMessage(errMsg,@$.first_line);
        }
        }
      }
      symbols.clear();
     }
      ;




      
type_specifier  : INT
     {
      logRule("type_specifier	: INT ");
      $$ = (parsing(@$,"type_specifier	: INT ","INT"))->addSubordinate(parsing(@1,"INT : int","INT"));
      

    }
    | FLOAT {
            logRule("type_specifier	: FLOAT ");
      $$ = (parsing(@$,"type_specifier	: FLOAT ","FLOAT"))->addSubordinate(parsing(@1,"FLOAT : float","FLOAT"));
    }
    | VOID {   logRule("type_specifier	: VOID");
      $$ = (parsing(@$,"type_specifier	: VOID","VOID"))->addSubordinate(parsing(@1,"VOID : void","VOID"));

    }

     ;
     
declaration_list : ID
      {
        logRule("declaration_list : ID ");

        $$=parsing(@$, "declaration_list : ID ")->addSubordinate(parsing(@1,"ID : "+$1->getName()));
        symbols.push_back($1);
      }
      | declaration_list COMMA ID
      {
        logRule("declaration_list : declaration_list COMMA ID  ");
        $$=parsing(@$,"declaration_list : declaration_list COMMA ID  ")->addSubordinate($1)->addSubordinate(parsing(@2,"COMMA : ,"))->addSubordinate(parsing(@3,"ID : "+$3->getName()));
        symbols.push_back($3);
      }
      | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
      {
        logRule("declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE ");
        ParserNode* id_node = parsing(@3,"ID : "+$3->getName());
        ParserNode* com_node = parsing(@2,COMMA_R);
        ParserNode* LTNODE=parsing(@4,"LSQUARE : [");
        ParserNode* RTNODE=parsing(@6,"RSQUARE : ]");
        auto const_int = parsing(@5,"CONST_INT : "+$5->getName());

        $$ = parsing(@$,"declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE");
        $$->addSubordinate($1)->addSubordinate(com_node)->addSubordinate(id_node)->addSubordinate(LTNODE)->addSubordinate(const_int)->addSubordinate(RTNODE);
        $3->setArray(stoi($5->getName()));
        symbols.push_back($3);
      }
      | ID LTHIRD CONST_INT RTHIRD
      {
        logRule("declaration_list : ID LSQUARE CONST_INT RSQUARE ");
        ParserNode* id_node = parsing(@1,"ID : "+$1->getName());
        ParserNode* LTNODE=parsing(@2,"LSQUARE : [");
        ParserNode* RTNODE=parsing(@4,"RSQUARE : ]");
        auto const_int = parsing(@3,"CONST_INT : "+$3->getName());

        $$ = parsing(@$,"declaration_list : ID LSQUARE CONST_INT RSQUARE");
        $$->addSubordinate(id_node)->addSubordinate(LTNODE)->addSubordinate(const_int)->addSubordinate(RTNODE);
        $1->setArray(stoi($3->getName()));
        symbols.push_back($1);
      }
      | declaration_list error{
        
        $$=parsing(@$,"declaration_list : error");
        $$=$1;
        if($$->isErrorFlag()==false)
        syntaxErrorLog("Syntax error at declaration list of variable declaration ",@2.first_line);
        $$->setErrorFlag();
        // syntaxErrorLog(@1.first_line);
    
      }
      | error{
        //yyclearin;
        //yyerrok; 
        $$=parsing(@$,"declaration_list : error");
        if($$->isErrorFlag()==false)
        syntaxErrorLog("Syntax error at declaration list of variable declaration ",@1.first_line);
        $$->setErrorFlag();
         //syntaxErrorLog(@1.first_line);
    
      }

      ;
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON{
  string rule="func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON";
  logRule(rule);
  $$=parsing(@$,rule,$1->getDataType())->addSubordinate($1)->addSubordinate(parsing(@2,"ID : "+$2->getName()))->addSubordinate(parsing(@3,"LPAREN : ("))->addSubordinate($4);
  $$->addSubordinate(parsing(@5,"RPAREN : )"))->addSubordinate(parsing(@6,SEMICOLON_R));
  //SymbolInfo *f=new SymbolInfo($2->getName(),"ID");
  $2->setDecLine(@2.first_line);
  setFuncDetails($2,$1->getDataType());

  checkFunction($2,@2.first_line,$$->isErrorFlag());


}
		| type_specifier ID LPAREN RPAREN SEMICOLON{
        string rule="func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON ";
        logRule(rule);
         $$=parsing(@$,rule,$1->getDataType())->addSubordinate($1)->addSubordinate(parsing(@2,"ID : "+$2->getName()))->addSubordinate(parsing(@3,"LPAREN : ("));
         $$->addSubordinate(parsing(@4,"RPAREN : )"))->addSubordinate(parsing(@5,SEMICOLON_R));
         //SymbolInfo *f=new SymbolInfo($2->getName(),"ID");
         $2->setDecLine(@2.first_line);
         setFuncDetails($2,$1->getDataType());

         checkFunction($2,@2.first_line,$$->isErrorFlag());

    }
		;

    func_definition : type_specifier ID LPAREN parameter_list RPAREN{ 
       isGlobalScope=false;
       curr_offset=0;
        $2->setDefLine(@2.first_line);
      setFuncDetails($2,$1->getDataType());

      checkFunction($2,@2.first_line,true,true);} 
      compound_statement{

          string rule="func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement";
         logRule(rule);
         $$=new_function_definition(@$,rule,$1->getDataType(),$2->getName())->addSubordinate($1)->addSubordinate(parsing(@2,"ID : "+$2->getName()))->addSubordinate(parsing(@3,"LPAREN : ("))->addSubordinate($4);
         $$->addSubordinate(parsing(@5,"RPAREN : )"))->addSubordinate($7);
         $$->setSymbolInfo(new SymbolInfo(*$2));
        //  cout<<"setting symbol info for function : "<<*$2<<endl;
        //  cout<<"its param size is : "<<$2->getParameters().size()<<endl;
        //  cout<<"got as "<<$$->getSymbolInfo()->getParameters().size()<<endl;
        //  cout<<"its param size is : "<<$2->getParameters().size()<<endl;
        //cout<<"endingFunc before insert :";
      //  endingFunc->details();
//(save[0])->details();
        if($$->isErrorFlag()==false)
        {table->insert(save[0]);}
         funcID =nullptr;
         save.clear();
         isGlobalScope=true;
         curr_offset=0;
         
        

        SymbolInfo* chk=table->lookUp($2->getName());
      //  chk->details();

    }
		| type_specifier ID LPAREN RPAREN{
      isGlobalScope=false;
      curr_offset=0;
         $2->setDefLine(@2.first_line);
        setFuncDetails($2,$1->getDataType());

        checkFunction($2,@2.first_line,true,true);
    }
    compound_statement{
        string rule="func_definition : type_specifier ID LPAREN RPAREN compound_statement";
        logRule(rule);
         $$=new_function_definition(@$,rule,$1->getDataType(),$2->getName())->addSubordinate($1)->addSubordinate(parsing(@2,"ID : "+$2->getName()))->addSubordinate(parsing(@3,"LPAREN : ("));
         $$->addSubordinate(parsing(@4,"RPAREN : )"))->addSubordinate($6);
         $$->setSymbolInfo(new SymbolInfo(*$2));
        //  cout<<"setting symbol info for function : "<<*$2<<endl;
        //  cout<<"its param size is : "<<$2->getParameters().size()<<endl;
        //    cout<<"got as "<<$$->getSymbolInfo()->getParameters().size()<<endl;
        //    cout<<"its param size is : "<<$2->getParameters().size()<<endl;
        
         //       cout<<"endingFunc before insert :";
       // endingFunc->details();
       //(save[0])->details();
        if($$->isErrorFlag()==false)
        { table->insert(save[0]);}

         funcID =nullptr;
         save.clear();
         isGlobalScope=true;
         curr_offset=0;

        SymbolInfo* chk=table->lookUp($2->getName());
       // chk->details();
    }
    | type_specifier ID LPAREN RPAREN error{
      $$=parsing(@$,"func_definition : error");
      if($$->isErrorFlag()==false)
        syntaxErrorLog("Syntax error at function definition",@2.first_line);
        $$->setErrorFlag();
        // syntaxErrorLog(@1.first_line);
    
    }
    | type_specifier ID LPAREN parameter_list RPAREN{
             // syntaxErrorLog("Syntax error at function definition",@2.first_line);
               //syntaxErrorLog(@1.first_line);
                     $$=parsing(@$,"func_definition : error");
      if($$->isErrorFlag()==false) 
        syntaxErrorLog("Syntax error at function definition",@2.first_line);
        $$->setErrorFlag();
    
    }
 		;				

		 
			


parameter_list  : parameter_list COMMA type_specifier ID{
    string rule="parameter_list  : parameter_list COMMA type_specifier ID";
    logRule(rule);
    $$=parsing(@$,rule)->addSubordinate($1)->addSubordinate(parsing(@2,COMMA_R))->addSubordinate($3)->addSubordinate(parsing(@4,"ID : "+$4->getName()));
    $4->setVarType($3->getDataType());
    if(!isRedclaredParam($4)){
      $4->setIsParam();
       parameters.push_back($4);
    }
}
		| parameter_list COMMA type_specifier{
       string rule="parameter_list : parameter_list COMMA type_specifier";
       logRule(rule);
       $$=parsing(@$,rule)->addSubordinate($1)->addSubordinate(parsing(@2,COMMA_R))->addSubordinate($3);
       SymbolInfo *si=(new SymbolInfo("","ID"));
       si->setVarType($3->getDataType());
       si->setIsParam();
       parameters.push_back(si);

    }
 		| type_specifier ID{
          string rule="parameter_list  : type_specifier ID";
    logRule(rule);
     $$=parsing(@$,rule)->addSubordinate($1)->addSubordinate(parsing(@2,"ID : "+$2->getName()));
    $2->setVarType($1->getDataType());
    $2->setIsParam();
    if(!isRedclaredParam($2)){
       parameters.push_back($2);
    }
      //cout<<"line= "<<@1.first_line<<"PL"<<endl;
    }
		| type_specifier{
            string rule="parameter_list : type_specifier";
      logRule(rule);
       $$=parsing(@$,rule)->addSubordinate($1);
      SymbolInfo *si=(new SymbolInfo("","ID"));
      si->setVarType($1->getDataType());
      si->setIsParam();
       parameters.push_back(si);
      
    }
    | parameter_list error{
      //$$=$1;
      $$=parsing(@$,"parameter_list : error");
      $$=$1;
      if($$->isErrorFlag()==false) {
      syntaxErrorLog("Syntax error at parameter list of function definition",@2.first_line);
      }
       //syntaxErrorLog(@1.first_line);
       $$->setErrorFlag();
    

    }
    | error{
      //yyclearin;
      //yyerrok;
      $$=parsing(@$,"parameter_list : error");

      syntaxErrorLog("Syntax error at parameter list of function definition",@1.first_line);
      $$->setErrorFlag();
      
    }
 		;
 
 		compound_statement : 
    LCURL{
      insertParamNewScope();
     // cout<<"etotuku kay"<<endl;
    } statements RCURL{
      string rule="compound_statement : LCURL statements RCURL  ";
      logRule(rule);
      $$=new_compound_statement(@$,rule)->addSubordinate(parsing(@1,"LCURL : {"))->addSubordinate($3)->addSubordinate(parsing(@4,"RCURL : }"));
      table->printAll(logFileOutput);
      table->exitScope();
      //isGlobalScope = true;

    }
 		    | LCURL{insertParamNewScope();}
         RCURL{
      string rule="compound_statement : LCURL RCURL ";
      logRule(rule);
      $$=parsing(@$,rule)->addSubordinate(parsing(@1,"LCURL : {"))->addSubordinate(parsing(@3,"RCURL : }"));
      table->printAll(logFileOutput);
      table->exitScope();
      

        }
 		    ;
  
    statements : statement{
      logRule("statements : statement  ");
      $$=new_statement_statements(@$,"statements : statement  ")->addSubordinate($1);

    }
	   | statements statement{
            logRule("statements : statements statement ");
      $$=new_statements_statement_statements(@$,"statements : statements statement ")->addSubordinate($1)->addSubordinate($2);

     }| statements error statement{
                  logRule("statements : statements statement ");
      $$=parsing(@$,"statements : statements statement ")->addSubordinate($1)->addSubordinate($3);
      if($$->isErrorFlag()==false)
      syntaxErrorLog("Syntax error at statements ",@2.first_line);
      $$->setErrorFlag();
       //syntaxErrorLog(@1.first_line);
    
     } | statements error{
      //$$=$1;
      $$=parsing(@$,"statements : error");
      $$=$1;
      if($$->isErrorFlag()==false)
      syntaxErrorLog("Syntax error at statements ",@2.first_line);
      $$->setErrorFlag();
       //syntaxErrorLog(@1.first_line);
    
     } | error{
      //yyclearin;
      //yyerrok;
       syntaxErrorLog("Syntax error at statements ",@1.first_line);
      //(@1.first_line);
    
      $$=parsing(@$,"statements : error");
      $$->setErrorFlag();
     }
	   ;


     statement : 
 var_declaration{
      logRule("statement : var_declaration");
      $$=parsing(@$,"statement : var_declaration")->addSubordinate($1);
     }    
    | expression_statement{
      logRule("statement : expression_statement");
      $$=parsing(@$,"statement : expression_statement")->addSubordinate($1);

    }
	  | compound_statement{
            logRule("statement : compound_statement");
            $$=new_compound_statement_statement(@$,"statement : compound_statement")->addSubordinate($1);
    }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement{
      string rule="statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement";
      logRule(rule);
      $$=parsing(@$,rule)->addSubordinate(parsing(@1,FOR_R))->addSubordinate(parsing(@2,LPAREN_R))->addSubordinate($3)->addSubordinate($4)->addSubordinate($5)->addSubordinate(parsing(@6,RPAREN_R))->addSubordinate($7);

    }
	  | IF LPAREN expression RPAREN statement{
      string rule="statement : IF LPAREN expression RPAREN statement";
      logRule(rule);
      $$=new_if_statement(@$,rule)->addSubordinate(parsing(@1,IF_R))->addSubordinate(parsing(@2,LPAREN_R))->addSubordinate($3)->addSubordinate(parsing(@4,RPAREN_R))->addSubordinate($5);
    }
	  | IF LPAREN expression RPAREN statement ELSE statement{
      string rule="statement : IF LPAREN expression RPAREN statement ELSE statement";
      logRule(rule);
      $$=new_if_else_statement(@$,rule)->addSubordinate(parsing(@1,IF_R))->addSubordinate(parsing(@2,LPAREN_R))->addSubordinate($3)->addSubordinate(parsing(@4,RPAREN_R))->addSubordinate($5);
      $$->addSubordinate(parsing(@6,ELSE_R))->addSubordinate($7);
    }
	  | WHILE LPAREN expression RPAREN statement{
      string rule="statement : WHILE LPAREN expression RPAREN statement";
      logRule(rule);
      $$=parsing(@$,rule)->addSubordinate(parsing(@1,WHILE_R))->addSubordinate(parsing(@2,LPAREN_R))->addSubordinate($3)->addSubordinate(parsing(@4,RPAREN_R))->addSubordinate($5);
      
    }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON{
      string rule="statement : PRINTLN LPAREN ID RPAREN SEMICOLON";
      logRule(rule);
      $$=new_printlnCaller(@$,rule)->addSubordinate(parsing(@1,PRINTLN_R))->addSubordinate(parsing(@2,LPAREN_R))->addSubordinate(parsing(@3,"ID : "+$3->getName())->setSymbolInfo($3));
      $$->addSubordinate(parsing(@4,RPAREN_R))->addSubordinate(parsing(@5,SEMICOLON_R));
      $$->setSymbolInfo(new SymbolInfo("println","PRINTLN"));
      SymbolInfo* check=table->lookUp($3->getName());
      if(!check){
        errorMessage("Undeclared variable '" + $3->getName()+"'",@3.first_line);
      }

    }
	  | RETURN expression SEMICOLON{
      string rule="statement : RETURN expression SEMICOLON";
      logRule(rule);
      $$=new_return_statement(@$,rule)->addSubordinate(parsing(@1,RET_R))->addSubordinate($2)->addSubordinate(parsing(@3,SEMICOLON_R));
    }
	  ;


	  expression_statement 	: SEMICOLON			{
      logRule("expression_statement : SEMICOLON");$$=parsing(@$,"expression_statement : SEMICOLON")->addSubordinate(parsing(@1,SEMICOLON_R));
    }
			| expression SEMICOLON {
        string rule="expression_statement : expression SEMICOLON";
        logRule(rule);
        $$=parsing(@$,rule)->addSubordinate($1)->addSubordinate(parsing(@2,SEMICOLON_R));

      }
			;

      variable : ID 	{
        logRule("variable : ID 	 ");
        // SymbolInfo * sii=table->lookUp($1->getName());
        // if(sii!=nullptr)$1->setVarType(sii->getVarType());

        validVariableAdjust($1,@1.first_line);
        $$=new_variable(@$,"variable : ID 	 ",$1->getVarType(),$1->getName())->addSubordinate(parsing(@1,"ID : "+$1->getName()));
        $$->setSymbolInfo(new SymbolInfo(*$1));

      }	
	 | ID LTHIRD expression RTHIRD {
      string rule="variable : ID LSQUARE expression RSQUARE";
      logRule(rule);
      validArray($1,$3,@1.first_line);
      
      $$=new_variable(@$,rule,$1->getVarType(),$1->getName())->addSubordinate(parsing(@1,"ID : "+$1->getName()))->addSubordinate(parsing(@2,LTHIRD_R))->addSubordinate($3)->addSubordinate(parsing(@4,RTHIRD_R));
      $$->setSymbolInfo(new SymbolInfo(*$1));
   }
	 ;
expression : logic_expression	{
    string rule="expression 	: logic_expression	 ";
  logRule(rule);
$$=parsing(@$,rule,$1->getDataType(),$1->getValue())->addSubordinate($1);
// if($1->getDataType()=="VOID"){
// errorMessage("Void cannot be used in expression",@1.first_line);
// }

}
	   | variable ASSIGNOP logic_expression {
      string rule="expression : variable ASSIGNOP logic_expression";
      logRule(rule);
      $$=new_var_assignop_logic(@$,rule,$1->getDataType())->addSubordinate($1)->addSubordinate(parsing(@2,ASSIGN_R))->addSubordinate($3);
     //cout<<"assignment: "<<$1->getDataType()<<", "<<$3->getDataType()<<endl;
      if($1->getDataType() =="VOID" || $3->getDataType() =="VOID"){
        errorMessage("Void cannot be used in expression",@1.first_line);
      }
      if($1->getDataType() =="INT" && $3->getDataType()=="FLOAT"){
        errorMessage("Warning: possible loss of data in assignment of FLOAT to INT",@1.first_line);
        //errorFileOutput<<"Line# "<< @1.first_line<<": Warning: possible loss of data in assignment of FLOAT to INT"<<endl;
      }


     }
     | error{
      //yyclearin;
      //yyerrok;
       syntaxErrorLog("Syntax error at expression of expression statement",@1.first_line);
       //syntaxErrorLog(@1.first_line);
    
      $$=parsing(@$,"expression : error");
      $$->setErrorFlag();
     }	
	   ;
			
logic_expression : rel_expression 	{
  string rule="logic_expression : rel_expression 	 ";
  logRule(rule);
$$=new_rel_logic(@$,rule,$1->getDataType(),$1->getValue())->addSubordinate($1);
}
		 | rel_expression LOGICOP rel_expression {
      string rule="logic_expression : rel_expression LOGICOP rel_expression ";
      logRule(rule);
      string op=$2->getName();
      //cout<<"typecast these : "<<$1->getValue()<<" "<<$3->getValue()<<endl;
      string newType=typeCasted($1->getDataType(),$3->getDataType());
      if(newType!="VOID")newType="INT";
      $$=new_rel_logicop_rel(@$,rule,newType)->addSubordinate($1)->addSubordinate(parsing(@2,"LOGICOP : "+op))->addSubordinate($3);
       $$->setOperator($2->getName());
     }	
		 ;
			
rel_expression	: simple_expression {
  string rule="rel_expression	: simple_expression ";logRule(rule);
$$=parsing(@$,rule,$1->getDataType(),$1->getValue())->addSubordinate($1);

}
		| simple_expression RELOP simple_expression	{
      string rule="rel_expression : simple_expression RELOP simple_expression";logRule(rule);
      string op=$2->getName();
          //  cout<<"typecast these : "<<$1->getValue()<<" "<<$3->getValue()<<endl;
      string newType=typeCasted($1->getDataType(),$3->getDataType());
      if(newType!="VOID")newType="INT";
      $$=new_simp_relop_simp_relexp(@$,rule,newType)->addSubordinate($1)->addSubordinate(parsing(@2,"RELOP : "+op))->addSubordinate($3);
      $$->setOperator($2->getName());
    //  $$->setTrueLabel("true_label");
      //$$->setFalseLabel("false_label");

    }
		;
				
simple_expression : term {
  string rule="simple_expression : term ";logRule(rule);
$$=parsing(@$,rule,$1->getDataType(),$1->getValue())->addSubordinate($1);

}
		  | simple_expression ADDOP term {
      string rule="simple_expression : simple_expression ADDOP term  ";logRule(rule);
      string op=$2->getName();
          //  cout<<"typecast these : "<<$1->getValue()<<" "<<$3->getValue()<<endl;
      string newType=typeCasted($1->getDataType(),$3->getDataType());
      $$=new_simple_expr_addop_term(@$,rule,newType)->addSubordinate($1)->addSubordinate(parsing(@2,"ADDOP : "+op))->addSubordinate($3);
      $$->setOperator($2->getName());

      }
		  ;
					
term :	unary_expression{string rule="term :	unary_expression ";logRule(rule);
$$=parsing(@$,rule,$1->getDataType(),$1->getValue())->addSubordinate($1);
}
     |  term MULOP unary_expression{
      string rule="term : term MULOP unary_expression";
      logRule(rule);
      string op=$2->getName();
            //cout<<"typecast these : "<<$1->getValue()<<" "<<$3->getValue()<<endl;
          
      string newType=typeCasted($1->getDataType(),$3->getDataType());
      if(op=="%")newType="INT";
      $$=new_term_mulop_unary(@$,rule,newType)->addSubordinate($1)->addSubordinate(parsing(@2,"MULOP : "+op))->addSubordinate($3);
      $$->setOperator($2->getName());
      if((op=="%" || op=="/")&&($3->getValue()=="0")){
        string msg="Warning: division by zero i=0f=1Const=0"/*+$1->getValue()+" "+$3->getValue()*/;
        //errorFileOutput<<"Line# "<< @$.first_line<<": "<<msg<<endl;
        errorMessage(msg,@$.first_line);
      }
      if(op=="%" && ($1->getDataType()=="FLOAT"||$3->getDataType()=="FLOAT")){
        errorMessage("Operands of modulus must be integers",@$.first_line);
      }


     }
     ;

unary_expression : ADDOP unary_expression  {
  // if($2->getDataType()=="VOID" ){
  //   errorMessage("Can not use unary operator on void type",$2->getFirstLine());
  // }
  string rule="unary_expression : ADDOP unary_expression";logRule(rule);
  $$=new_addop_unary(@$,rule,$2->getDataType())->addSubordinate(parsing(@1,"ADDOP : ",$1->getName()))->addSubordinate($2);
  $$->setOperator($1->getName());

}
		 | NOT unary_expression {
    //     if($2->getDataType()=="VOID"){
    // errorMessage("Can not perform unary operation on VOID operand",$2->getFirstLine());
    //     }
      string rule="unary_expression : NOT unary_expression";logRule(rule);
  $$=new_not_unary(@$,rule,$2->getDataType())->addSubordinate(parsing(@1,NOT_R))->addSubordinate($2);
  

     }
		 | factor {
    //     if($1->getDataType()=="VOID"){
    // errorMessage("Can not perform unary operation on VOID operand",$1->getFirstLine());
    //     }
    string rule="unary_expression : factor ";logRule(rule);
    $$=parsing(@$,rule,$1->getDataType(),$1->getValue())->addSubordinate($1);
  

     }
		 ;
	
factor	: variable {
logRule("factor	: variable ");$$=new_variable_factor(@$,"factor	: variable ",$1->getDataType(),$1->getValue())->addSubordinate($1);
$$->setSymbolInfo($1->getSymbolInfo());
}

	| LPAREN expression RPAREN{
    string rule="factor : LPAREN expression RPAREN";logRule(rule);
    $$=new lpExprRp(@$.first_line,@$.last_line,rule,$2->getDataType(),$2->getValue());
    $$->addSubordinate(parsing(@1,LPAREN_R))->addSubordinate($2)->addSubordinate(parsing(@3,RPAREN_R));

  }
	| CONST_INT {logRule("factor : CONST_INT");$$=new_int_factor(@$,"factor : CONST_INT ","INT",$1->getName())->addSubordinate(parsing(@$,"CONST_INT : "+$1->getName()));
  $$->setSymbolInfo(new SymbolInfo(*$1));

  }
	| CONST_FLOAT{
logRule("factor : CONST_FLOAT");$$=parsing(@$,"factor : CONST_FLOAT ","FLOAT",$1->getName())->addSubordinate(parsing(@$,"CONST_FLOAT : "+$1->getName()));
  }
  | ERROR_NUM{
    errorMessage("Lexical error : "+$1->getName()+" an "+$1->getType(),@1.first_line);
  }

	| variable INCOP{string rule="factor : variable INCOP ";logRule(rule);
  $$=new_var_incDec(@$,rule,$1->getDataType())->setOperator("++")->addSubordinate($1)->addSubordinate(parsing(@2,INC_R));

  } 
	| variable DECOP{
string rule="factor : variable DECOP";logRule(rule);
  $$=new_var_incDec(@$,rule,$1->getDataType())->setOperator("--")->addSubordinate($1)->addSubordinate(parsing(@2,DEC_R));

  }	
  | ID LPAREN argument_list RPAREN{
    string rule="factor : ID LPAREN argument_list RPAREN";logRule(rule);
     funcCallADjust($1,@1.first_line);
     //cout<<"func ret type= "<<$1->getVarType()<<" name="<<$1->getName()<<endl;

    $$=new_funcCall_factor(@$,rule,$1->getVarType());
    $$->addSubordinate(parsing(@1,"ID : "+$1->getName(),$1->getReturnType()))->addSubordinate(parsing(@2,LPAREN_R));
    $$->addSubordinate($3)->addSubordinate(parsing(@4,RPAREN_R));
    $$->setSymbolInfo(new SymbolInfo(*$1));
        // cout<<"funcCall_factor from bison ----------------------------------------------------------------"<<*$1<<endl;
   

  }
	;
	
argument_list : arguments{
  logRule("argument_list : arguments");
  $$=parsing(@$,"argument_list : arguments")->addSubordinate($1);

}
			  |{
          logRule("argument_list : ");
          $$=parsing(@$,"argument_list : ");
        }
			  ;
	
arguments : arguments COMMA logic_expression{
  string rule="arguments : arguments COMMA logic_expression";
  logRule(rule);
  $$=parsing(@$,rule)->addSubordinate($1)->addSubordinate(parsing(@2,COMMA_R))->addSubordinate($3);
  argumentsList.push_back($3->getDataType());

}
	      | logic_expression{
          logRule("arguments : logic_expression");
          $$=parsing(@$,"arguments : logic_expression",$1->getDataType())->addSubordinate($1);
          argumentsList.push_back($1->getDataType());

        }
        |arguments COMMA error{
          //$$=$1;
          $$=parsing(@$,"arguments : error");
          $$=$1;
          if($1->isErrorFlag()==false)
          syntaxErrorLog("Syntax error at argument list of call expression",@2.first_line);
          $$->setErrorFlag();
           //syntaxErrorLog(@1.first_line);
    
        }
        | error{
          //yyclearin;
          //yyerrok;
           syntaxErrorLog("Syntax error at argument list of call expression",@1.first_line);
          // syntaxErrorLog(@1.first_line);
    
          $$=parsing(@$,"arguments : error");
          $$->setErrorFlag();

        }
	      ;

    

%%
bool endsWithC(const char* filename) {
    size_t len = strlen(filename);


    return (len >= 2 && strcmp(filename + len - 2, ".c") == 0);
}
int main(int argc,char *argv[])
{

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.");
		exit(1);
	}
	if(!endsWithC(argv[1])){
		printf("Not a C file.");
		exit(1);
	}
    string input_file_name=argv[1];
	string parsetree_file_name = input_file_name.substr(0,input_file_name.size()-2) + "_parsetree.txt";
	string error_file_name = input_file_name.substr(0,input_file_name.size()-2) + "_error.txt";
    string logFileName = input_file_name.substr(0,input_file_name.size()-2) + "_log.txt";

    logFileOutput.open(logFileName);
    errorFileOutput.open(error_file_name);
    parsetree_file.open(parsetree_file_name);
	

	yyin=fp;
	yyparse();
	

	logFileOutput.close();
    errorFileOutput.close();
    parsetree_file.close();
	
	return 0;
}

