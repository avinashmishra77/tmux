#!/bin/bash

# Create the session if it doesn't already exists, else attach to existing session
if ! tmux has-session -t ingress; then

    # start new session ingress
    tmux new -s ingress -d -c /software/census/terraform/tf-aws/mgmt/nginx-ingress

    # Start ingress deployment within ekc cluster
    tmux send-keys -t ingress:1 \
      'kp aws' Enter
    tmux send-keys -t ingress:1 \
      'terraform -chdir=/software/census/terraform/tf-aws/mgmt/nginx-ingress apply -auto-approve' Enter

    cd /software/census/terraform/tf-aws/mgmt/nginx-ingress/

fi
tmux attach -t ingress
