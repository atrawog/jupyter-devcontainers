# Micromamba-Based Docker Containers for Development, Deployment, and Testing

## Overview

This repository hosts a suite of Docker containers built on Micromamba, designed for a versatile range of applications including development, deployment, and testing of JupyterHub via Ansible. These containers come pre-equipped with Ansible, Molecule, and Molecule-QEMU, eliminating the need for separate installations. Ideal for use with Visual Studio Code's Devcontainer feature, for conducting robust local testing, and for serving as standard containers in JupyterHub environments.

## Key Features

- **All-in-One Containers**: Includes Ansible, Molecule, and Molecule-QEMU for out-of-the-box deployment and testing functionality.
- **VS Code Devcontainer Integration**: Fully compatible with VS Code's Devcontainer, offering a streamlined development environment.
- **JupyterHub Deployment**: Simplifies the process of deploying JupyterHub using Ansible.
- **Enhanced Testing Capabilities**: Supports comprehensive local testing using Molecule and Molecule-QEMU, directly within the container.
- **JupyterHub Ready**: Suitable for use as general-purpose containers within JupyterHub.

## Getting Started

### Prerequisites

- Docker
- Visual Studio Code with Remote - Containers extension (optional for Devcontainer usage)

### Installation

1. Clone this repository.
2. Install Docker on your system.
3. (Optional) Install Visual Studio Code and the Remote - Containers extension for Devcontainer support.

## Usage

### As a VS Code Devcontainer

1. Open the project in VS Code.
2. Use `Remote-Containers: Open Folder in Container` to start the development environment.

### For Deploying and Testing JupyterHub

1. Deploy JupyterHub or run tests directly using the included Ansible, Molecule, and Molecule-QEMU tools.
2. For deployment, navigate to the Ansible playbook directory and execute the playbook.
3. For testing, use Molecule commands for standard or QEMU-based testing.

### On JupyterHub

1. Integrate the Docker container as a kernel or computing environment in JupyterHub.
2. Follow JupyterHub documentation for custom Docker container integration.

## Customization

- Edit Dockerfiles to customize the containers.
- Modify Ansible playbooks and Molecule tests as per your project needs.
