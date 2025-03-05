helm repo add kong https://charts.konghq.com
helm repo update

kubectl create namespace kong --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install kong kong/ingress -n kong --values kic.values.yaml

kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml
kubectl apply -f ./manifests/license.yaml
kubectl apply -f ./manifests/gateway.yaml

# Deploy the echo service
kubectl apply -f https://docs.konghq.com/assets/kubernetes-ingress-controller/examples/echo-service.yaml

# Configure Ingresses
kubectl apply -f ./manifests/routes-echo.yaml
kubectl apply -f ./manifests/routes-manager.yaml

# Deploy OIDC plugin
kubectl apply -f ./manifests/plugin-oidc-auth.yaml