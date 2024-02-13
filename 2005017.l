%option noyywrap

%x Single_Comment_state
%x Multiline_comment_state
%x String_state
%x Character_state
%x Ignore_newlines


%{
#include"SymbolTable/SymbolTable.h"
#include"helper.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<fstream>
#include<cmath>
#include<iostream>
#include<vector>
#include "ParseTree.h"
#include "2005017.tab.h"

using namespace std;


void initializeLocation(YYLTYPE* yylloc) {
    yylloc->first_line = yylloc->last_line;
    yylloc->first_column = yylloc->last_column;
}

void handleNewline(YYLTYPE* yylloc) {
    yylloc->last_line++;
    yylloc->last_column = 1;
    initializeLocation(yylloc);
}

void countNewlines(YYLTYPE* yylloc, const string& s) {
    for (char c : s) {
        if (c == '\n') {
            handleNewline(yylloc);
        }
    }
}

//extern int line_count=1;



// FILE *logFileOutput;
// FILE *tokelFileOutput;

// ofstream logFileOutput;
// ofstream tokelFileOutput;


// int bucket_size=10;
// SymbolTable* symbolTable=new SymbolTable(bucket_size);


extern YYSTYPE yylval;
extern SymbolTable *table;
extern ofstream logFileOutput;
//void yyerror(char *);
void yyerror(string);

int line_count=1;
//int error=0;




int expected_tab=0;
int error_count=0;
int warning_count=0;
int newlines_count=0;

int tab_count=0;
int v_count=0;
int f_count=0;
int r_count=0;
int space_count=0;



string comment_content;

string char_const;
string char_const_printable;

bool unrec_slash;

string str_const;
string str_const_printable;

void resetWhitespaceCounts(){
	tab_count=0;
	v_count=0;
	f_count=0;
	r_count=0;
	space_count=0;
}

void updateWhiteSpaceCounts(){

	for (int i = 0; yytext[i] != '\0'; i++) {
		//cout<<"yytexti="<<yytext[i]<<endl;
		if(yytext[i]=='\n'){
			resetWhitespaceCounts();
			line_count++;
			handleNewline(&yylloc);

		}
        if (yytext[i] ==' ') {
            space_count++;
        } else if (yytext[i] == '\t') {
            tab_count++;
        }
		// else if (yytext[i] == '\v') {
        //     v_count++;
        // }
		// else if (yytext[i] == '\r') {
        //     r_count++;
        // }
		// else if (yytext[i] == '\f') {
        //     f_count++;
        // }
		
    }
}

void showIndentationWarning(){
	//logFileOutput<<"LINE# "<<line_count<<"tabs,spaces= "<<tab_count<<' '<<space_count<<endl;
	if(tab_count!=expected_tab && space_count==0) {
		warning_count++;
		//logFileOutput<<"Line# "<<line_count<<": warning, "<<expected_tab<<" of tabs needed but got "<<tab_count<<" tabs."<<endl;

	}
	else if(space_count>0){
		warning_count++;
		//logFileOutput<<"Line# "<<line_count<<": Warning, tab requrired but got space.\n";
	}


}

%}


WHITESPACE [ \t\f\r\v]+
LETTER [a-zA-Z]
DIGIT [0-9]
NOT_DIGIT [^0-9\n]
NEWLINE [\r]?\n
Id_first [a-zA-Z_]
Id_content [a-zA-Z_0-9]
AlphaNumeric [a-zA-Z0-9]





