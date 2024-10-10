#!/bin/bash

IMAGE_ID="ami-053b0d53c279acc90"
# IMAGE_ID="ami-01bc990364452ab3e"
INSTANCE_TYPE="t2.micro"
KEY_NAME=""
SEQURITY_GROUP_ID=""
SUBNET_ID=""
TAG_NAME="$1"

echo "Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $IMAGE_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SEQURITY_GROUP_ID \
    --subnet-id $SUBNET_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
    --user-data file://user_data.sh \
    --query "Instances[0].InstanceId" \
    --output text)

echo "Instance ID: $INSTANCE_ID"

echo "Waiting for instance to be ready..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID
sleep 20

echo "Instance is ready"

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

echo "Public IP: $PUBLIC_IP"

echo "Connecting to EC2 instance..."
ssh -i $KEY_NAME.pem -o StrictHostKeyChecking=no ubuntu@$PUBLIC_IP

echo "Instance ID: $INSTANCE_ID"

./terminate.sh "$INSTANCE_ID"