# Scripts and configs to enable Gaudi devices in Docker and K8

The configs in this page will run on Ubuntu. Other distros haven't been tested.


## Install Ubuntu 24.04 OS
For a baremetal Gaudi hardware, one supported OS is Ubuntu and it needs to be installed on the machine first.

### Option 1: Manual
1. Create a bootable USB using the Official Ubuntu 24.04 ISO
2. Boot the Gaudi machine from USB and follow the manual installation process, with 2 changes:
* Install on the smallest disk attached to the system and also disable LVM
* This helps to keep the system modular and make it easy to reinstall or upgrade independently
* Install OpenSSH Server
* Supply proxy details, if required

### Option 2: Automated
Use the ubuntu24/ folder from this repo to install Ubuntu from ?USB or HTTP server. 
The instructions for using either method are available in the ubuntu24/README.md file

## Update OS
* Boot to the local SSD and load the Ubutnu OS for the first time
* Install all updates 
```bash
sudo apt update && sudo apt upgrade -y
```
* Reboot machine

## Install Gaudi Driver and SW Stack
The latest instructions for install of Gaudi Driver and stack are available at: https://docs.habana.ai/en/latest/Installation_Guide/Driver_Installation.html
1. You can alternatively use these steps to install:
```bash
## Temporary workaround for key
curl -fsSL https://vault.habana.ai/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/habanalabs.gpg > /dev/null

GAUDI_SW_VER=1.21.3
wget -nv https://vault.habana.ai/artifactory/gaudi-installer/${GAUDI_SW_VER}/habanalabs-installer.sh
sudo bash ./habanalabs-installer.sh install -y
```
2. After driver is installed, check that the devices are detected by running
```bash
hl-smi
```
3. You should see something like this:
<pre>
+-----------------------------------------------------------------------------+
| HL-SMI Version:                              hl-1.21.1-fw-59.2.3.0          |
| Driver Version:                                     1.21.1-bfcec49          |
| Nic Driver Version:                                 1.21.1-ead2cb0          |
|-------------------------------+----------------------+----------------------+
| AIP  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncor-Events|
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | AIP-Util  Compute M. |
|===============================+======================+======================|
|   0  HL-225              N/A  | 0000:33:00.0     N/A |                  21  |
| N/A   35C   P0  525W /  600W  | 94963MiB /  98304MiB |    88%           96% |
|-------------------------------+----------------------+----------------------+
|   1  HL-225              N/A  | 0000:34:00.0     N/A |                   0  |
| N/A   34C   P0   80W /  600W  |   768MiB /  98304MiB |     0%            0% |
|-------------------------------+----------------------+----------------------+
|   2  HL-225              N/A  | 0000:4e:00.0     N/A |                   0  |
| N/A   25C   P0   81W /  600W  | 90351MiB /  98304MiB |     0%           91% |
|-------------------------------+----------------------+----------------------+
|   3  HL-225              N/A  | 0000:9a:00.0     N/A |                   0  |
| N/A   23C   P0   83W /  600W  | 90356MiB /  98304MiB |     0%           91% |
|-------------------------------+----------------------+----------------------+
|   4  HL-225              N/A  | 0000:9b:00.0     N/A |                   0  |
| N/A   28C   P0   91W /  600W  | 90353MiB /  98304MiB |     0%           91% |
|-------------------------------+----------------------+----------------------+
|   5  HL-225              N/A  | 0000:b3:00.0     N/A |                   0  |
| N/A   29C   P0   82W /  600W  | 90352MiB /  98304MiB |     0%           91% |
|-------------------------------+----------------------+----------------------+
|   6  HL-225              N/A  | 0000:b4:00.0     N/A |                 176  |
| N/A   23C   P0   85W /  600W  | 82507MiB /  98304MiB |     0%           83% |
|-------------------------------+----------------------+----------------------+
|   7  HL-225              N/A  | 0000:4d:00.0     N/A |                   0  |
| N/A   27C   P0   92W /  600W  | 85926MiB /  98304MiB |     0%           87% |
|-------------------------------+----------------------+----------------------+
| Compute Processes:                                               AIP Memory |
|  AIP       PID   Type   Process name                             Usage      |
|=============================================================================|
|   0        N/A   N/A    N/A                                      N/A        |
|   1        N/A   N/A    N/A                                      N/A        |
|   2        N/A   N/A    N/A                                      N/A        |
|   3        N/A   N/A    N/A                                      N/A        |
|   4        N/A   N/A    N/A                                      N/A        |
|   5        N/A   N/A    N/A                                      N/A        |
|   6        N/A   N/A    N/A                                      N/A        |
|   7        N/A   N/A    N/A                                      N/A        |
+=============================================================================+
</pre>

## Install runtime and other configs
To install the configuration files use the scripts:
```bash
sudo bash ./install-container-runtimes.sh
sudo bash ./grub-setup.sh
```

The script will add repositories for Docker and K8.
It will then install required packages and apply the configurations required for Gaudi.

## List of files

|File Name | Purpose |
|--|--|
|install-container-runtimes.sh | Installation script |
|grub-setup.sh | Script to configure kernel boot time parameters applicable for Gaudi|
|environment | Sample environment file with proxy vars commented out |
|docker-gaudi-proxy.json | Docker daemon.json with habana-runtime and proxy |
|systemctl-containerd.conf | systemctl config override for ContainerD. Use if behind a corporate proxy |
|config.toml | ContainerD configuration to use habana-runtime |
|runtime-class.yaml | Runtime class for Kubernetes to enable habana-runtime |
|90-sysctl-ipforward-enable.conf |  Enable IP forwarding on Host |
