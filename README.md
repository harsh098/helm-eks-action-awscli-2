# helm-eks-action-awscli-2

This GitHub Action is based on [koslib/helm-eks-action](https://github.com/koslib/helm-eks-action) with the improvement that it runs on aws-cli-v2 as opposed to aws-cli-v1.  

The functionality and the usage is same.  

I did not have enough time to make a **PR** and get it merged so I forked the original action. 

The action is almost fully compatible with the original plugin. 

# helm-eks-action-awscli-2
Github Action for executing Helm commands on EKS .

The Helm version installed is Helm3.

This action was inspired by [kubernetes-action](https://github.com/Jberlinsky/kubernetes-action).

# Instructions

This Github Action was created with EKS in mind, therefore the following example refers to it.

## Input variables

1. `plugins`: you can specify a list of Helm plugins you'd like to install and use later on in your command. eg. helm-secrets or helm-diff. This action does not support only a specific list of Helm plugins, rather any Helm plugin as long as you supply its URL. You can use the following [example](#example) as a reference.
2. `command`: your kubectl/helm command. This supports multiline as per the Github Actions workflow syntax.

example for multiline:
```yaml
...
with:
  command: |
    helm upgrade --install my-release chart/repo
    kubectl get pods
```

## Example

```yaml
name: deploy

on:
    push:
        branches:
            - master
            - develop

jobs:
  deploy:
    runs-on: ubuntu-latest
    env:
      AWS_REGION: us-east-1
      CLUSTER_NAME: my-staging
    steps:
      - uses: actions/checkout@v3

      - name: AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          role-to-assume: arn:aws:iam::<your account id>:role/github-actions
          role-session-name: ci-run-${{ github.run_id }}
          aws-region: ${{ env.AWS_REGION }}
      
      - name: kubeconfig
        run: |
          aws eks update-kubeconfig --name ${{ env.CLUSTER_NAME }} --region ${{ env.AWS_REGION }}  --kubeconfig ./kubeconfig
          echo 'KUBE_CONFIG_DATA<<EOF' >> $GITHUB_ENV
          echo $(cat ./kubeconfig | base64) >> $GITHUB_ENV
          echo 'EOF' >> $GITHUB_ENV

      - name: helm deploy
        uses: harsh098/helm-eks-action-awscli-2@v0.3
        env:
          KUBE_CONFIG_DATA: ${{ env.KUBE_CONFIG_DATA }}
        with:
          plugins: "https://github.com/jkroepke/helm-secrets" # optional
          command: helm secrets upgrade <release name> --install --wait <chart> -f <path to values.yaml>
```

## Response

Use the output of your command in later steps

```yaml
    steps:
      - name: Get URL
        id: url
        uses: harsh098/helm-eks-action-awscli-2@v0.3
        with:
          command: kubectl get svc my_svc -o json | jq -r '.status.loadBalancer.ingress[0].hostname'

      - name: Print Response
        run: echo "Response was ${{ steps.url.outputs.response }}"

```

# Main dependencies version table

The latest version of this action uses the following dependencies versions:

| Package      | Version |
| ----------- | ----------- |
| awscli      | v2.11.25  |
| helm   | v3.3.0     |

It is very much possible that an update came out and I did not update the action on time. In this please, feel free to [send me a PR](#contributing) and I'll review it as soon as possible.

# Accessing your cluster

It is required to set the `KUBE_CONFIG_DATA` env/secret in order to access your cluster. I recommend you do it dynamically using a step like that:

```
- name: kubeconfig
        run: |
          aws eks update-kubeconfig --name ${{ env.CLUSTER_NAME }} --region ${{ env.AWS_REGION }}  --kubeconfig ./kubeconfig
          echo 'KUBE_CONFIG_DATA<<EOF' >> $GITHUB_ENV
          echo $(cat ./kubeconfig | base64) >> $GITHUB_ENV
          echo 'EOF' >> $GITHUB_ENV
```

If you find this configuration option complicated, you can still supply `KUBE_CONFIG_DATA` as a repository secret, however this is not endorsed by this repository.


# Contributing

Pull requests, issues or feedback of any kind are more than welcome by anyone!

If this action has helped you in any way and enjoyed it, feel free to submit feedback through [issues](https://github.com/harsh098/helm-eks-action-awscli-2/issues)
