#!/bin/bash
if pgrep -f "Agent.Listener" > /dev/null; then
    # Agent is running
    exit 0
else
    # Agent is not running
    exit 1
fi