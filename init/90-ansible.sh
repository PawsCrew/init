#!/bin/bash
set -e

function ansible_install()
{
  yum install -y git
  rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
  yum -y update
  yum -y install ansible
  ansible --version
}

function ansible_run()
{
  echo "something $1"
}

if [[ -v ROLE ]]
then
  ansible_install
  ansible_run $ROLE
else
  NEW_HOSTNAME=${TRUNC_INSTANCE_ID}
fi
