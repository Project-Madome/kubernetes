get_ingress_cfg() {
    echo "$(kubectl get service/ingress-nginx-controller --namespace=ingress-nginx -o json)"
}

APP_PROTOCOL="$(get_ingress_cfg | yq '.spec.ports[0].appProtocol')"

if [ "$APP_PROTOCOL" = "http" ]; then
    echo $(get_ingress_cfg | yq -o=json '.spec.ports[0].port |= 8324') > ./ingress/controller.json
else
    APP_PROTOCOL="$(get_ingress_cfg | yq '.spec.ports[1].appProtocol')"

    if [ "$APP_PROTOCOL" = "http" ]; then
        echo $(get_ingress_cfg | yq -o=json '.spec.ports[1].port |= 8324') > ./ingress/controller.json
    else
        echo ".spec.ports[].appProtocol must be 'http'"
        exit 1
    fi
fi

if [ $? -ne 0 ]; then
    exit 1
fi

kubectl apply -f ./ingress
