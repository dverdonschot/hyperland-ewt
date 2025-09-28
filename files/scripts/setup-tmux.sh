#!/usr/bin/env bash

# Tmux Configuration Setup
# Creates tmux configuration matching oh-my-posh colors

set -oue pipefail

echo "Setting up Tmux configuration..."

# =============================================================================
# TMUX CONFIGURATION
# =============================================================================

# Setup tmux configuration matching oh-my-posh colors
cat > /etc/skel/.tmux.conf << 'EOF'
# Tmux configuration matching oh-my-posh color scheme

# Enable mouse mode
set -g mouse on

# Set default terminal mode to 256color mode
set -g default-terminal "screen-256color"

# Enable RGB colour if running in xterm(1)
set-option -sa terminal-overrides ",xterm*:Tc"

# Change the default $TERM to tmux-256color
set -g default-terminal "tmux-256color"

# No bells at all
set -g bell-action none

# Keep windows around after they exit
set -g remain-on-exit on

# Change the prefix key to C-a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Turn the mouse on, but without copy mode dragging
set -g mouse on
unbind -n MouseDrag1Pane
unbind -Tcopy-mode MouseDrag1Pane

# Some extra key bindings to select higher numbered windows
bind F1 selectw -t1
bind F2 selectw -t2
bind F3 selectw -t3
bind F4 selectw -t4
bind F5 selectw -t5
bind F6 selectw -t6
bind F7 selectw -t7
bind F8 selectw -t8
bind F9 selectw -t9
bind F10 selectw -t0

# A key to toggle between smallest and largest sizes if a window is visible in
# multiple places
bind F set -w window-size

# Keys to toggle monitoring activity in a window and the synchronize-panes option
bind m set monitor-activity
bind y set synchronize-panes\; display 'synchronize-panes #{?synchronize-panes,on,off}'

# Create new windows/panes in same directory
bind c new-window -c "#{pane_current_path}"
bind "\"" split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

# STATUS BAR CONFIGURATION
# Colors from oh-my-posh theme: #f77622, #1CA6A3, #1c85a6, #33c4c6, #3d6799, #f2f3f4

# Status bar general
set -g status on
set -g status-interval 5
set -g status-position bottom
set -g status-justify left
set -g status-style "bg=#1c85a6,fg=#f2f3f4"

# Left status (session name)
set -g status-left-length 40
set -g status-left "#[bg=#f77622,fg=#f2f3f4,bold] #S #[bg=#1c85a6,fg=#f77622]"

# Right status (host, date, time)
set -g status-right-length 80
set -g status-right "#[bg=#1c85a6,fg=#33c4c6]#[bg=#33c4c6,fg=#f2f3f4] %Y-%m-%d #[bg=#33c4c6,fg=#1CA6A3]#[bg=#1CA6A3,fg=#f2f3f4,bold] %H:%M "

# Window status
set -g window-status-style "bg=#1c85a6,fg=#f2f3f4"
set -g window-status-format " #I:#W "
set -g window-status-current-style "bg=#3d6799,fg=#ffffff,bold"
set -g window-status-current-format "#[bg=#1c85a6,fg=#3d6799]#[bg=#3d6799,fg=#ffffff] #I:#W #[bg=#1c85a6,fg=#3d6799]"

# Pane borders
set -g pane-border-style "fg=#33c4c6"
set -g pane-active-border-style "fg=#f77622"

# Message styling
set -g message-style "bg=#f77622,fg=#f2f3f4,bold"
set -g message-command-style "bg=#3d6799,fg=#f2f3f4,bold"

# Copy mode styling
set -g mode-style "bg=#33c4c6,fg=#1c85a6,bold"

# Clock mode
set -g clock-mode-colour "#1CA6A3"
set -g clock-mode-style 24

# Activity monitoring
set -g monitor-activity on
set -g visual-activity off
set -g window-status-activity-style "bg=#e91e63,fg=#ffffff,bold"

# Automatically renumber windows
set -g renumber-windows on

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
EOF

echo "Tmux configuration setup completed!"