packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "version" {
  type = string
}

source "amazon-ebs" "ubuntu" {
  ami_name        = "github-runner-ubuntu-18.04-arm64-${var.version}"
  ami_description = "GitHub actions self-hosted runner on Ubuntu 18.04 (arm64)" 
  instance_type   = "t4g.small"
  region          = var.aws_region
  ami_regions     = []
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-bionic-18.04-arm64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    script          = "bootstrap.sh"
    execute_command = "sudo bash {{ .Path }}"
  }
}
