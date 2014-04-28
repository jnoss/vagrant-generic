#!/bin/bash

# Kick off the puppet runs, control is first for databases
vagrant ssh access -c "sudo puppet agent -t --server puppet.dev"
