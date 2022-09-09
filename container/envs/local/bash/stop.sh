#/bin/zsh
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR"

kubectl delete -k ../../../manifests/overlay/local