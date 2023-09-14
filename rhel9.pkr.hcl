source "qemu" "rhel9" {
  iso_url           = "https://s3.seq0.de:9000/manual-file-share/rhel-9.2-x86_64-dvd.iso"
  iso_checksum      = "md5:90cf58ff7a8f6ef8cb20b8ff091e84b7"
  headless          = var.headless
  accelerator       = var.accelerator
  output_directory  = "output"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  disk_size         = "5000M"
  format            = "qcow2"
  http_directory    = "http"
  ssh_username      = "root"
  ssh_password      = "packer"
  ssh_timeout       = "120m"
  vm_name           = "rhel-9"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "20s"
  boot_command      = ["<up><tab> inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rhel9-ks.cfg<enter><wait>"]
  qemuargs          = [["-cpu", "host"], ["-smp", "6"], ["-m", "8192M"]]
}

variable "headless" {
  type    = bool
  default = true
}

variable "accelerator" {
  type    = string
  default = "kvm"
}

build {
  sources = ["source.qemu.rhel9"]

  provisioner "shell" {
    script = "scripts/cleanup.sh"
  }

  post-processor "shell-local" {
    name   = "tarball"
    inline = ["/usr/bin/guestfish -a output/rhel-9 --ro -i tar-out / output/rhel-9-server.tar.gz compress:gzip numericowner:true xattrs:true selinux:true acls:true"]
  }

}

