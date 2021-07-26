#!/bin/bash

if ! tmux has-session -t k8s; then
  tmux new -s k8s -d
    tmux split-window -t k8s:1 -v -p 50
    tmux send-keys -t k8s:1.0 \
      'export VAULT_ADDR=hello' Enter
    tmux send-keys -t k8s:1.0 \
      'env | grep -i VAULT' Enter
    tmux send-keys -t k8s:1.0 \
      'kubectl get pods' Enter
    tmux send-keys -t k8s:1.1 \
    'kubectl get events --sort-by=.metadata.creationTimestamp' Enter
  tmux attach
fi
tmux attach -t k8s
