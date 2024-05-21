output "aws_vpc_id" {
  description = "aws_vpc.main created ip"
  value = aws_vpc.main.id
}

output "aws_subnet_id" {
  description = "aws_subnet.subnet created ip"
  value = aws_subnet.subnet.id
}

output "aws_instance_k8s_master" {
  description = "aws_instance_k8s_master created ip"
  value = aws_instance.k8s_master.id
}

#output "aws_instance_k8s_worker" {
#  description = "aws_instance_k8s_worker created ip"
#  value = aws_instance.k8s_worker[count.index].id
#}

output "aws_instance_k8s_worker" {
  description = "aws_instance_k8s_worker created ip"
  value = [for instance in aws_instance.k8s_worker : instance.public_ip ]
}
