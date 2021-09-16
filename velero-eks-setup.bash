#!/bin/bash

# Create the session if it doesn't already exists, else attach to existing session
if ! tmux has-session -t velero; then

    # start new session velero
    tmux new -s velero -d -c /software/census/terraform/tf-aws/mgmt/velero/

    # Start velero gatekeeper deployment within ekc cluster
    tmux send-keys -t velero:1 \
      'kp aws' Enter
    tmux send-keys -t velero:1 \
      'terraform -chdir=/software/census/terraform/tf-aws/mgmt/velero apply -auto-approve' Enter

    # Split window horizontally
    tmux split-window -t velero:1 -v
    tmux send-keys -t velero:1 \
      'kp aws' Enter
    tmux send-keys -t velero:1 \
      'watch "kubectl get pods -A; kubectl get ingress -A"' Enter
    
fi
tmux attach -t velero