KEYWORDS 	if|else|for|while|do|break|int|char|float|double|void|return|switch|case|default|continue
IDENTIFIER {Id_first}{Id_content}*
INTEGER {DIGIT}+
NUMBER ({DIGIT}+((\.{DIGIT}+)?([Ee][+-]?{DIGIT}+)?)?)|(((\.{DIGIT}+)([Ee][+-]?{DIGIT}+)?))
ILLFORMED_NUMBER ([+-]?{DIGIT}*((\.{DIGIT}+)([Ee][+-]?{DIGIT}+(\.{DIGIT}*))))|([+-]?{DIGIT}+((\.{DIGIT}+)?([Ee][+-]?{DIGIT}+(\.{DIGIT}*))))
ILLFORMED_NUMBER2 ([+-]?{DIGIT}*((\.{DIGIT}+)([Ee][+-]?{DIGIT}*(\.{DIGIT}*))))|([+-]?{DIGIT}+((\.{DIGIT}+)?([Ee][+-]?{DIGIT}*(\.{DIGIT}*))))
TOO_MANY_DECIMAL_POINTS ([+-]?{DIGIT}*(\.{DIGIT}*)(\.{DIGIT}*)+(([Ee][+-]?{DIGIT}+))?)
TOO_MANY_DECIMAL_POINTS_TRIAL ([+-]?{DIGIT}*(\.{DIGIT}*)(\.{DIGIT}*)+(([Ee][+-]?{DIGIT}+)*)?)
INVALID_ID_SUFFIX_NUM_PREFIX ((([+-]?{DIGIT}*(\.{DIGIT}+([Ee][+-]?{DIGIT}+)?))|([+-]?{DIGIT}+(\.{DIGIT}+([Ee][+-]?{DIGIT}+)?)?)|[+-]?\.{DIGIT}+([Ee][+-]?{DIGIT}+)?){LETTER}{Id_content}*)
INVALID_ID_SUFFIX_NUM_PREFIX_test ({Id_first}+(({DIGIT}*(\.{DIGIT}+([Ee][+-]?{DIGIT}+)?)?)| (\.{DIGIT}+([Ee][+-]?{DIGIT}+)?)))

ADDOP "+"|"-"
MULOP "*"|"/"|"%"
INCOP "++"
DECOP "--"
RELOP "<"|"<="|">"|">="|"=="|"!="
LOGICOP "&&"|"||"
BITOP "&"|"|"|"^"|"<<"|">>"
NEXTLINE {NEWLINE}{WHITESPACE}*

%%
%{
	initializeLocation(&yylloc);
%}
^{WHITESPACE}* {
	resetWhitespaceCounts();
	updateWhiteSpaceCounts();
	showIndentationWarning();
	//cout<<"called at line "<<line_count<<endl;
}



{WHITESPACE} {

}



{NEXTLINE}* {
	//line_count++;
	resetWhitespaceCounts();
	updateWhiteSpaceCounts();
	showIndentationWarning();
	
}



{NEXTLINE}+"}" {
	//line_count++;
	expected_tab--;
	resetWhitespaceCounts();
	updateWhiteSpaceCounts();
	showIndentationWarning();

	//tokenFileOutput<< "<RCURL, }>\n";
    logFileOutput<< "Line# " << line_count << ": Token <RCURL> Lexeme } found\n";
	/////////////symbolTable->exitScope();
	
	return RCURL;
}




"if" {logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
return IF;}
"else" {logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
return ELSE;}
"for" {logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
return FOR;}
"while" {logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
return WHILE;}
"int" {
	// SymbolInfo info=new SymbolInfo(yytext,"INT");
	// yylval.symbolInfo=info;
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return INT;
	}
"float" {
	// SymbolInfo info=new SymbolInfo(yytext,"FLOAT");
	// yylval.symbolInfo=info;
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return FLOAT;
	}
"double" {
	// SymbolInfo info=new SymbolInfo(yytext,"Double");
	// yylval.symbolInfo=info;
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return DOUBLE;}
"char" {
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return CHAR;}
"return" {
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return RETURN;}
"void" {
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return VOID;}

"println"	{
	//SymbolInfo info=new SymbolInfo(yytext,"ID");
	//info.setFuncInfo();
	//yylval.symbolInfo=info;
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return PRINTLN;
	}

