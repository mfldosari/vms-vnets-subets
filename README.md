# vms-vnets-subets

# Project Name

This project leverages **Infrastructure as Code (IaC)** with **Terraform** and **Software as Code (SaC)** with **Ansible** to automate the deployment and management of virtual machines (VMs) in the cloud, along with software installation on those VMs.

## Table of Contents

- [Overview](#overview)
- [Technologies Used](#technologies-used)
- [Features](#features)
- [Getting Started](#getting-started)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [License](#license)

## Overview

This project automates the provisioning of cloud infrastructure using **Terraform**, ensuring that all necessary cloud resources are created and configured consistently. Once the infrastructure is provisioned, **Ansible** is used to automate the installation of required software (like **Slack**, **WhatsApp**, and **OneDrive**) on the virtual machines, ensuring that software configurations are repeatable, scalable, and error-free.

## Technologies Used

- **Terraform**: For provisioning cloud infrastructure, such as Virtual Machines, networks, and other resources.
- **Ansible**: For automating software installations and configurations on provisioned VMs.
- **Cloud Provider**: Azure (or your cloud provider of choice).
- **Linux/Ubuntu**: Operating system for VMs.
  
## Features

- Automated **VM provisioning** using Terraform.
- Software installation on VMs (Slack, WhatsApp, OneDrive) using Ansible.
- Ensures **consistent environments** across all VMs.
- **Scalable** and **reliable** automation for cloud-based applications.

## Getting Started

To get started with this project, ensure you have the following prerequisites:

- **Terraform** installed (for infrastructure provisioning).
- **Ansible** installed (for automation of software installation).

### Prerequisites

1. Install **Terraform**:
   - Follow the official [Terraform installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install Terraform on your local machine.
   
2. Install **Ansible**:
   - Follow the official [Ansible installation guide](https://docs.ansible.com/ansible/latest/installation_guide/index.html) to install Ansible on your local machine.

