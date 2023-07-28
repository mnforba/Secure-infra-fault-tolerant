# Create an AWS VPC
resource "aws_vpc" "secure-vpc" {
    cidr_block       = var.vpc-cidr 
    instance_tenancy = "default"

    tags = {
        Name = var.vpc_name
    }
}

# Create first public subnet in the VPC
resource "aws_subnet" "pubsub1" {
    vpc_id                  = aws_vpc.secure-vpc.id 
    cidr_block              = var.pubsub1_cidr
    availability_zone       = var.availability_zone-1
    map_public_ip_on_launch = true

    tags = {
        Name = var.pubsub1-name 
    }
}

# Create second public subnet in the VPC
resource "aws_subnet" "pubsub2" {
    vpc_id                  = aws_vpc.secure-vpc.id 
    cidr_block              = var.pubsub2_cidr
    availability_zone       = var.availability_zone-2
    map_public_ip_on_launch = true

    tags = {
        Name = var.pubsub2-name 
    }
}

# Create first private subnet in the VPC
resource "aws_subnet" "privsub1" {
    vpc_id                  = aws_vpc.secure-vpc.id 
    cidr_block              = var.privsub1_cidr
    availability_zone       = var.availability_zone-1
    map_public_ip_on_launch = true

    tags = {
        Name = var.privsub1-name 
    }
}

# Create second private subnet in the VPC
resource "aws_subnet" "privsub2" {
    vpc_id                  = aws_vpc.secure-vpc.id 
    cidr_block              = var.privsub2_cidr
    availability_zone       = var.availability_zone-2
    map_public_ip_on_launch = true

    tags = {
        Name = var.privsub2-name 
    }
}