"do" {
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return DO;}
"break" {
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return BREAK;}
"switch" {
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return SWITCH;}
"case" {
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return CASE;}
"default" {
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return DEFAULT;}
"continue" {
	logFileOutput<< "Line# " << line_count << ": Token <"<<toUppercase(yytext)<<"> Lexeme "<<yytext<<" found\n";
	return CONTINUE;}




{INTEGER} {
	// int value = atoi(yytext);
    // int absoluteValue = abs(value);

	SymbolInfo *s= new  SymbolInfo(yytext, "CONST_INT");
	yylval.symbolInfo=s;
	logFileOutput<<"Line# "<< line_count <<": Token " <<"<CONST_INT>"<<" Lexeme "<<yytext<<" found\n";

	return CONST_INT;
    //tokenFileOutput<<"<CONST_INT, "<<absoluteValue<<">\n";
	
    
}



{NUMBER} {

	

	  float value = atof(yytext); 
      float absoluteValue = fabs(value);


	  if(yytext[0]=='+' || yytext[0]=='-'){
		//yytext++;
	  }
	  //tokenFileOutput<<"<CONST_FLOAT, "<<yytext<<">\n";
	  //string present="";
	  
	  logFileOutput<<"Line# "<< line_count <<": Token " <<"<CONST_FLOAT>"<<" Lexeme "<<yytext<<" found\n";
	SymbolInfo *s= new  SymbolInfo(yytext, "CONST_FLOAT");
	yylval.symbolInfo=s;
	
	return CONST_FLOAT;
}

{ILLFORMED_NUMBER}|{ILLFORMED_NUMBER2} {
	error_count++;
	////logFileOutput<<"Error at line# "<<line_count<<": ILLFORMED_NUMBER "<<yytext<<endl;
	yylval.symbolInfo=new SymbolInfo(yytext, "ILLFORMED_NUMBER");
	return ERROR_NUM;
}


 
{TOO_MANY_DECIMAL_POINTS} {
	error_count++;
	////logFileOutput<<"Error at line# "<<line_count<<": TOO_MANY_DECIMAL_POINTS "<<yytext<<endl;
	yylval.symbolInfo=new SymbolInfo(yytext, "TOO_MANY_DECIMAL_POINTS");
	return ERROR_NUM;

}







\'\'(\')+ {
	////logFileOutput<<"Error at line# "<<line_count<<": UNRECOGNIZED_CHAR "<<yytext<<endl;
	error_count++;

}
\"\"(\")+ {
	////logFileOutput<<"Error at line# "<<line_count<<": UNRECOGNIZED_CHAR "<<yytext<<endl;
	error_count++;

}








\' {
	char_const.clear();
	char_const_printable.clear();
	unrec_slash=false;
	
	BEGIN Character_state;
	

}
<Character_state>\\\' {
	char_const+="\'";
	char_const_printable+="\\\'";
}
<Character_state>\\\" {
	char_const+="\"";
	char_const_printable+="\\\"";
	
}
<Character_state>{NEXTLINE}* {
	error_count++;
	
	string error_msg="'";
	error_msg+=char_const_printable;

	////logFileOutput<<"Error at line# "<<line_count<<": UNFINISHED_CONST_CHAR "<<error_msg<<endl;
	
	
	//line_count++;
	resetWhitespaceCounts();
	updateWhiteSpaceCounts();
	showIndentationWarning();


	BEGIN INITIAL;
}

<Character_state>\\t {
	char_const+="\t";
	char_const_printable+="\\t";
	
}

<Character_state>\\\\ {
	char_const+="\\";
	char_const_printable+="\\\\";
	
}

<Character_state>\\a {
	char_const+="\a";
	char_const_printable+="\\a";
	
}
<Character_state>\\f {
	char_const+="\f";
	char_const_printable+="\\f";
	
}
<Character_state>\\r {
	char_const+="\r";
	char_const_printable+="\\r";
	
}

