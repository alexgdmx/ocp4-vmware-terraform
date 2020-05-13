#!/bin/bash

rm -fr deploy
mkdir deploy

cp install-config.yaml deploy/

openshift-install create manifests --dir=deploy

sed -i 's/true/false/g' deploy/manifests/cluster-scheduler-02-config.yml

openshift-install create ignition-configs --dir=deploy

./create_base64_files

scp deploy/bootstrap.ign root@bastion.ocp4.sni.com.mx:/var/www/html/
ssh root@bastion.ocp4.sni.com.mx 'chmod 644 /var/www/html/bootstrap.ign'

#cp -f deploy/bootstrap.ign /var/www/html/
sleep 30
cd terraform

./plan -target=module.template
./apply

./plan -target=module.bootstrap
./apply

echo "Waiting 2 minutes to bootstrap node finish the boot process"
sleep 120
./plan -target=module.master
./apply

echo "Waiting 5 minutes to master nodes finish the boot process"
sleep 300
./plan
./apply
cd ..

export KUBECONFIG=deploy/auth/kubeconfig
openshift-install wait-for bootstrap-complete --dir deploy/ --log-level debug
cd terraform
./destroy -target=module.bootstrap

cd ..
