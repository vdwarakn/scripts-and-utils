## Scripts and configs to enable Gaudi devices in Docker and K8

The configs in this page will run on Ubuntu. Other distros haven't been tested.

To install the configuration files use the script:
<code>
bash ./install-container-runtimes.sh
<code>

The script will add repositories for Docker and K8.
It will then install required packages and apply the configurations required for Gaudi.

List of files:

---------------
|File Name | Purpose |
----------------------
| install-container-runtimes.sh | Installation script |
| environment | Sample environment file with proxy vars commented out |
| docker-gaudi-proxy.json | Docker daemon.json with habana-runtime and proxy |
| systemctl-containerd.conf | systemctl config override for ContainerD. Use if behind a corporate proxy |
| config.toml | ContainerD configuration to use habana-runtime |
| runtime-class.yaml | Runtime class for Kubernetes to enable habana-runtime |
| 90-sysctl-ipforward-enable.conf |  Enable IP forwarding on Host |
