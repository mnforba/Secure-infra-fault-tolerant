# Create security group for the ALB
resource "aws_security_group" "alb-sg" {
    # set name and description of the sg
    name        = var.alb_sg_name
    description = var.alb_sg_description

    # Set the VPC ID where the security group will be created
    vpc_id = aws_vpc.secure-vpc.id 
    depends_on = [ aws_vpc.secure-vpc ]

    # Inbound Rule
    # HTTP access from anywhere
    ingress {
        description = "Allow HTTP traffic"
        from_port   = var.http_port 
        to_port     = var.http_port 
        protocol    = "tcp"
        cidr_blocks = var.alb_sg_ingress_cidr_blocks
    }

    # SSH access from anywhere
    ingress {
        description = "Allow SSH traffic"
        from_port   = var.ssh_port 
        to_port     = var.ssh_port 
        protocol    = "tcp"
        cidr_blocks = var.alb_sg_ingress_cidr_blocks
    }

    # Inbound Rule
    # Allow all egress traffic
    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = var.alb_sg_egress_cidr_blocks
    }

    # Set tags for the security group
    tags = {
        Name = "ALB SG"
    }
}