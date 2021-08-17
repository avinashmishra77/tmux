#!/bin/bash

# Create the session if it doesn't already exists, else attach to existing session
if ! tmux has-session -t eks; then

    # start new session eks
    tmux new -s eks -d -c /software/census/terraform/tf-aws/demo-env/services/eks-cluster

    # Start eks cluster deploy
    tmux send-keys -t eks:1 \
        'terraform -chdir=/software/census/terraform/tf-aws/demo-env/services/eks-cluster apply -auto-approve' Enter

fi
tmux attach -t eks

