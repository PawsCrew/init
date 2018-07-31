#!/bin/bash
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
PLAYBOOK=init

function download()
{
    local init_path="${1}"
    local retry_count_down=30
      while ! curl --silent -o ${init_path} "https://raw.githubusercontent.com/einyx/${PLAYBOOK}/${BS_BRANCH:-master}/${init_path}" && [ ${retry_count_down} -gt 0 ] ; do
        retry_count_down=$((retry_count_down - 1))
    done
}

function init()
{
    local init_path="${1}"
    if [ ! -e "${init_path}" ]; then
        echo "${init_path}: Downloading"
        mkdir -p init
        download "${init_path}"
    fi
    source "${init_path}"
}


init init/00-start.sh
init init/10-volumes.sh

if [ "$RUN_ANSIBLE" == "yes" ]
then
    init init/90-ansible.sh
fi
init init/99-end.sh
