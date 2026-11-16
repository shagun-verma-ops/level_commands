# Dynamic AWS EC2 Provisioning CLI Tool.

An interactive Bash script that automates AWS EC2 instance creation using the AWS CLI. Instead of forcing the user to manually look up and copy paste IDs from the AWS console, this script dynamically fetches live account resources (Regions, Security Groups, and AMI IDs) directly in the terminal.

## Key  features
* **Zero Manual ID Lookup:** Dynamically queries AWS to fetch and display available Regions, Security Groups, amd AMI IDs in clean text format ('--output text').
* **Smart AMI Selection (Owned vs. Amazon):** Allows the user to choose between their own custom AMIs ("--owner self") or official Amazon AMIs, automatically fetching and mapping the selected AMI ID.
* **Interactive Menu & Loops:** Uses user prompts and loops to configure and launch single or multiple EC2 instances smoothly.

## Prerequisites
* **AWS CLI** installed and configured ('aws configure') with EC2 read/launch permissions.
* A Linux/Unix terminal or Git Bash.

## How to use 

1. **Clone this repository:**
    ```bash
    git clone [https://github.com/shagun-verma-ops/level_commands.git](https://github.com/shagun-verma-ops/level_commands.git)
    cd level_commands
2. **Make the script executable:**
    chmod +x creating_instances.sh
3. **Run the script**
    ./creating_instances.sh

**WHAT I LEARNED**
Building this script helped me understand how to parse AWS CLI outputs (--query and --output table), handle dynamic variables in Bash, and automate real-world cloud workflows without relying on the web console.

Note: Remember to terminate test instances after practice to avoid unneccessary AWS charges.
