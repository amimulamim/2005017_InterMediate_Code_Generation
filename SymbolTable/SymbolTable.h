#include"scopeTable.h"

class SymbolTable{

    private:
        ScopeTable* current;
        int total_buckets;
        int counter;

        bool isEmpty(){
            return current==nullptr;
        }



    public:
        SymbolTable(int n){
            total_buckets=n;
            current = new ScopeTable(n);
            counter = 1;
            string id=to_string(counter);
            current->setId(id);
            //cout<<"\t"<<"ScopeTable# "<<1 <<" created"<<endl;
        }
        ~SymbolTable(){
            exitAll();
        }
        bool enterScope(){
            ScopeTable* newScopeTable = new ScopeTable(total_buckets);
            //string newid=current->generateNewChildId();
            counter++;
            string newid = to_string(counter);
            newScopeTable->setId(newid);
            newScopeTable->setParent(current);
            current->incrementChildrenCount(); 
            current=newScopeTable;
            //cout<<"\t"<<"ScopeTable# "<<current->getId() <<" created"<<endl;
            return true;
        }

        bool exitScope(){
            if(isEmpty() || current->getParent()==nullptr){
                // //cout<<"\t"<<"ScopeTable# 1 cannot be deleted"<<endl;
                return false;
            }
            ScopeTable* temp=current;
            current=current->getParent();
            //cout<<"\t"<<"ScopeTable# "<<temp->getId()<<" deleted"<<endl;
            delete temp;
            
            return true;

        }

        bool exitAll(){
            if(isEmpty())return false;

           while(current->getParent()!=nullptr){
                exitScope();
           }
           //cout<<"\t"<<"ScopeTable# "<<current->getId()<<" deleted"<<endl;
            delete current;
            return true;





        }

        ScopeTable* getCurrent(){
            return current;
        }

        bool insert(string name,string type){
            return current->insert(name,type);
        }
        bool insert(SymbolInfo* info){
            return current->insert(info);
        }
        bool remove(string name){
            return current->remove(name);


        }
       bool replace(SymbolInfo* info){
            ScopeTable* temp=current;
            while(temp!=nullptr){


                bool replaced=temp->replace(info);
                if(replaced)return true;
                temp=temp->getParent();
            }
            return false;



       }

        SymbolInfo* lookUp(string name){
            ScopeTable* temp=current;
            while(temp!=nullptr){
                SymbolInfo* info=temp->lookup(name);
                if(info!=nullptr){return info;}
                temp=temp->getParent();
            }
            return nullptr;
        }
         SymbolInfo* lookUp(string name,string& scopeId,int& index,int& position){
            ScopeTable* temp=current;
            while(temp!=nullptr){
                SymbolInfo* got=temp->lookup(name,index,position);
                if(got!=nullptr){
                    scopeId=temp->getId();
                    
                    return got;
                   // return temp->lookup(name);
                    
                    }
                temp=temp->getParent();
            }
            return nullptr;
        }
        void printCurrent(ofstream& output){
            current->print(output);
        };

        void printAll(ofstream& output){
            ScopeTable* temp=current;
            while(temp!=nullptr){
                temp->print(output);
                temp=temp->getParent();
            }
        };
        vector<SymbolInfo*> getSymbols(){
            return current->getSymbols();
        }




};