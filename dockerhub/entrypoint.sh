#!/bin/sh

set -e

echo "AWS cli version info: \n $(aws --version)"
echo "$KUBE_CONFIG_DATA" | base64 -d > kubeconfig
# cat kubeconfig
export KUBECONFIG="$PWD/kubeconfig"
chmod 600 "$PWD/kubeconfig"

# kubectl get nodes -o wide

if [ -n "$(echo "$INPUT_PLUGINS" | tr -d '[:space:]')" ]; then
    plugins="$(echo "$INPUT_PLUGINS" | tr ', ' '\n')"

    for plugin in $plugins; do
        echo "installing helm plugin: [$plugin]"
        helm plugin install "$plugin"
    done
fi

echo "running entrypoint command(s)"

response=$(sh -c "$INPUT_COMMAND")

{
  echo "response<<EOF"
  echo "$response"
  echo "EOF"
} >> "$GITHUB_OUTPUT"

