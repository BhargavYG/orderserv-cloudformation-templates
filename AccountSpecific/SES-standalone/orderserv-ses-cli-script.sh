#!/bin/sh
# This script to create SES and SES Config through AWS CLI as AWS Cloudformation
# do not support SES
# prerequite to have a profile created with proper access


if [ "$#" -ne 1 ]; then
  echo "Usage: First input must be an allowed Environment" >&2
  exit 1
fi

echo "Environment selected to run this script is ->" $1

set_region=ap-southeast-1
set_account=861135592517
set_profile=prod

TOPIC_ARN=arn:aws:sns:${set_region}:${set_account}:orderserv-ses-email-failure
echo $TOPIC_ARN

SES_NAME=orderserv-${1}-ses-conf-set
echo $SES_NAME

EVENT_DEST_NAME=orderserv-${1}-ses-event-destination
echo $EVENT_DEST_NAME


aws ses create-configuration-set --region $set_region --profile $set_profile --configuration-set Name=${SES_NAME}
echo "create-configuration-set completed"

aws sesv2 create-configuration-set-event-destination --region $set_region --profile $set_profile \
--configuration-set-name ${SES_NAME} \
--event-destination-name ${EVENT_DEST_NAME} \
--event-destination Enabled=true,MatchingEventTypes=[BOUNCE,CLICK,COMPLAINT,DELIVERY,OPEN,REJECT,RENDERING_FAILURE,SEND],SnsDestination={TopicArn=${TOPIC_ARN}}

echo "create-configuration-set-event-destination"