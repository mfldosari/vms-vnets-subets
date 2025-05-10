#!/bin/bash

echo "starting ansible...."
ansible-playbook -i inventory.ini software.yaml

