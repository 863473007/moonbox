grammar MqlBase;

tokens {
    DELIMITER
}

single
    : mql EOF
    ;

mql
    : CREATE (ORG|ORGANIZATION) (IF NOT EXISTS)? name=identifier (COMMENT comment=STRING)?      # createOrganization
    | RENAME (ORG|ORGANIZATION) name=identifier TO newName=identifier                           # renameOrganization
    | ALTER (ORG|ORGANIZATION) name=identifier RENAME TO newName=identifier                     # setOrganizationName
    | ALTER (ORG|ORGANIZATION) name=identifier SET COMMENT comment=STRING                       # setOrganizationComment
    | DROP (ORG|ORGANIZATION) (IF EXISTS)? name=identifier (CASCADE)?                           # dropOrganization

    | CREATE SA (IF NOT EXISTS)? name=identifier IN (ORG|ORGANIZATION)
        org=identifier IDENTIFIED BY pwd=password                                               # createSa
    | RENAME SA name=identifier IN (ORG|ORGANIZATION) org=identifier TO newName=identifier      # renameSa
    | ALTER SA name=identifier IN (ORG|ORGANIZATION) org=identifier
        RENAME TO newName=identifier                                                            # setSaName
    | ALTER SA name=identifier IN (ORG|ORGANIZATION) org=identifier
        IDENTIFIED BY pwd=password                                                              # setSaPassword
    | DROP SA (IF EXISTS)? name=identifier IN (ORG|ORGANIZATION) org=identifier                 # dropSa

    | GRANT GRANT OPTION privilegeList TO USER users=identifierList                             # grantGrantToUser
    | GRANT GRANT OPTION privilegeList TO GROUP groups=identifierList                           # grantGrantToGroup
    | REVOKE GRANT OPTION privilegeList FROM USER users=identifierList                          # revokeGrantFromUser
    | REVOKE GRANT OPTION privilegeList FROM GROUP groups=identifierList                        # revokeGrantFromGroup

    | GRANT ACCOUNT TO USER users=identifierList                                                # grantAccountToUsers
    | GRANT ACCOUNT TO GROUP groups=identifierList                                              # grantAccountToGroups
    | REVOKE ACCOUNT FROM USER users=identifierList                                             # revokeAccountFromUsers
    | REVOKE ACCOUNT FROM GROUP groups=identifierList                                           # revokeAccountFromGroups

    | GRANT DDL TO USER users=identifierList                                                    # grantDdlToUsers
    | GRANT DDL TO GROUP groups=identifierList                                                  # grantDdlToGroups
    | REVOKE DDL FROM USER users=identifierList                                                 # revokeDdlFromUsers
    | REVOKE DDL FROM GROUP groups=identifierList                                               # revokeDdlFromGroups

    | GRANT DML ON qualifiedColumnList TO USER users=identifierList                             # grantDmlOnToUsers
    | GRANT DML ON qualifiedColumnList TO GROUP groups=identifierList                           # grantDmlOnToGroups
    | REVOKE DML ON qualifiedColumnList FROM USER users=identifierList                          # revokeDmlOnFromUsers
    | REVOKE DML ON qualifiedColumnList FROM GROUP groups=identifierList                        # revokeDmlOnFromGroups

    | CREATE USER (IF NOT EXISTS)? name=identifier IDENTIFIED BY pwd=password                   # createUser
    | RENAME USER name=identifier TO newName=identifier                                         # renameUser
    | ALTER USER name=identifier RENAME TO newName=identifier                                   # setUserName
    | ALTER USER name=identifier IDENTIFIED BY pwd=password                                     # setUserPassword
    | DROP USER (IF EXISTS)? name=identifier                                                    # dropUser

    | CREATE GROUP (IF NOT EXISTS)? name=identifier (COMMENT comment=STRING)?                   # createGroup
    | RENAME GROUP name=identifier TO newName=identifier                                        # renameGroup
    | ALTER GROUP name=identifier RENAME TO newName=identifier                                  # setGroupName
    | ALTER GROUP name=identifier SET COMMENT comment=STRING                                    # setGroupComment
    | ALTER GROUP name=identifier addUser (removeUser)?                                         # addUsersToGroup
    | ALTER GROUP name=identifier removeUser (addUser)?                                         # removeUsersFromGroup
    | DROP GROUP (IF EXISTS)? name=identifier (CASCADE)?                                        # dropGroup

    | MOUNT DATASOURCE (IF NOT EXISTS)? name=identifier OPTIONS propertyList                    # mountDatasource
    | RENAME DATASOURCE name=identifier TO newName=identifier                                   # renameDatasource
    | ALTER DATASOURCE name=identifier RENAME TO newName=identifier                             # setDatasourceName
    | ALTER DATASOURCE name=identifier SET OPTIONS propertyList                                 # setDatasourceProperties
    | UNMOUNT DATASOURCE (IF EXISTS)? name=identifier                                           # unmountDatasource

    | MOUNT STREAM? TABLE (IF NOT EXISTS)? tableIdentifier ('('columns=colTypeList')')?
        OPTIONS propertyList                                                                    # mountTable
    | WITH DATASOURCE ds=identifier MOUNT (STREAM)? TABLE (IF NOT EXISTS)?  mountTableList      # mountTableWithDatasource
    | RENAME TABLE name=tableIdentifier TO newName=tableIdentifier                              # renameTable
    | ALTER TABLE name=tableIdentifier RENAME TO newName=tableIdentifier                        # setTableName
    | ALTER TABLE name=tableIdentifier SET OPTIONS propertyList                                 # setTableProperties
    | ALTER TABLE name=tableIdentifier ADD COLUMNS ('(' columns=colTypeList ')')                # addTableColumns
    | ALTER TABLE name=tableIdentifier CHANGE COLUMN? identifier colType                        # changeTableColumn
    | ALTER TABLE name=tableIdentifier DROP COLUMN identifier                                   # dropTableColumn
    | UNMOUNT TABLE (IF EXISTS)? name=tableIdentifier                                           # unmountTable

    | CREATE DATABASE (IF NOT EXISTS)? name=identifier (COMMENT comment=STRING)?                # createDatabase
    | RENAME DATABASE name=identifier TO newName=identifier                                     # renameDatabase
    | ALTER DATABASE name=identifier RENAME TO newName=identifier                               # setDatabaseName
    | ALTER DATABASE name=identifier SET COMMENT comment=STRING                                 # setDatabaseComment
    | DROP DATABASE (IF EXISTS)? name=identifier (CASCADE)?                                     # dropDatabase
    | USE db=identifier                                                                         # useDatabase

    | CREATE (TEMP | TEMPORARY)? FUNCTION (IF NOT EXISTS)? name=funcIdentifier
        AS className=STRING (methodName=STRING)? (USING resource (',' resource)*)?              # createFunction
    | DROP (TEMP | TEMPORARY)? FUNCTION (IF EXISTS)? name=funcIdentifier                        # dropFunction

    | CREATE VIEW (IF NOT EXISTS)? name=tableIdentifier (COMMENT comment=STRING)? AS query      # createView
    | RENAME VIEW name=tableIdentifier TO newName=tableIdentifier                               # renameView
    | ALTER VIEW name=tableIdentifier RENAME TO newName=tableIdentifier                         # setViewName
    | ALTER VIEW name=tableIdentifier SET COMMENT comment=STRING                                # setViewComment
    | ALTER VIEW name=tableIdentifier AS query                                                  # setViewQuery
    | DROP VIEW (IF EXISTS)? name=tableIdentifier                                               # dropView

    | CREATE APPLICATION (IF NOT EXISTS)? name=identifier AS appCmds                            # createApplication
    | RENAME APPLICATION name=identifier TO newName=identifier                                  # renameApplication
    | ALTER APPLICATION name=identifier RENAME TO newName=identifier                            # setApplicationName
    | ALTER APPLICATION name=identifier AS appCmds                                              # setApplicationQuerys
    | DROP APPLICATION (IF EXISTS)? name=identifier                                             # dropApplication

    | CREATE (DEFINER definer)? EVENT (IF NOT EXISTS)? name=identifier ON SCHEDULE AT schedule
        (ENABLE | DISABLE)? (COMMENT comment=STRING)? DO CALL app=identifier                    # createEvent
    | RENAME EVENT name=identifier TO newName=identifier                                        # renameEvent
    | ALTER DEFINER definer EVENT name=identifier                                               # setDefiner
    | ALTER EVENT name=identifier RENAME TO newName=identifier                                  # setEventName
    | ALTER EVENT name=identifier ON SCHEDULE AT schedule                                       # setEventSchedule
    | ALTER EVENT name=identifier (ENABLE | DISABLE)                                            # setEventEnable
    | DROP EVENT (IF EXISTS)? name=identifier                                                   # dropEvent

    | SHOW SYSINFO                                                                              # showSysInfo
    | SHOW DATASOURCES (LIKE pattern=STRING)?                                                   # showDatasources
    | SHOW DATABASES (LIKE pattern=STRING)?                                                     # showDatabase
    | SHOW TABLES ((FROM | IN) db=identifier)? (LIKE pattern=STRING)?                           # showTables
    | SHOW VIEWS ((FROM | IN) db=identifier)? (LIKE pattern=STRING)?                            # showViews
    | SHOW FUNCTIONS ((FROM | IN) db=identifier)? (LIKE pattern=STRING)?                        # showFunctions
    | SHOW USERS (LIKE pattern=STRING)?                                                         # showUsers
    | SHOW GROUPS (LIKE pattern=STRING)?                                                        # showGroups
    | SHOW APPLICATIONS (LIKE pattern=STRING)?                                                  # showApplications

    | (DESC | DESCRIBE) DATASOURCE EXTENDED? name=identifier                                    # descDatasource
    | (DESC | DESCRIBE) DATABASE name=identifier                                                # descDatabase
    | (DESC | DESCRIBE) TABLE EXTENDED? tableIdentifier                                         # descTable
    | (DESC | DESCRIBE) VIEW tableIdentifier                                                    # descView
    | (DESC | DESCRIBE) FUNCTION EXTENDED? funcIdentifier                                       # descFunction
    | (DESC | DESCRIBE) USER name=identifier                                                    # descUser
    | (DESC | DESCRIBE) GROUP name=identifier                                                   # descGroup

    | EXPLAIN EXTENDED? PLAN? query                                                             # explain
    | SET property                                                                              # setConfiguration

    | INSERT (INTO | OVERWRITE) TABLE? tableIdentifier AS? query                                # insertInto
    | CREATE (OR REPLACE)? CACHE? (TEMP | TEMPORARY) VIEW name=identifier AS query              # createTemporaryView
    | query                                                                                     # mqlQuery
    ;

