SERVICE=$1
STABLE=$2
GIT=$3

mkdir -p service

if [ -d "service/$SERVICE" ]; then
    cd service/$SERVICE
    git pull
else
    git clone $GIT service/$SERVICE
    cd service/$SERVICE
fi

if [ $STABLE = "true" ]; then
    git checkout release
else
    git checkout master
fi

./deploy.sh

if [ $? -ne 0 ]; then
    exit 1
fi
