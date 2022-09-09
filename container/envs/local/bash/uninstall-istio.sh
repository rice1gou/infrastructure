#/bin/zsh
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

ISTIO_VERSION=1.15.0

kubectl label namespace default istio-injection-

./istio-${ISTIO_VERSION}/bin/istioctl uninstall -y --purge