#!/bin/bash
set -xe
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Create the ignitions files
rm -fr deploy
mkdir deploy

cp install-config.yaml deploy/

openshift-install create manifests --dir=deploy

sed -i 's/true/false/g' deploy/manifests/cluster-scheduler-02-config.yml

openshift-install create ignition-configs --dir=deploy

scp deploy/*.ign root@bastion.ocp4.sni.com.mx:/var/www/html/
ssh root@bastion.ocp4.sni.com.mx 'chmod 644 /var/www/html/*.ign'
#cp -f deploy/*.ign /var/www/html/

## Terraforn deployment.
cd terraform

./plan -target=module.template
./apply

./plan -target=module.bootstrap
./apply

echo "Waiting 2 minutes to bootstrap node finish the boot process"
sleep 120
./plan -target=module.master
./apply

export KUBECONFIG="${DIR}/deploy/auth/kubeconfig"
openshift-install wait-for bootstrap-complete --dir ${DIR}/deploy/ --log-level debug

./plan
./apply

./destroy -target=module.bootstrap

cd ..
