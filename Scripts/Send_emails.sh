#!/bin/bash

# Fetch JSON output from Terraform
TF_OUTPUT=$(terraform output -json)

# Extract the user details and send emails from outputs
echo "$TF_OUTPUT" | jq -r '
  .ansible_hosts.value | to_entries[] | 
  "Name: \(.key), Email: \(.value.email), Full Name: \(.value.full_name), IP: \(.value.ip), Password: \(.value.pass)"
' | while IFS= read -r user; do
    # Extract the user's details
    full_name=$(echo "$user" | grep -oP 'Full Name: \K[^,]*')
    email=$(echo "$user" | grep -oP 'Email: \K[^,]*')
    ip=$(echo "$user" | grep -oP 'IP: \K[^,]*')
    password=$(echo "$user" | grep -oP 'Password: \K[^,]*')

    # Create the email content
    email_subject="Your Access Details"
    email_body="Subject: $email_subject\n\nDear $full_name,\n\nYour account has been created. Here are your access details:\n\n- **Full Name**: $full_name\n- **Email**: $email\n- **IP Address**: $ip\n- **Password**: $password\n\n \n- RDP username: rdpuser \n- RDP pass: "12345" \n\n**Note**: Please change your password as soon as you log in.\n\nBest regards,\nYour IT Team"

    # Send the email using msmtp (Gmail SMTP)
    echo -e "$email_body" | msmtp "$email"

    echo "Sent access details to $email"
done
