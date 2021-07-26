# Terminal multiplexer (tmux)

## Basic tmux commands

Prefix: ctrl+b : This means we are going to tell tmux to do something

"ctrl+b :" : Issue tmux commands 

Commands (Session) | Description
---------| -----------
tmux <br /> tmux new -s session_name| start a new session
exit | exit session
ctrl+b d | (d)detach a session
tmux attach-session <br /> tmux attach <br /> tmux a <br /> tmux attach -t 0| (a)ttach back to the last
tmux ls | list running sessions
ctrl+b $ <br /> ctrl+b : {rename-session session_name} | rename session
ctrl+b ( | move to previous session
ctrl+b ) | move to next session

Commands (Windows) | Description
---------| -----------
ctrl+b c | (c)create new window
ctrl+b l | (l)last window
ctrl+b p | (p)previous window
ctrl+b m | (n)nexy window
ctrl+b 0 | (0)window at position 0, usually 1
ctrl+b 1 | (1)window at position 1, usually 2
ctrl+b {n} | (nth)window
ctrl_b , <br /> ctrl+b : {rename-window} | renaming window

Commands (Scroll buffer/Copy mode) | Description
------------------------ | -----------
ctrl+b [ | Enter copy mode - use standard commands: <br/> g (to go to the top) <br /> G (to to to the bottom) <br />? (to search the up) <br />/ (to search down) <br /> q (to quit copy mode)
spacebar | (start selecting text to copy)
ctrl+w Enter | Copy selected text
ctrl+b ] | Paste selected text

Commands (Window panes) | Description
------------------------ | -----------
ctrl+b % | split the window vertically
ctrl+b " | split the window horizontally
ctrl+b {arrow keys} | to move between the panes
ctrl+b z | z(zoom) in/out of full screen the current pane

Note: Each window pane is it own shell and has its own scroll buffer.

---

## Customize tmux

The tmux configuration file is stored in ~/.tmux.conf file in your home directory.

'-g' => global setting, all sessions, windows, panes etc <br />
'-n' => no prefix <br />
'M' => Alt key <br />

##### Change prefix
set -g prefix C-s
unbind C-b
bind C-s send-prefix

##### re-index window to start from 1 rather than 0
set -g base-index 1

##### Escape time
set -g escape-time 20

##### to use alt+arrow keys to move between panes
bind -n M-Left select-pane -L <br />
bind -n M-Right select-pane -R <br />
bind -n M-Up select-pane -U <br />
bind -n M-Down select-pane -D <br />

##### enable mouse
set -g mouse on

##### synchronize commands across panes
set synchronize-panes on <br />
set synchronize-panes off

---

## Automation

You can put tmux command in a shell script and have that setup and configure you tmux session automatically for you. 

To launch eks creation automatically:

```bash
#!/bin/bash

# Create the session if it doesn't already exists, else attach to existing session
if ! tmux has-session -t eks; then
    tmux new -s eks -d
    #  tmux new-window -t eks:2
    #  tmux split-window -t eks:2 -v
    tmux send-keys -t eks:1 \
        'export VAULT_ADDR=http://127.0.0.1:8200' Enter
    tmux send-keys -t eks:1 \
        'terraform -chdir=/software/census/terraform/tf-aws/demo-env/services/eks-cluster plan' Enter
fi
tmux attach -t eks
```

To connect to kubernetes instance and get events:

```bash
#!/bin/bash

# Create the session if it doesn't already exists, else attach to existing session
if ! tmux has-session -t k8s; then
    # Create new tmux session k8s
    tmux new -s k8s -d
    # Split window horizontally
    tmux split-window -t k8s:1 -v -p 50
    # Execute command on Pane1
    tmux send-keys -t k8s:1.0 \
        'kubectl get pods' Enter
    # Execute command on Pane2
    tmux send-keys -t k8s:1.1 \
        'kubectl get events --sort-by=.metadata.creationTimestamp' Enter
fi
tmux attach -t k8s
```
