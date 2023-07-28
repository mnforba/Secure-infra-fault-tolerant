output "vpc-id" {
    value = aws_vpc.secure-vpc.id
}

output "pubsub1-id" {
    value = aws_subnet.pubsub1.id
}

output "pubsub2-id" {
    value = aws_subnet.pubsub2.id
}
output "privsub1-id" {
    value = aws_subnet.privsub1.id
}
output "privsub2-id" {
    value = aws_subnet.privsub2.id
}
output "secure-igw" {
    value = aws_internet_gateway.secure-igw.id
}
output "alb-dns" {
    value = aws_lb.pub-sub-alb.dns_name
}