<Character_state>\\b {
	char_const+="\b";
	char_const_printable+="\\b";
	
}

<Character_state>\\v {
	char_const+="\v";
	char_const_printable+="\\v";
	
}

<Character_state>\\0 {
	char_const+="\0";
	char_const_printable+="\\0";
	
}

<Character_state>\\n {
	char_const+="\n";
	char_const_printable+="\\n";
	
}
<Character_state>\\. {
	char_const+="\?";
	char_const_printable+=yytext;
	unrec_slash=true;
}





<Character_state>\' {
	if(char_const.length()>1){
		error_count++;
		string error_msg="\'";
		error_msg+=char_const_printable;
		error_msg+="\'";
	//	//logFileOutput<<"Error at line# "<<line_count<<": MULTICHAR_CONST_CHAR "<<error_msg<<endl;
	}
	else if(char_const.length()==1 && unrec_slash){
		error_count++;
		string error_msg="\'";
		error_msg+=char_const_printable;
		error_msg+="\'";
		////logFileOutput<<"Error at line# "<<line_count<<": UNRECOGNIZED_CHAR "<<error_msg<<endl;
	}
	else if(char_const.length()==1 || (char_const.length()==0 && char_const_printable=="\\0")){
		
	//tokenFileOutput<<"<CONST_CHAR, "<<char_const<<">\n";
	//logFileOutput<<"Line# "<< line_count <<": Token " <<"<CONST_CHAR>"<<" Lexeme "<<char_const<<" found\n";
	}
	else{
		error_count++;
		////logFileOutput<<"Error at line# "<<line_count<<": EMPTY_CONST_CHAR \'\'"<<endl;

	}


	BEGIN INITIAL;
}

<Character_state><<EOF>> {
	error_count++;
	
	string error_msg="'";
	error_msg+=char_const_printable;

	////logFileOutput<<"Error at line# "<<line_count<<": UNFINISHED_CONST_CHAR "<<error_msg<<endl;
	
	BEGIN INITIAL;


}

<Character_state>. {
char_const+=yytext;
char_const_printable+=yytext;


}








	
{ADDOP} {
			//tokenFileOutput<<"<ADDOP, "<<yytext<<">\n";
			logFileOutput<<"Line# "<<line_count<<": Token <ADDOP> Lexeme "<<yytext<<" found\n";
			SymbolInfo *s= new  SymbolInfo(yytext, "ADDOP");
			yylval.symbolInfo=s;
			
			return ADDOP;
			
		}


{MULOP} {
			//tokenFileOutput<<"<MULOP, "<<yytext<<">\n";
			logFileOutput<<"Line# "<<line_count<<": Token <MULOP> Lexeme "<<yytext<<" found\n";
			SymbolInfo *s= new  SymbolInfo(yytext, "MULOP");
			yylval.symbolInfo=s;
			
			return MULOP;
		}

{INCOP} {
			//tokenFileOutput<<"<INCOP, "<<yytext<<">\n";
			logFileOutput<<"Line# "<<line_count<<": Token <INCOP> Lexeme "<<yytext<<" found\n";
			SymbolInfo* s=new SymbolInfo(yytext,"INCOP");yylval.symbolInfo=s;
			return INCOP;
		}	

{DECOP} {
	SymbolInfo* s=new SymbolInfo(yytext,"DECOP");yylval.symbolInfo=s;
	return DECOP;
}		

{RELOP} {
//tokenFileOutput<<"<RELOP, "<<yytext<<">\n";
logFileOutput<<"Line# "<<line_count<<": Token <RELOP> Lexeme "<<yytext<<" found\n";
		SymbolInfo *s= new  SymbolInfo(yytext, "RELOP");
		yylval.symbolInfo=s;
		return RELOP;
}

