#!/bin/bash

tmux new -s eks -d
#  tmux new-window -t eks:2
#  tmux split-window -t eks:2 -v
  tmux send-keys -t eks:1 \
    'terraform -chdir=/software/census/terraform/tf-aws/demo-env/services/eks-cluster plan' Enter
