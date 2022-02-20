SERVICE=$1
STABLE=$2
GIT=$3

mkdir -p service

if [ -d "/service/$SERVICE" ]; then
    cd service/$SERVICE
    git pull
else
    git clone $GIT service/$SERVICE
    cd service/$SERVICE

    if [ $STABLE = "true" ]; then
        git chekcout release
    fi
fi

./deploy.sh

cd ../../
