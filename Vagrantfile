# A dummy plugin for DockerRoot to set hostname and network correctly at the very first `vagrant up`
module VagrantPlugins
  module GuestLinux
    class Plugin < Vagrant.plugin("2")
      guest_capability("linux", "change_host_name") { Cap::ChangeHostName }
      guest_capability("linux", "configure_networks") { Cap::ConfigureNetworks }
    end
  end
end

Vagrant.configure(2) do |config|
  config.vm.define "docker-root-pkg", primary: true

  config.vm.box = "ailispaw/docker-root"

  config.vm.box_version = ">= 1.3.9"

  config.vm.provider :virtualbox do |vb|
    vb.memory = 2048
  end

  config.vm.hostname = "docker-root-pkg"

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder ".", "/vagrant", type: "nfs",
    mount_options: ["nolock", "vers=3", "udp", "noatime", "actimeo=1"]
end
