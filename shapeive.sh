#!/bin/bash

# Fetch JSON output from Terraform
TF_OUTPUT=$(terraform output -json)

# Parse it using jq (requires jq installed)
echo "[ubuntu_vms]" > inventory.ini
echo "$TF_OUTPUT" | jq -r '.ansible_hosts.value | to_entries[] | "\(.key) ansible_host=\(.value) ansible_user=azureuser ansible_connection=ssh ansible_ssh_private_key_file=~/.ssh/id_rsa"' >> inventory.ini

echo "Inventory written to inventory.ini"
