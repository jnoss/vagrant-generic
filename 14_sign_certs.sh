#!/bin/bash

# sign the certs
vagrant ssh puppet -c "sudo puppet cert sign --all"