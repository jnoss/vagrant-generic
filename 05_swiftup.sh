#!/bin/bash
# If you want to test Swift, this is the script to run. It will bring up all of the
# nodes necessary to run Swift.
vagrant up --parallel --provider vmware_fusion puppet control swiftstore1 swiftstore2 swiftstore3 access
vagrant hostmanager --provider vmware_fusion
