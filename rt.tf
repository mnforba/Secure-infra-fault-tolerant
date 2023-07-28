# Create a public route table with a default route to the internet gateway
resource "aws_route_table" "pub-rt" {
    vpc_id = aws_vpc.secure-vpc.id

    # Create a default route for the internet gateway with destination 0.0.0.0/0
    route {
        cidr_block = var.pub_rt_cidr
        gateway_id = aws_internet_gateway.secure-igw.id 
    }
    tags = {
        Name = var.pub-rt-name 
    }
}

# Create a private route table with a default route to the NAT gateway
resource "aws_route_table" "priv-rt" {
    vpc_id = aws_vpc.secure-vpc.id

    route {
        cidr_block = var.priv_rt_cidr
        gateway_id = aws_nat_gateway.secure-ngw.id
    }
    tags = {
        Name = var.priv-rt-name 
    }
}

# Associate the public route table with the public subnet 1
resource "aws_route_table_association" "pubsub1-rt-ass" {
    subnet_id = aws_subnet.pubsub1.id 
    route_table_id = aws_route_table.pub-rt.id
}

# Associate the public route table with the public subnet 2
resource "aws_route_table_association" "pubsub2-rt-ass" {
    subnet_id = aws_subnet.pubsub2.id 
    route_table_id = aws_route_table.pub-rt.id
}

# Associates the private route table with the private subnet 1
resource "aws_route_table_association" "privsub1-rt-ass" {
    subnet_id = aws_subnet.privsub1.id 
    route_table_id = aws_route_table.priv-rt.id
}

# Associates the private route table with the private subnet 2
resource "aws_route_table_association" "privsub2-rt-ass" {
    subnet_id = aws_subnet.privsub2.id 
    route_table_id = aws_route_table.pub-rt.id

    # Wait for the private route table to be created before creating this association
    depends_on = [aws_route_table.priv-rt]
}