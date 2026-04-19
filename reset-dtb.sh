#!/usr/bin/env bash
set -euo pipefail

# -------------------------------
# Configuration
# -------------------------------
ORACLE_SID="EE.oracle.docker"
SYS_USER="oracle"
SYS_PWD="Dbamanager1"
SOC_USER="kolo0107"
SOC_PWD="kolo0107"
DMP_FILE="./kolo0107.dmp"
LOG_FILE="./kolo0107.log"

printf "===========================================\n"
printf " RESET DU SCHEMA %s SUR ORACLE\n" "$SOC_USER"
printf "===========================================\n"

# -------------------------------
# 1. Suppression de l'utilisateur
# -------------------------------
cat > drop_user.sql <<SQL
DROP USER $SOC_USER CASCADE;
EXIT;
SQL

echo "[1/4] Suppression de l'utilisateur $SOC_USER..."
sqlplus "$SYS_USER/$SYS_PWD@$ORACLE_SID" AS SYSDBA @drop_user.sql

# -------------------------------
# 2. Création du nouvel utilisateur
# -------------------------------
cat > create_user.sql <<SQL
CREATE USER $SOC_USER IDENTIFIED BY $SOC_PWD DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP ACCOUNT UNLOCK;
GRANT CONNECT, RESOURCE, DBA TO $SOC_USER;
EXIT;
SQL

echo "[2/4] Création du nouvel utilisateur..."
sqlplus "$SYS_USER/$SYS_PWD@$ORACLE_SID" AS SYSDBA @create_user.sql

# -------------------------------
# 3. Import du dump
# -------------------------------
echo "[3/4] Import du dump $DMP_FILE..."
imp "$SOC_USER/$SOC_PWD@$ORACLE_SID" file="$DMP_FILE" log="$LOG_FILE" FULL=Y

# -------------------------------
# Nettoyage des fichiers temporaires
# -------------------------------
rm -f drop_user.sql create_user.sql

echo "[4/4] Réinitialisation terminée !"
