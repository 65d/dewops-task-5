## Prerequisites

1.	Install and configure the AWS CLI:
aws configure
2.	Ensure you have an AWS key pair and update KEY_NAME in create-instance.sh.

## Usage

Launch EC2 Instance

Run to create and connect to an instance:
```
./create-instance.sh
```

Terminate EC2 Instance (runs automatically at the end of create-instance.sh)

Run to terminate an instance:
```
./terminate <instance-id>
```
