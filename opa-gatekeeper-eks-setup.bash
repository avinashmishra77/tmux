#!/bin/bash

# Create the session if it doesn't already exists, else attach to existing session
if ! tmux has-session -t opa; then

    # start new session OPA
    tmux new -s opa -d -c /software/census/terraform/tf-aws/mgmt/opa/

    # Start OPA gatekeeper deployment within ekc cluster
    tmux send-keys -t opa:1 \
      'kp aws' Enter
    tmux send-keys -t opa:1 \
      'terraform -chdir=/software/census/terraform/tf-aws/mgmt/opa apply -auto-approve' Enter

    # Split window horizontally
    tmux split-window -t opa:1 -v
    tmux send-keys -t opa:1 \
      'kp aws' Enter
    tmux send-keys -t opa:1 \
      'watch "kubectl get pods -A; kubectl get ingress -A"' Enter
    
fi
tmux attach -t opa
