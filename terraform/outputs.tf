output "aws_vpc_id" {
  description = "aws_vpc.main created ip"
  value = aws_vpc.main.id
}

output "aws_subnet_id" {
  description = "aws_subnet.subnet created ip"
  value = aws_subnet.subnet.id
}

output "aws_instance_k8s_master_ip" {
  description = "aws_instance_k8s_master created ip"
  value = aws_eip.master-eip.public_ip
}

output "aws_instance_k8s_worker1_ip" {
  description = "aws_instance_k8s_worker1 created ip"
  value = aws_eip.worker-eip1.public_ip
}

output "aws_instance_k8s_worker2_ip" {
  description = "aws_instance_k8s_worker2 created ip"
  value = aws_eip.worker-eip2.public_ip
}
