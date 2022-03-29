source "amazon-ebs" "amazon_linux" {
  ami_name          = "${var.ami_name}-${var.version}"
  ami_description   = var.ami_description

  instance_type     = var.instance_type
  region            = var.region
  ssh_username      = var.ssh_username
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  security_group_id = var.security_group_id

  source_ami_filter {
    filters = var.source_ami_filter
    owners      = var.source_ami_owners
    most_recent = true
  }
  
  // 정의된 Base AMI를 사용할 경우 경우 source_ami_filter{} 대신 source_ami 사용
  # source_ami        = var.source_ami


  tags = merge(var.tags, 
  { 
    "Name" = "${var.ami_name}-${var.version}", 
    "BaseAMI_Id"   = "{{ .SourceAMI }}",
    "BaseAMI_Name" = "{{ .SourceAMIName }}"
  })
}

build {
  name    = "aws-ami-build"
  sources = [
    "amazon-ebs.amazon_linux",
  ]
  provisioner "ansible" {
    playbook_file = var.playbook_file_path
  }
}