"=" {
	logFileOutput<<"Line# "<<line_count<<": Token <ASSIGNOP> Lexeme "<<yytext<<" found\n";
	//SymbolInfo* s=new SymbolInfo(yytext,"ASSIGNOP");yylval.symbolInfo=s;
	return ASSIGNOP;
	//tokenFileOutput<<"<ASSIGNOP, "<<yytext<<">\n";
			
}

{LOGICOP} {
	 logFileOutput<< "Line# " << line_count << ": Token <LOGICOP> Lexeme " << yytext << " found\n";
				SymbolInfo *s= new  SymbolInfo(yytext, "LOGICOP");
			yylval.symbolInfo=s;
			return LOGICOP;
    //tokenFileOutput<< "<LOGICOP, " << yytext << ">\n";
   
}


{BITOP}  {
	 logFileOutput<< "Line# " << line_count << ": Token <BITOP> Lexeme " << yytext << " found\n";
			SymbolInfo *s= new  SymbolInfo(yytext, "BITOP");
		yylval.symbolInfo=s;
		return BITOP;
    //tokenFileOutput<< "<BITOP, " << yytext << ">\n";
   
}


"!" {
	logFileOutput<< "Line# " << line_count << ": Token <NOT> Lexeme " << yytext << " found\n";
	//SymbolInfo* s=new SymbolInfo(yytext,"NOT");yylval.symbolInfo=s;
	return NOT;
    //tokenFileOutput<< "<NOT, " << yytext << ">\n";
    
}

"(" {
	//SymbolInfo* s=new SymbolInfo(yytext,"LPAREN");yylval.symbolInfo=s;
	logFileOutput<< "Line# " << line_count << ": Token <LPAREN> Lexeme " << yytext << " found\n";
	return LPAREN;
    //tokenFileOutput<< "<LPAREN, " << yytext << ">\n";
    
}

")" {
	logFileOutput<< "Line# " << line_count << ": Token <RPAREN> Lexeme " << yytext << " found\n";
	//SymbolInfo* s=new SymbolInfo(yytext,"RPAREN");yylval.symbolInfo=s;
	return RPAREN;
    //tokenFileOutput<< "<RPAREN, " << yytext << ">\n";
    
}

"{" {
	//SymbolInfo* s=new SymbolInfo(yytext,"LCURL");yylval.symbolInfo=s;
	
    //tokenFileOutput<< "<LCURL, " << yytext << ">\n";
    logFileOutput<< "Line# " << line_count << ": Token <LCURL> Lexeme " << yytext << " found\n";
	
	//////////////////symbolTable->enterScope();
	expected_tab++;
	return LCURL;
}
"}" {
	//SymbolInfo* s=new SymbolInfo(yytext,"RCURL");yylval.symbolInfo=s;
	logFileOutput<< "Line# " << line_count << ": Token <RCURL> Lexeme } found\n";
	expected_tab--;
	return RCURL;
	//tokenFileOutput<< "<RCURL, }>\n";
    
	////////////////symbolTable->exitScope();
}


"[" {
	//SymbolInfo* s=new SymbolInfo(yytext,"LTHIRD");yylval.symbolInfo=s;
	 logFileOutput<< "Line# " << line_count << ": Token <LSQUARE> Lexeme " << yytext << " found\n";
	return LTHIRD;
    //tokenFileOutput<< "<LSQUARE, " << yytext << ">\n";
   
}

"]" {
	//SymbolInfo* s=new SymbolInfo(yytext,"RTHIRD");yylval.symbolInfo=s;
	logFileOutput<< "Line# " << line_count << ": Token <RSQUARE> Lexeme " << yytext << " found\n";
	return RTHIRD;
	//tokenFileOutput<< "<RSQUARE, " << yytext << ">\n";
    
}


"," {
	//SymbolInfo* s=new SymbolInfo(yytext,"COMMA");yylval.symbolInfo=s;
	logFileOutput<< "Line# " << line_count << ": Token <COMMA> Lexeme " << yytext << " found\n";
	return COMMA;
    //tokenFileOutput<< "<COMMA, " << yytext << ">\n";
    
}