appCmds
    : mql (';' mql)*
    ;
definer
    : EQ? (user = identifier | CURRENT_USER)
    ;

schedule
    : starOrInteger starOrInteger starOrInteger starOrInteger starOrInteger starOrInteger
    ;
starOrInteger
    : STAR | INTEGER_VALUE
    ;

query
    : SELECT (~';')*
    | ctes SELECT (~';')*
    ;
ctes
    : WITH namedQuery (',' namedQuery)*
    ;


dataType
    : complex=ARRAY '<' dataType '>'                            #complexDataType
    | complex=MAP '<' dataType ',' dataType '>'                 #complexDataType
    | complex=STRUCT ('<' complexColTypeList? '>' | NEQ)        #complexDataType
    | identifier ('(' INTEGER_VALUE (',' INTEGER_VALUE)* ')')?  #primitiveDataType
    ;

colTypeList
    : colType (',' colType)*
    ;

colType
    : identifier dataType
    ;

complexColTypeList
    : complexColType (',' complexColType)*
    ;

complexColType
    : identifier ':' dataType
    ;

namedQuery
    : name=identifier AS? '(' query ')'
    ;

mountTableList
    : mountTableOptions (',' mountTableOptions)*
    ;
mountTableOptions
    : tableIdentifier ('(' columns=colTypeList ')')? OPTIONS propertyList
    ;

