provider "aws" {
  access_key = "**********"
  secret_key = "**********"
  region     = "us-east-2"
}

#######instance
resource "aws_instance" "my_ubuntu1" {
  ami           = "ami-0d5d9d301c853a04a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet-public-1.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_22.id}"]
  key_name = "${aws_key_pair.ec2key.key_name}"


  tags = {
    Name = "main"
  }
}

############key
resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = "**************"
}


resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}


resource "aws_subnet" "subnet-public-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.11.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2a"
    tags = {
        Name = "subnet-public-1"
    }
}

resource "aws_subnet" "subnet-public-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.12.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2b"
    tags = {
        Name = "subnet-public-2"
    }
}


########internet GW
resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.main.id}"
}

## Elastic IP for NAT GW (выход в инет всегда с одного ip)
resource "aws_eip" "eip1" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gateway"]
}

resource "aws_eip" "eip2" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gateway"]
}


resource "aws_nat_gateway" "gateway1" {
  allocation_id = "${aws_eip.eip1.id}"
  subnet_id     = "${aws_subnet.subnet-public-1.id}"
  depends_on = ["aws_internet_gateway.gateway"]

  tags = {
    Name = "gateway1"
  }
}


resource "aws_nat_gateway" "gateway2" {
  allocation_id = "${aws_eip.eip2.id}"
  subnet_id     = "${aws_subnet.subnet-public-2.id}"
  depends_on = ["aws_internet_gateway.gateway"]

  tags = {
    Name = "gateway2"
  }
}


###############route
resource "aws_route_table" "subnet-public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gateway.id}"
    }

    tags =  {
        Name = "inet routing"
    }
}


resource "aws_route_table_association" "rta_subnet_public1" {
  subnet_id      = "${aws_subnet.subnet-public-1.id}"
  route_table_id = "${aws_route_table.subnet-public.id}"
}
#______________________________________________________________

resource "aws_route_table_association" "rta_subnet_public2" {
  subnet_id      = "${aws_subnet.subnet-public-2.id}"
  route_table_id = "${aws_route_table.subnet-public.id}"
}

resource "aws_instance" "my_ubuntu2" {
  ami           = "ami-0d5d9d301c853a04a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.subnet-public-2.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_22.id}"]
  key_name = "${aws_key_pair.ec2key.key_name}"


  tags = {
    Name = "main"
  }
}



#________________________________________________________________
######security_group
resource "aws_security_group" "sg_22" {
  name = "sg_22"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "aws_my_security_group"
  }
#
}