";" {
	//SymbolInfo* s=new SymbolInfo(yytext,"SEMICOLON");yylval.symbolInfo=s;
	logFileOutput<< "Line# " << line_count << ": Token <SEMICOLON> Lexeme " << yytext << " found\n";
	return SEMICOLON;
    //tokenFileOutput<< "<SEMICOLON, "<< yytext << ">\n";
    
}







{IDENTIFIER} {
	 //tokenFileOutput<< "<ID, " << yytext << ">\n";
    logFileOutput<< "Line# " << line_count << ": Token <ID> Lexeme " << yytext << " found\n";
	// if(symbolTable->insert(yytext,"ID")){
	// 	symbolTable->printAll(logFileOutput);
	// }
	// else{
	// 	logFileOutput<<"\t"<< yytext<<" already exists in the current ScopeTable\n";
	// }
					//SymbolInfo *s= table->lookUp(yytext);
				//if(s==nullptr)
				//{					
				SymbolInfo*	s= new SymbolInfo(yytext, "ID");
				//}
				//s->setLineNo(line_count);
				yylval.symbolInfo=s;
							
				return ID;			
				


}

{INVALID_ID_SUFFIX_NUM_PREFIX} {
	error_count++;
		yylval.symbolInfo=new SymbolInfo(yytext, "INVALID_ID_SUFFIX_NUM_PREFIX");
	return ERROR_NUM;
	////logFileOutput<<"Error at line# "<<line_count<<": INVALID_ID_SUFFIX_NUM_PREFIX "<<yytext<<endl;
}








\" {
	str_const.clear();
	str_const_printable.clear();
    newlines_count=0;

	BEGIN String_state;
	

}
<String_state>\\\' {
	str_const+="\'";
	str_const_printable+="\\\'";
}
<String_state>\\\" {
	str_const+="\"";
	str_const_printable+="\\\"";
	
}

<String_state>{NEXTLINE}* {
	error_count++;
	
	string error_msg="\"";
	error_msg+=str_const_printable;
	

	////logFileOutput<<"Error at line# "<<line_count+newlines_count<<": UNFINISHED_STRING "<<error_msg<<endl;
	//newlines_count++;
	line_count+=newlines_count;
	newlines_count=0;
	resetWhitespaceCounts();
	updateWhiteSpaceCounts();
	showIndentationWarning();
	BEGIN INITIAL;
}

<String_state>\\t {
	str_const+="\t";
	str_const_printable+="\\t";
	
}

<String_state>\\\\ {
	str_const+="\\";
	str_const_printable+="\\\\";
	
}

<String_state>\\a {
	str_const+="\a";
	str_const_printable+="\\a";
	
}
<String_state>\\f {
	str_const+="\f";
	str_const_printable+="\\f";
	
}
<String_state>\\r {
	str_const+="\r";
	str_const_printable+="\\r";
	
}

<String_state>\\b {
	str_const+="\b";
	str_const_printable+="\\b";
	
}

<String_state>\\v {
	str_const+="\v";
	str_const_printable+="\\v";
	
}

<String_state>\\0 {
	str_const+="\0";
	str_const_printable+="\\0";
	
}

<String_state>\\n {
	str_const+="\n";
	str_const_printable+="\\n";
	
}

<String_state>\\ {

	BEGIN Ignore_newlines;
	str_const_printable+="\\";

}

<Ignore_newlines>{NEWLINE} {
	newlines_count++;
	str_const_printable+="\n";
	BEGIN String_state;
}
<Ignore_newlines>. {
	//cout<<"multiline string not like this"<<endl;
	str_const+=yytext;
	str_const_printable+=yytext;
	BEGIN String_state;

}

