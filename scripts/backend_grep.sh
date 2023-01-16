#!/bin/sh
# using perl command to convert two strings to int and do math operation
expr $(aws ecs describe-task-definition --task-definition backend-task | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/,$//') + 1