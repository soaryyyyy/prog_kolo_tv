cd socobis-prod

ant -f build.xml clean

ant -f build.xml -Ddeploy.dir="C:/wildfly-10.0.0.Final/wildfly-10.0.0.Final/standalone/deployments" deploy

cd "C:\wildfly-10.0.0.Final\wildfly-10.0.0.Final\bin"
standalone.bat


@REM SOCOBISPROD :

@REM sqlplus / as sysdba
@REM    
@REM CREATE OR REPLACE DIRECTORY SOCODIR AS 'C:/oracle_dumps';

@REM GRANT READ, WRITE ON DIRECTORY SOCODIR TO socobisprod;
@REM ALTER USER system IDENTIFIED BY system123;
@REM EXIT;

@REM jboss-cli.bat --connect
@REM /subsystem=datasources/jdbc-driver=oracle:read-resource
@REM /subsytem=datasources/data-source=SocobisDS:test-connection-in-pool

@REM # Utiliser un dossier temporaire ou un autre emplacement
@REM imp system/system123@//localhost:1521/orcl file=C:/oracle_dumps/socobis_20251107.dmp log=C:/temp/import_socobis.log fromuser=socobis touser=socobisprod


@REM sqlplus / as sysdba
@REM sqlplus socobisprod/socobisprod
@REM -- Tables de l'utilisateur courant
@REM SELECT table_name FROM user_tables;

@REM -- Toutes les tables accessibles à l'utilisateur
@REM SELECT table_name FROM all_tables;

@REM -- Toutes les tables de la base (nécessite privilèges DBA)
@REM SELECT table_name FROM dba_tables;




@REM asyncsocobis :
@REM sqlplus / as sysdba
@REM sqlplus asyncsocobis/asyncsocobis

@REM CREATE OR REPLACE DIRECTORY SOCODIR AS 'C:/oracle_dumps';
@REM GRANT READ, WRITE ON DIRECTORY SOCODIR TO socobisprod;
@REM ALTER USER system IDENTIFIED BY system123;
@REM EXIT;



@REM mot de passe pao crypter :test->paop





////// 

create user socobis identified by socobis;

grant dba to socobis;


imp socobis/socobis file=socobis_20251107.dmp full=y

ant