<String_state>\" {
	
	////tokenFileOutput<<"<STRING, "<<str_const<<">\n";
	string written="\"";
	written+=str_const_printable;
	written+="\"";
	string name="SINGLE LINE STRING";
	if(newlines_count>0)name="MULTI LINE STRING";
	//tokenFileOutput<<"<"<<name<<", "<<str_const<<">"<<endl;

	//logFileOutput<<"Line# "<< line_count <<": Token <" <<name<<"> Lexeme "<<written<<" found\n";
	
	line_count+=newlines_count;
	newlines_count=0;
	BEGIN INITIAL;
}

<String_state><<EOF>> {
	error_count++;
	
	string error_msg="\"";
	error_msg+=str_const_printable;

	//logFileOutput<<"Error at line# "<<line_count+newlines_count<<": UNFINISHED_STRING   "<<error_msg<<endl;
	line_count+=newlines_count;
	newlines_count=0;

	BEGIN INITIAL;


}

<String_state>. {
str_const+=yytext;
str_const_printable+=yytext;

}










\/\/ {
newlines_count=0;
comment_content.clear();
BEGIN Single_Comment_state;

}
<Single_Comment_state>\\{NEWLINE} {
	newlines_count++;
	comment_content+="\\\n";

}
<Single_Comment_state>{NEXTLINE}* {
	
	//newlines_count++;
	//logFileOutput<<"Line# "<<line_count<<": Token <SINGLE LINE COMMENT> Lexeme //"<<comment_content<<" found"<<endl;
	line_count+=newlines_count;
	resetWhitespaceCounts();
	updateWhiteSpaceCounts();
	showIndentationWarning();
	newlines_count=0;
	BEGIN INITIAL;
}



<Single_Comment_state><<EOF>> {
	/*error_count++;
	
	string error_msg="//";
	error_msg+=comment_content;

	//logFileOutput<<"Error at line# "<<line_count+newlines_count<<": UNFINISHED_COMMENT "<<error_msg<<endl;
	*/
	//logFileOutput<<"Line# "<<line_count<<": Token <SINGLE LINE COMMENT> Lexeme //"<<comment_content<<" found"<<endl;
	line_count+=newlines_count;
	newlines_count=0;

	BEGIN INITIAL;


}

<Single_Comment_state>. {
	comment_content+=yytext;
}








\/\* {
	comment_content.clear();
	newlines_count=0;
	BEGIN Multiline_comment_state;
	
}
<Multiline_comment_state>{NEWLINE} {
	newlines_count++;
	comment_content+="\n";
}
<Multiline_comment_state>\*\/ {
	//logFileOutput<<"Line# "<<line_count<<": Token <MULTI LINE COMMENT> Lexeme /*"<<comment_content<<"*/ found"<<endl;
	line_count+=newlines_count;
	newlines_count=0;
	BEGIN INITIAL;

}

<Multiline_comment_state><<EOF>> {
	error_count++;
	
	string error_msg="/*";
	error_msg+=comment_content;


	//logFileOutput<<"Error at line# "<<line_count+newlines_count<<": UNFINISHED_COMMENT "<<error_msg<<endl;
	line_count+=newlines_count;
	newlines_count=0;

	BEGIN INITIAL;


}
<Multiline_comment_state>. {
	comment_content+=yytext;
}








<<EOF>> {

//symbolTable->printAll(logFileOutput);

//logFileOutput<<"Total warnings: "<<warning_count<<endl;
//delete symbolTable;//this is line should be commented if We need to use the SymbolTable Later


return 0;

}





. {
    
	logFileOutput<<"Error at line# "<<line_count<<": UNRECOGNIZED CHAR "<<yytext<<endl;
	error_count++;
}





			

%%
/* 
int yywrap(void)
{
	return 1;
} */

/* int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	

	logFileOutput.open("2005017_log.txt");
	tokelFileOutput.open("2005017_token.txt");

	yyin= fin;
	yylex();
	fclose(yyin);

	logFileOutput.close();
	tokelFileOutput.close();

	return 0;
} 
*/