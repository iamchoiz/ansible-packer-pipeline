version            = "v0.1"
ami_name           = "packer--ami" // 필수 수정
ami_description    = " on Amazon-Linux in AWS EC2" // 필수 수정
playbook_file_path = "../playbook/.yml" // 필수 수정
tags               = {
    Service = "DevOps"
}
// 정의된 Base AMI가 없을 경우 source_ami_fileter & source_ami_owners 사용
source_ami_filter = {
    name                = "amzn2-ami-hvm-2.0.*-x86_64-gp2"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
}
source_ami_owners  = ["amazon"]
// 정의된 Base AMI를 사용할 경우 경우 source_ami 사용
source_ami = "ami-0ef93af1d5156a18e" // 보안취약점 설정 적용됨 BASE AMI

// 기본 VPC가 없을 경우 VPC 설정 필요
vpc_id = "vpc-089a0cd9bbb33ad19"
subnet_id = "subnet-0c6d947eeed4e675c"
// SG는 Packer & Ansible 서버의 22포트 오픈 필요
security_group_id = "sg-0c59847799e86fdd3"


region = "ap-northeast-2"
instance_type = "t2.micro"
ssh_username = "ec2-user"
