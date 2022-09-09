#/bin/zsh
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

ISTIO_VERSION=1.15.0

if [ ! -d ./istio-${ISTIO_VERSION} ]; then
  echo "install istio-${ISTIO_VERSION}"
  curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
fi

./istio-${ISTIO_VERSION}/bin/istioctl install -f ../../../manifests/base/istio/profile/local/profile.yaml -y

kubectl label namespace default istio-injection=enabled --overwrite