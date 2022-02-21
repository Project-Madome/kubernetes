SVC=$1
BRANCH=$2
GIT=$3
UPDATE=$4

mkdir -p service

if [ -d "service/$SVC" ]; then
    cd service/$SVC
else
    git clone $GIT service/$SVC
    cd service/$SVC
fi

if [ "$BRANCH" = "stable" ]; then
    git checkout stable
elif [ "$BRANCH" = "beta" ]; then
    git checkout beta
else
    if [ "$SVC" != "library" ] && [ "$BRANCH" = "master" ]; then
        echo "$BRANCH is not a valid branch"
        exit 1
    fi
fi

if [ $? -ne 0 ] && [ "$SVC" != "library" ]; then
    exit 1
fi

#           is_minikube / update_flag
./deploy.sh true $UPDATE

if [ $? -ne 0 ]; then
    exit 1
fi
