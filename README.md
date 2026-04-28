# KoloTV

## Documentation technique

- [Specification technique - Chiffre d'affaire publicitaire et majoration de diffusion](technical-specification.md)



## Configuration

Avant de lancer le projet, copiez et renommez les fichiers d'exemple fournis et ajustez les paramètres sensibles :

- Copiez `kolotv-ejb/src/java/apj.properties.exemple` vers `kolotv-ejb/src/java/apj.properties` et mettez à jour les informations de connexion à la base de données.
- Copiez `reset-dtb.bat.exemple` vers `reset-dtb.bat`.
- Si nécessaire, copiez `build.xml.exemple` vers `build.xml` à la racine du projet.

Ces fichiers ne doivent pas être committés (ils sont listés dans `.gitignore`).

## Guide de lancement (Linux)

### Prérequis

- Docker
- Java 8 (JDK)
- Ant
- WildFly 10
- Oracle Database

### 1. Installer Java 8 et Ant

```bash
sudo apt update
sudo apt install -y openjdk-8-jdk ant unzip wget
```

Vérifier :

```bash
which ant
ant -version
java -version
```

Sélectionner Java 8 si plusieurs versions sont installées :

```bash
sudo update-alternatives --config java
sudo update-alternatives --config javac
```

### 2. Installer WildFly 10

```bash
cd /opt
sudo wget https://download.jboss.org/wildfly/10.0.0.Final/wildfly-10.0.0.Final.zip
sudo unzip wildfly-10.0.0.Final.zip
sudo mv wildfly-10.0.0.Final wildfly-10
sudo chown -R $USER:$USER /opt/wildfly-10
```

Configurer l'environnement dans `~/.bashrc` :

```bash
export JBOSS_HOME=/opt/wildfly-10
export PATH=$PATH:$JBOSS_HOME/bin
```

Recharger :

```bash
source ~/.bashrc
```

Vérifier :

```bash
echo $JBOSS_HOME
ls -la $JBOSS_HOME
$JBOSS_HOME/bin/standalone.sh --version
```

### 3. Préparer Oracle

Le projet attend une base Oracle accessible depuis `apj.properties`.

Commande SQL*Plus type :

```bash
sqlplus utilisateur/motdepasse@//localhost:1521/MYPDB
```

Si tu utilises Oracle en Docker, tu peux reprendre le principe suivant :

```bash
docker login container-registry.oracle.com
docker pull container-registry.oracle.com/database/enterprise:21.3.0.0
```

Puis lancer un conteneur Oracle :

```bash
docker run -d \
  --name oracle-db \
  --hostname mydb \
  --domainname mydocker.com \
  -p 1521:1521 \
  -p 5500:5500 \
  -e ORACLE_SID=MYCDB \
  -e ORACLE_PDB=MYPDB \
  -e ORACLE_PWD=oracle123 \
  -e ORACLE_EDITION=ee \
  -e ENABLE_ARCHIVELOG=true \
  -v OracleDBData:/opt/oracle/oradata \
  container-registry.oracle.com/database/enterprise:21.3.0.0
```

Connexion SYS :

```bash
docker exec -it oracle-db sqlplus sys/oracle123@//localhost:1521/MYCDB as sysdba
```

Création d'un utilisateur applicatif :

```sql
ALTER SESSION SET CONTAINER=MYPDB;
CREATE USER kolotv IDENTIFIED BY "kolotv";
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE TRIGGER TO kolotv;
GRANT UNLIMITED TABLESPACE TO kolotv;
```

### 4. Configurer `apj.properties`

Fichier à préparer :

- `kolotv-ejb/src/java/apj.properties`

Exemple :

```properties
apj.connection.url=jdbc:oracle:thin:@//localhost:1521/MYPDB
apj.connection.user=kolotv
apj.connection.password=kolotv
```

Tester la connexion :

```bash
sqlplus kolotv/kolotv@//localhost:1521/MYPDB
```

### 5. Import SQL minimal à faire

Avant de lancer l'application, importer au minimum :

- `debug.sql`
- `bdd/2026/2026-02-05-majoration-diffusion.sql`
- `bdd/2026/2026-02-05-majoration-diffusion-minoration.sql`

Exemple :

```bash
sqlplus kolotv/kolotv@//localhost:1521/MYPDB @debug.sql
sqlplus kolotv/kolotv@//localhost:1521/MYPDB @bdd/2026/2026-02-05-majoration-diffusion.sql
sqlplus kolotv/kolotv@//localhost:1521/MYPDB @bdd/2026/2026-02-05-majoration-diffusion-minoration.sql
```

Utilité de ces scripts :

- `debug.sql` : script de base à importer pour l'environnement du projet.
- `2026-02-05-majoration-diffusion.sql` : crée la table `MAJORATION_DIFFUSION`, sa séquence et la fonction `GETSEQ_MAJORATION_DIFFUSION`.
- `2026-02-05-majoration-diffusion-minoration.sql` : ajuste la contrainte de variation.

Pour les écrans :

- `reservation/majoration-diffusion-liste.jsp` dépend directement de `MAJORATION_DIFFUSION`.
- `reservation/chiffre-affaire-publicite-calendrier.jsp` dépend de `MAJORATION_DIFFUSION` et aussi des données métier déjà présentes dans `RESERVATIONDETAILS_DIFFUSION`.

Donc pour que la page `Grille CA publicitaire` fonctionne, il faut :

- importer les scripts de majoration ci-dessus,
- avoir déjà le schéma métier principal du projet importé dans Oracle.

### 6. Réglages JVM WildFly

Ajouter au démarrage de WildFly :

```bash
JAVA_OPTS="$JAVA_OPTS -Duser.language=fr"
JAVA_OPTS="$JAVA_OPTS -Duser.country=FR"
JAVA_OPTS="$JAVA_OPTS -Duser.timezone=Europe/Paris"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
```

Ces options forcent :

- la langue en français,
- le pays en France,
- le fuseau horaire `Europe/Paris`,
- l'encodage par défaut en `UTF-8`.

### 7. Build et déploiement

Le build principal se fait avec le `build.xml` racine.

Commande :

```bash
ant -f build.xml
```

Le déploiement utilise :

```xml
<property name="deploy.dir" value="/opt/wildfly-10/standalone/deployments"/>
```

Le build copie une application exploded `kolotv.war` dans WildFly.

### 8. Démarrage de WildFly

```bash
$JBOSS_HOME/bin/standalone.sh
```

Accès :

- application : <http://localhost:8080/kolotv/>
- page d'entrée : <http://localhost:8080/kolotv/index.jsp>
- console WildFly : <http://localhost:9990/>

### 9. Point d'attention sur le build

Le `build.xml` racine utilise :

- `basedir="./build-file"`
- les bibliothèques sous `build-file/lib`

Si `build-file` ou ses JAR manquent, la compilation Ant échouera.

### 10. Vérification après déploiement

Si un doute subsiste sur le problème historique `jboss-client.jar`, vérifier :

```bash
find /opt/wildfly-10/standalone/deployments/kolotv.war/WEB-INF/lib -name "jboss-client.jar"
```

Cette commande ne doit rien retourner.

## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/topics/git/add_files/#add-files-to-a-git-repository) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/bici-mada/kolotv.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/bici-mada/kolotv/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/user/project/merge_requests/auto_merge/)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
---

## Note de dépannage WildFly

### Problème rencontré

Lors du déploiement de `kolotv.war` sur WildFly 10, le serveur peut échouer avec une erreur du type :

```text
DuplicateServiceException: Service jboss.pojo."org.jboss.netty.internal.LoggerConfigurator".DESCRIBED is already registered
```

On peut aussi voir dans les logs :

```text
WFLYPOJO0001: Found legacy bean/pojo namespace: urn:jboss:bean-deployer:2.0
```

### Cause identifiée

Le fichier `jboss-client.jar` embarqué dans `WEB-INF/lib` contenait un descripteur legacy `META-INF/jboss-beans.xml`.

WildFly lisait ce fichier au déploiement et essayait d'enregistrer un ancien composant JBoss/Netty :

```text
org.jboss.netty.internal.LoggerConfigurator
```

Cela provoquait un doublon de service et faisait échouer l'installation de `kolotv.war`.

### Solution appliquée

Supprimer `jboss-client.jar` du `WAR` a corrigé le problème.

Test manuel qui a confirmé le diagnostic :

```bash
rm /opt/wildfly-10/standalone/deployments/kolotv.war/WEB-INF/lib/jboss-client.jar
rm -f /opt/wildfly-10/standalone/deployments/kolotv.war.failed
touch /opt/wildfly-10/standalone/deployments/kolotv.war.dodeploy
```

### Correction durable

Retirer `build-file/lib/jboss-client.jar` du processus de build de `kolotv-war`, sinon le problème reviendra au prochain packaging.

### Réglages JVM ajoutés

Pour stabiliser l'environnement d'exécution, les options suivantes ont aussi été ajoutées :

```bash
JAVA_OPTS="$JAVA_OPTS -Duser.language=fr"
JAVA_OPTS="$JAVA_OPTS -Duser.country=FR"
JAVA_OPTS="$JAVA_OPTS -Duser.timezone=Europe/Paris"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
```

Ces options forcent :

- la langue en français,
- le pays en France,
- le fuseau horaire `Europe/Paris`,
- l'encodage par défaut en `UTF-8`.

Si une anomalie d'affichage, de dates ou d'encodage réapparaît selon la machine ou l'utilisateur, vérifier en priorité que ces options sont bien appliquées au démarrage de WildFly.

### Commande utile pour diagnostiquer à nouveau ce cas

```bash
find /opt/wildfly-10/standalone/deployments/kolotv.war/WEB-INF/lib -name "*.jar" -exec sh -c '
for j do
  if jar tf "$j" 2>/dev/null | grep -q "META-INF/jboss-beans.xml"; then
    echo "=== $j ==="
    jar tf "$j" | grep "META-INF/jboss-beans.xml"
  fi
done
' sh {} +
```
