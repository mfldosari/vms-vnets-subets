#!/bin/bash

# Input and output files
INPUT_FILE="Data/employees.json"
OUTPUT_FILE="Data/employees_cleaned.json"

# Process the JSON
jq 'map({
  name,
  email,
  department: (.department | ascii_downcase | gsub(" "; "-")),
  status,
  default_password
})' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Cleaned employee data saved to $OUTPUT_FILE"
