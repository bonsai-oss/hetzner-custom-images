source "qemu" "debian12" {
  iso_url           = "https://mirror.hetzner.com/bootimages/iso/debian-12.1.0-amd64-netinst.iso"
  iso_checksum      = "md5:8d77d1b0bcfef29e4d56dc0fbe23de15"
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
  vm_name           = "debian-12"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "5s"
  machine_type      = "q35"
  boot_command      = [
    "<down><tab>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian12-preseed.cfg ",
    "auto=true ",
    "priority=critical ",
    "passwd/root-password=packer ",
    "passwd/root-password-again=packer ",
    "<enter><wait>",
  ]
  qemuargs          = [["-cpu", "host"], ["-smp", "6"], ["-m", "8192M"]]
}

variable "headless" {
  type    = bool
  default = false
}

variable "accelerator" {
  type    = string
  default = "kvm"
}

build {
  sources = ["source.qemu.debian12"]

  provisioner "shell" {
    scripts = [
      "scripts/prepare.sh",
      "scripts/cleanup.sh"
    ]
  }

  post-processor "shell-local" {
    name   = "tarball"
    inline = ["/usr/bin/guestfish -a output/debian-12 --ro -i tar-out / output/debian-12-amd64-base.tar.gz compress:gzip numericowner:true xattrs:true selinux:true acls:true"]
  }

}

