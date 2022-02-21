./deploy/config.sh

if [ $? -ne 0 ]; then
    exit 1
fi

SPECIFIED_SVC=$1
UPDATE=$2

if [ -n "$SPECIFIED_SVC" ] && [ "$SPECIFIED_SVC" != "true" ]; then
    if [ "$SPECIFIED_SVC" = "user" ]; then
        ./deploy/deploy.sh user beta git@github.com:Project-Madome/user.madome.app.git $UPDATE
    elif [ "$SPECIFIED_SVC" = "auth" ]; then
        ./deploy/deploy.sh auth beta git@github.com:Project-Madome/auth.madome.app.git $UPDATE
    elif [ "$SPECIFIED_SVC" = "library" ]; then
        ./deploy/deploy.sh library master git@git.meu.works:madome/servers/library.git $UPDATE
    fi

    exit 1
fi

UPDATE=$1

./deploy/deploy.sh auth beta git@github.com:Project-Madome/auth.madome.app.git $UPDATE

if [ $? -ne 0 ]; then
    exit 1
fi

./deploy/deploy.sh user beta git@github.com:Project-Madome/user.madome.app.git $UPDATE

if [ $? -ne 0 ]; then
    exit 1
fi

./deploy/deploy.sh library master git@git.meu.works:madome/servers/library.git $UPDATE

if [ $? -ne 0 ]; then
    exit 1
fi

# ingress-nginx
if [ -z "$(kubectl get deploy --namespace=ingress-nginx -o=name)" ]; then
    # kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/cloud/deploy.yaml

    echo "read https://kubernetes.github.io/ingress-nginx/deploy/#installation-guide"

    exit 1
fi

kubectl apply -f ./ingress
