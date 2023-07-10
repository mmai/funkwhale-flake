#!/bin/sh

# Récupère une version spécifique des sources Funkwhale
# permet de comparer les fichiers de dépendances et déploiement
# ex pour dépendances python :
#   ./fetchFunkwhaleCode.sh 1.3.1
#   grep "name\|^version =" funkwhale_upstream_1.3.1/api/poetry.lock > docs/pythonDeps_1.3.1.txt
#   diff docs/pythonDeps_1.2.9.txt docs/pythonDeps_1.3.1.txt
# pour évolutions déploiement :
#   meld funkwhale_upstream_1.2.9/deploy/ funkwhale_upstream_1.3.1/deploy/

VERSION=$1 # ex: 1.2.7
REPO_PATH="./funkwhale_upstream_$VERSION/"

[ ! -d $REPO_PATH ] && git clone https://dev.funkwhale.audio/funkwhale/funkwhale.git $REPO_PATH
cd $REPO_PATH

echo "Fetching develop commit for $VERSION"
git checkout develop && git pull
COMMIT=$(git log --reverse --ancestry-path $VERSION..develop --oneline | head -1 | awk '{print $1}')
echo $COMMIT
git checkout $COMMIT

# affiche les versions des packages python
grep "name\|^version =" api/poetry.lock

cd -
