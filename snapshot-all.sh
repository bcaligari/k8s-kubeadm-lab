#!/bin/bash -x

KVM_DOMAINS=$(cat ./kvm-domains)

if [ -z "$1" ]
then
	echo Usage: $0 SNAPSHOT
	exit 1
fi

for k8sdom in ${KVM_DOMAINS}; do
	virsh snapshot-create-as \
		--domain $k8sdom \
		--name $SNAPSHOT
done

