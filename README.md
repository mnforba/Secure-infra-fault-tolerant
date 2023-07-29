# Secure-infra-fault-tolerant
Using terraform to deploy an auto scaling group and application load balancer for high availability and scalability
                     ![aws](https://github.com/mnforba/Secure-infra-fault-tolerant/assets/88167119/f1090ede-2334-4b04-bf4b-7df8747ddbbe)

### What is Terraform?

Terraform is an open-source infrastructure as a code (IAC) tool that allows to create, manage & deploy the production-ready environment. Terraform codifies cloud APIs into declarative configuration files. Terraform can manage both existing service providers and custom in-house solutions.

### Project Scenario:
A client needs to handle a surge in traffic. The client wants to insure that their website remains available and responsive to customers even during high traffic periods.
* The project can be used to launch an Autoscaling group that spans two subnets in a default VPC, ensuring high availability and fault tolerance. 
* A security group is created that allows traffic form the internet and associates it with the instances in the Autoscaling group.
* To ensure that the Autoscaling group has the appropriate capacity, it is set to have a minimum of two instances and a maximum of five. This will ensure that the website can handle an increase in traffic while also minimizing costs during low traffic.
* The public IP addresses of the two instances are checked to verify that everything is working properly. One of the instances is manually terminated to verify that another one spins up to meet the minimum requirement of two instances.
* To ensure that the infra is reliable and can be easily managed, an S3 bucket is created and set as a remote backend for terraform. This ensures that the infra is versioned and can be easily rolled back if necessary.


### Prerequisites:

* Basic knowledge of AWS & Terraform
* AWS account
* IDE
* AWS Access & Secret Key

> You can clone or fork this repository to your local and use the code from [mnforba](https://github.com/mnforba/Secure-infra-fault-tolerant). 

**Step 1:- Configure the Environment**
- Configure your environment to ensure that we do not hardcode any sensitive information (IAM Access Key and Secret Access Key) within our code.
  use the command:`export AWS_ACCESS_KEY_ID="<access_key>" && export AWS_SECRET_ACCESS_KEY="<secret_access_key>"`

**Step 2:- Create a file for the VPC**

* Create and configure a custome AWS `vpc.tf` file and add code from the code base.
* A logically isolated CIDR block is defined and appropriate subnets selected and corresponding availability zones (AZ) deployed in them.

**Step 3:- Create a file for the Internet Gateway and NAT Gateway**

* One way to ensure that resources are connected to the internet in a secure VPC is by creating an Internet Gateway and NAT Gateway in the public subnet.
* An Internet Gateway allows communication between instances in the VPC and the internet. 
* A NAT Gateway is used to enable instances in private subnets to connect to the internet or other AWS services, while also providing additional security for outbound traffic.
* Create `gateway.tf` file and add code from the code base
  
**Step 4:- Configure a public route table and private route table**

* Setting  up route tables will be effective in directing the network traffic between the subnets.
* Create a `rt.tf` file and add code from the code base

**Step 5:- Launch the ALB in the public subnets**

* Create `alb.tf` file and add code from the code base

**Step 6:- Create a New Load Balancer**

* Create `newlb.tf` file and add the code from the code base

**Step 7:- Develop a bash script**

* To prepare for the creation of our ASG, we develop a bash script `bash.sh` that will be incorporated into the ASG's Launch Template. 
* This script will server as the EC2 instance's user data, automating the installation, initiation of the Apache web service and creation of a personalized web page.

**Step 8:- ASG Creation and Configuration**

* Create `asg.tf` file and add the code from the code base

**Step 9:- Utilize `output.tf` file to obtain public DNS of ALB**

* Create an `output.tf` file which provides an easy solution to instantly obtain the public DNS of the ALB and ensure that incoming traffic is correctly routed to the instances in the target group.

**Step 10:- Create Variables the resource arguments**

* Create a `variables.tf` file and add code from the code base
* Variables helps to ensure consistency accross deployments, make code easier to read and maintain, and enable reusability of code.


So, now our entire code is ready. We need to run the below steps to create infrastructure.


* `terraform init` is to initialize the working directory and downloading plugins of the provider,
                ![init](https://github.com/mnforba/Secure-infra-fault-tolerant/assets/88167119/0ca95467-3afd-4e21-9578-ac8b93018642)

* `terraform validate` to validate our code base to ensure no syntax errors in our code
                ![validate](https://github.com/mnforba/Secure-infra-fault-tolerant/assets/88167119/92b4467f-1ea0-427c-bcd0-ba7f757e3186)
* `terraform plan` is to create the execution plan for our code
                ![plan1](https://github.com/mnforba/Secure-infra-fault-tolerant/assets/88167119/257ea82c-b120-422b-8557-3272f038af06)
                 ![plan2](https://github.com/mnforba/Secure-infra-fault-tolerant/assets/88167119/0a1afeb5-5f82-455a-95dc-6d5025e12a30)
* `terraform apply` is to create the actual infrastructure.
                 ![apply](https://github.com/mnforba/Secure-infra-fault-tolerant/assets/88167119/f73adfe7-2907-40f2-9d1a-9ccefddf920b)

**Step 13:- Verify the resources**

* Terraform will create below resources. Navigate to the AWS console and verify that the resources have been created

  * VPC
  * Application Load Balancer
  * Public & Private Subnets
  * EC2 instances
  * Launch template
  * Auto Scaling groups
  * Internet Gateway
  * Security Groups 
  * Route Table

Once the resource creation finishes you can get the DNS of a load balancer and paste it into the browser and you can see load balancer will send the request to two instances.
* To test our Auto Scaling Group, terminate one of your running instances. You should see the ASG create a replacement.

That’s it now, you can destroy or clean up the infrastructure using `terraform destroy`
