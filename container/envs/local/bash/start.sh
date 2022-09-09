#/bin/zsh
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

kubectl apply -k ../../../manifests/overlay/local