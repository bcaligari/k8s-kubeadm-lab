# 6 node kubernetes cluster

These are scripts I put together to stand up a small k8s lab cluster the
`kubadm` way.  This repository is my backup.  Those scripts were not written
for public consumption and are specific to my lab environment.

## Target

* 3 x master
* 3 x worker
* `kubeadm`, `kubelet`, `kubectl` : v1.20.2
* `containerd`

## Pre-requisities

* 6 'suitable' Ubuntu instances
  * Ubuntu 20.04.2
  * User `sysop` with full admin via sudo
* hostnames
  * `master[0-2]`
  * `worker[0-2]`
* DNS resolution
  * `*.lab.cypraea.co.uk`
  * `klb.lab.cypraea.co.uk` - eventually to point to an lb
* Ansible available

## Support files and scripts

* `./kvm-domains` - list of KVM domains for this project
* `./start-all.sh` - start all KVM domains
* `./revert-all.sh` - revert to snapshot passed as only parameter
* `./inventory.yaml` - Ansible inventory of all VMs
* `./stop-all.sh` - shutdown all the VMs in Ansible inventory

## Installation workflow

* Freshly installed VMs with `sysop` user with full `sudo` access.
* Clean up and provision VMs.
  * `ansible-playbook -i inventory.yaml playbook-provision-vm.yaml`
* Install `containerd` on all nodes.
  * `ansible-playbook -i inventory.yaml playbook-containerd.yaml`
* Install `kubeadm`, `kubelet`, and `kubectl` on all nodes.
  * `ansible-playbook -i inventory.yaml playbook-kubexxx.yaml`
* Initialise the first admin node - run once.
  * `ansible-playbook -i inventory.yaml playbook-init-controlplane.yaml`
* Initialise Calico on first admin node - run once.
  * `ansible-playbook -i inventory.yaml playbook-deploy-cni.yaml`
* TODO - automate provisioning of rest of the nodes

## To Automate

* Track changes to Containerd default config.
* Track changes to Calico `custom-resources.yaml`.
* Track updates to repo GPG keys

