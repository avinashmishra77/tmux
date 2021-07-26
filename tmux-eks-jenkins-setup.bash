#!/bin/bash

# Create the session if it doesn't already exists, else attach to existing session
if ! tmux has-session -t jenkins; then

    # start new session jenkins
    tmux new -s jenkins -d

    # Start jenkins deployment within ekc cluster
    tmux send-keys -t jenkins:1 \
      'kp aws' Enter
    tmux send-keys -t jenkins:1 \
      'terraform -chdir=/software/census/terraform/tf-aws/mgmt/helm-jenkins apply -auto-approve' Enter

    # Split window horizontally
    tmux split-window -t jenkins:1 -v
    tmux send-keys -t jenkins:1 \
      'kp aws' Enter
    tmux send-keys -t jenkins:1 \
      'watch "kubectl get pods -A; kubectl get ingress -A"' Enter
    

fi
tmux attach -t jenkins
