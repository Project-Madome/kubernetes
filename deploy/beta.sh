./secret.sh

if [ $? -ne 0 ]; then
    exit 1
fi

./deploy.sh auth false git@github.com:Project-Madome/auth.madome.app.git

if [ $? -ne 0 ]; then
    exit 1
fi

./deploy.sh user false git@github.com:Project-Madome/user.madome.app.git

if [ $? -ne 0 ]; then
    exit 1
fi

./deploy.sh library false git@git.meu.works:madome/servers/library.git

if [ $? -ne 0 ]; then
    exit 1
fi

# ingress-nginx
if [ -z "$(kubectl get deploy --namespace=ingress-nginx -o=name)" ]; then
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/cloud/deploy.yaml

    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

kubectl apply -f ./ingress
