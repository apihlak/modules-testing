# Fetch the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS Account ID for official Ubuntu AMIs
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Fetch Cloudflare Zero Trust IPs
module "zt_whitelist" {
  source = "https://yolo-terraform-modules.s3.eu-central-1.amazonaws.com/defaults/whitelist-v0.0.4.tar.gz"
}

