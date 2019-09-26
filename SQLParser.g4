// Define a grammar called Hello
grammar SQLParser;

program: (query | command)+;

query: relationName '<-' expr;
relationName: IDENTIFIER;
attributeName: IDENTIFIER;

expr:
    atomicExpr
    | 'select (' condition ')' atomicExpr //selection
    | 'project (' attributeList ')' atomicExpr //projection
    | 'rename (' attributeList ')' atomicExpr //renaming
    | atomicExpr '+' atomicExpr //union
    | atomicExpr '-' atomicExpr //difference
    | atomicExpr '*' atomicExpr //product
    | atomicExpr '&' atomicExpr; //naturaljoin
condition: conjunction ('||' conjunction)*;
conjunction: comparison ('&&' comparison)*;
comparison: operand OP operand | '(' condition ')';
operand: attributeName | literal;
attributeList: attributeName (', ' attributeName)*;

atomicExpr: relationName | '(' expr ')' ;

command  : ( openCmd | closeCmd | writeCmd | exitCmd | showCmd | createCmd | updateCmd | insertCmd | deleteCmd ) ;
openCmd  : 'OPEN ' relationName;
closeCmd : 'CLOSE ' relationName;
writeCmd : 'WRITE ' relationName;
exitCmd : 'EXIT';
showCmd : 'SHOW ' atomicExpr;
createCmd: 'CREATE TABLE ' relationName ' (' typedAttributeList ') PRIMARY KEY (' attributeList ')';
updateCmd: 'UPDATE ' relationName ' SET ' attributeName '=' literal (',' attributeName '=' literal)* ' WHERE' condition;
insertCmd: 'INSERT INTO ' relationName ' VALUES FROM ' ('(' literal (',' literal)*')' | 'RELATION ' expr);
deleteCmd: 'DELETE FROM ' relationName ' WHERE ' condition;
typedAttributeList:  attributeName type (',' attributeName type)*;
type: 'VARCHAR(' INTEGER ')' | 'INTEGER';
literal: STRING_LITERAL | INTEGER;


IDENTIFIER: ALPHA (ALPHA | DIGIT)*;
OP: ('==' | '!=' | '<' | '>' | '<=' | '>=');
INTEGER: (DIGIT)+;
ALPHA: [a-zA-Z_];
DIGIT: [0-9];
STRING_LITERAL : '"' (ALPHA | DIGIT)+ '"';


WS: [ \n\t\r]+ -> skip;