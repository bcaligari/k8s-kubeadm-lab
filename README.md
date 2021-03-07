# 6 node kubernetes cluster

Half baked automation to stand up a small k8s lab cluster the `kubadm` way.
These scripts were written to meet my specific needs within my home lab
environment and not intended for public consumption.

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
* `./vms-start.sh` - start all KVM domains
* `./vms-revert-snapshot.sh` - revert to snapshot passed as only parameter
* `./inventory.yaml` - Ansible inventory of all VMs
* `./stop-all.sh` - shutdown all the VMs in Ansible inventory

## Installation workflow

* Freshly installed VMs with `sysop` user with full `sudo` access.
  * kvm snapshot `sudo`
* Clean up and provision VMs.
  * `ansible-playbook -i inventory.yaml playbook-provision-vm.yaml`
* Install `containerd`, `kubeadm`, `kubelet`, and `kubectl` on all nodes.
  * `ansible-playbook -i inventory.yaml playbook-k8s-addons.yaml`
* Initialise the first admin node and deploy Calico as CNI.
  * `ansible-playbook -i inventory.yaml playbook-init-controlplane.yaml`
* Join remaining control nodes and worker nodes.
  * `ansible-playbook -i inventory.yaml playbook-join-nodes.yaml`

## TODO

* Track changes to Containerd default config.
* Track changes to Calico `custom-resources.yaml`.
* Track updates to repo GPG keys
* Put an LB in front of control plane

## Reminders

* To use the cluser make sure the right `kubectl` is in `~/bin` and
  `KUBECONFIG` set to `./cluser/admin.conf`.
