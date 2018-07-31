#!/usr/bin/env bash

set -x
echo "BEGIN: $(TZ=UTC date)"
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
readonly EC2_METADATA_URL='http://169.254.169.254/latest/meta-data'

echo "Install init packages"
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
yum install -y unzip
unzip awscli-bundle.zip
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
INSTANCE_ID=`curl --silent http://169.254.169.254/latest/meta-data/instance-id`
REGION=`curl --silent http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//'`
aws ec2 describe-tags --region $REGION --filter "Name=resource-id,Values=$INSTANCE_ID" --output=text | sed -r 's/TAGS\t(.*)\t.*\t.*\t(.*)/\1="\2"/' > /etc/ec2-tags

set -o allexport
source /etc/ec2-tags

echo "Updating hostname"
IP=$(curl -s "${EC2_METADATA_URL}/local-ipv4")
TRUNC_INSTANCE_ID=$(curl -s "${EC2_METADATA_URL}/instance-id" | sed -e 's/^i-//')
if [[ -v ROLE ]]
then
  NEW_HOSTNAME=${ROLE}-${TRUNC_INSTANCE_ID}
else
  NEW_HOSTNAME=${TRUNC_INSTANCE_ID}
fi
echo "${IP} ${NEW_HOSTNAME} ${ROLE}" >> /etc/hosts
echo "${NEW_HOSTNAME}" > /etc/hostname
hostname ${NEW_HOSTNAME}
service rsyslog restart

umask 022