privilegeList
    :  privilege (',' privilege)*
    ;

privilege
    : ACCOUNT
    | DDL
    | DMLON
    ;

qualifiedColumnList
    : columnIdentifier (',' columnIdentifier)*
    ;

columnIdentifier
    : (db=identifier '.')? table=identifierStarList '.' colunm=identifierStarList
    ;

identifierStarList
    : '[' identifier (',' identifier)* ']'
    | '{' identifier (',' identifier)* '}'
    | identifier
    | STAR
    ;

addUser
    : ADD USER identifierList
    ;

removeUser
    : REMOVE USER identifierList
    ;

identifierList
    : identifier (',' identifier)*
    ;

funcIdentifier
    : (db=identifier '.')? func=identifier
    ;

tableIdentifier
    : (db=identifier '.')? table=identifier
    ;

propertyList
    : '(' property (',' property)* ')'
    ;

property
    : key=propertyKey (EQ? value=STRING)?
    ;

propertyKey
    : identifier ('.' identifier)*
    | STRING
    ;

password
    : (.)*?
    ;

identifier
    : IDENTIFIER
    | nonReserved
    ;


resource
    : identifier STRING
    ;

nonReserved
    : ARRAY | SHOW | TABLES | TABLE | COLUMNS | COLUMN | FUNCTIONS | DATABASES | FUNCTION | DATABASE | DATASOURCES | DATASOURCE
    | ADD | REMOVE | GRANT | REVOKE
    | ALTER | RENAME | TO | SET
    | USER | TYPE | DATABASE | DATASOURCE| AS | SA | ORG | GROUP | GROUPS | VIEW | VIEWS | ACCOUNT
    | APPLICATION | APPLICATIONS
    | CASCADE | CACHE
    | WITH
    ;

