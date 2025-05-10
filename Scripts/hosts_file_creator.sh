#!/bin/bash

# Fetch JSON output from Terraform
TF_OUTPUT=$(terraform output -json)

# Write to inventory.ini
echo "[ubuntu_vms]" > inventory.ini

echo "$TF_OUTPUT" | jq -r '
  .ansible_hosts.value | to_entries[] |
  "# \(.value.full_name) - \(.value.email)\n\(.key) ansible_host=\(.value.ip) ansible_user=azureuser ansible_connection=ssh ansible_ssh_private_key_file=~/.ssh/id_rsa"
' >> inventory.ini

echo "Inventory written to inventory.ini"
