# Creating security group for Auto Scaling Group launch template
resource "aws_security_group" "lt-sg" {
    name = var.lt_sg_name
    vpc_id = aws_vpc.secure-vpc.id

    # Inbound Rules
    # HTTP access from anywhere
    ingress {
        from_port       = var.http_port
        to_port         = var.http_port
        protocol        = "tcp"
        security_groups = [aws_security_group.alb-sg.id]
    }

    # SSH access from anywhere
    ingress {
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        security_group = [aws_security_group.alb-sg.id]
    }

    # Outbound Rules
    # Internet access to anywhere
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = var.lt_sg_egress_cidr_blocks
    }
}

# ASG Creation and Configuration
# Create an autoscaling group with the specified configurations
resource "aws_autoscaling_group" "asg" {
    name                  = var.asg_name
    min_size              = var.asg_min
    max_size              = var.asg_max
    desired_capacity      = var.asg_des_cap
    vpc_zone_identifier   = [aws_subnet.prvsub1.id, aws_subnet.privsub2.id]
    lunch_template {
        id = aws_launch_template.lt-asg.id
    }
    tag {
        key                 = "Name"
        value               = "Private Sub ASG"
        propagate_at_launch = true
    }
}

# Create a launch template with the specified configurations
resource "aws_launch_template" "lt-asg" {
    name                     = var.lt_asg_name
    image_id                 = var.lt_asg_ami
    instance_type            = var.lt_asg_instance_type
    key_name                 = var.lt_asg_key
    vpc_security_group_ids   = [aws_security_group.lt-sg.id]
    user_data                = filebase64("{path.root}/install-apache.sh")
}

# Attach the autoscaling group to the target group of the ALB
resource "aws_autoscaling_attachment" "asg-tg-attach" {
    autoscaling_group_name = aws_autoscaling_group.asg.id
    lb_target_group_arn    = aws_lb_target_group.alb-tg.arn
}