ACCOUNT: 'ACCOUNT';
ADD: 'ADD';
ALTER: 'ALTER';
APPLICATION: 'APPLICATION';
APPLICATIONS: 'APPLICATIONS';
ARRAY: 'ARRAY';
AT: 'AT';
MAP: 'MAP';
STRUCT: 'STRUCT';
AS: 'AS';
BY: 'BY';
CACHE: 'CACHE';
CALL: 'CALL';
CASCADE: 'CASCADE';
COLUMN: 'COLUMN';
COLUMNS: 'COLUMNS';
COMMENT: 'COMMENT';
CHANGE: 'CHANGE';
CREATE: 'CREATE';
CURRENT_USER: 'CURRENT_USER';
DATABASE: 'DATABASE';
DATABASES: 'DATABASES';
DATASOURCE: 'DATASOURCE';
DATASOURCES: 'DATASOURCES';
DDL: 'DDL';
DEFINER: 'DEFINER';
DESC: 'DESC';
DESCRIBE: 'DESCRIBE';
DISABLE: 'DISABLE';
DO: 'DO';
DML: 'DML';
DMLON: 'DMLON';
DROP: 'DROP';
ENABLE: 'ENABLE';
EQ: '=' | '==';
NEQ: '<>';
EVENT: 'EVENT';
EXISTS: 'EXISTS';
EXPLAIN: 'EXPLAIN';
EXTENDED: 'EXTENDED';
FROM: 'FROM';
FUNCTION: 'FUNCTION';
FUNCTIONS: 'FUNCTIONS';
GRANT: 'GRANT';
GROUP: 'GROUP';
GROUPS: 'GROUPS';
IDENTIFIED : 'IDENTIFIED ';
IF: 'IF';
IN: 'IN';
INSERT: 'INSERT';
INTO: 'INTO';
LIKE: 'LIKE';
MOUNT: 'MOUNT';
NOT: 'NOT';
ON: 'ON';
OPTION: 'OPTION';
OPTIONS: 'OPTIONS';
OR: 'OR';
ORG: 'ORG';
ORGANIZATION: 'ORGANIZATION';
OVERWRITE: 'OVERWRITE';
PLAN: 'PLAN';
REMOVE: 'REMOVE';
RENAME: 'RENAME';
REPLACE: 'REPLACE';
REVOKE: 'REVOKE';
SA: 'SA';
SCHEDULE: 'SCHEDULE';
SELECT: 'SELECT';
SET: 'SET';
SHOW: 'SHOW';
STAR: '*';
STREAM: 'STREAM';
SYSINFO: 'SYSINFO';
TABLE: 'TABLE';
TABLES: 'TABLES';
TEMP: 'TEMP';
TEMPORARY: 'TEMPORARY';
TO: 'TO';
TYPE: 'TYPE';
UNMOUNT: 'UNMOUNT';
USE: 'USE';
USING: 'USING';
USER: 'USER';
USERS: 'USERS';
VIEW: 'VIEW';
VIEWS: 'VIEWS';
WITH: 'WITH';


STRING
    : '\'' ( ~('\''|'\\') | ('\\' .) )* '\''
    | '"' ( ~('"'|'\\') | ('\\' .) )* '"'
    ;

INTEGER_VALUE
        : DIGIT+
        ;

IDENTIFIER
    : (LETTER | DIGIT | '_' )+
    | '\'' (LETTER | DIGIT | '_' )+ '\''
    | '"' (LETTER | DIGIT | '_' )+ '"'
    ;



fragment DIGIT
    : [0-9]
    ;

fragment LETTER
    : [A-Z]
    | [a-z]
    ;

SIMPLE_COMMENT
    : '--' ~[\r\n]* '\r'? '\n'? -> channel(HIDDEN)
    ;

BRACKETED_COMMENT
    : '/*' .*? '*/' -> channel(HIDDEN)
    ;

WS
    : [ \b\r\n\t]+ -> channel(HIDDEN)
    ;

UNRECOGNIZED
    : .
    ;