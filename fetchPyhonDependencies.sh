#!/bin/sh

# utile uniquement pour regarder les versions des packages python dans api/poetry.lock

VERSION=$1 # ex: 1.2.7
REPO_PATH="./funkwhale_upstream/"

[ ! -d $REPO_PATH ] && git clone https://dev.funkwhale.audio/funkwhale/funkwhale.git $REPO_PATH
cd $REPO_PATH

echo "Fetching develop commit for $VERSION"
git checkout develop && git pull
COMMIT=$(git log --reverse --ancestry-path $VERSION..develop --oneline| head -1 | awk '{print $1}')
echo $COMMIT
git checkout $COMMIT

cd - 
