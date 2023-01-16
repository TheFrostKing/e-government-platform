# Create security group for ALB
resource "aws_security_group" "alb" {
  name   = "${var.name}-sg-alb-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.name}-sg-alb-${var.environment}"
    Environment = var.environment
  }
}

# Create security group for ECS front-end
resource "aws_security_group" "ecs_front" {
  name   = "${var.name}-sg-front-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 0
    to_port          = 65535
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.name}-sg-task-${var.environment}"
    Environment = var.environment
  }
}

# Create security group for ECS back-end
resource "aws_security_group" "ecs_back" {
  name   = "${var.name}-sg-back-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 0
    to_port          = 65535
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.name}-sg-task-${var.environment}"
    Environment = var.environment
  }
}

# Create security group for Grafana
resource "aws_security_group" "grafana" {
  name        = "grafana"
  description = "Grafana"
  vpc_id = var.vpc_id
 
  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
  tags = {
    Name = "grafana"
  }
}

resource "aws_security_group" "rds" {
  name   = "RDS"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for Graylog
resource "aws_security_group" "graylog" {
  name        = "Graylog"
  description = "Graylog"
  vpc_id = var.vpc_id
 
  ingress {
    protocol         = "tcp"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Output the value of the rds security group so it can be refrenced in the root module
output "rds" {
  value = aws_security_group.rds.id
}

# Output the value of the graylog security group so it can be refrenced in the root module
output "graylog" {
  value = aws_security_group.graylog.id
}

# Output the value of the grafana security group so it can be refrenced in the root module
output "grafana" {
  value = aws_security_group.grafana.id
}

# Output the value of the ALB security group so it can be refrenced in the root module
output "alb" {
  value = aws_security_group.alb.id
}

# Output the value of the ECS front-end security group so it can be refrenced in the root module
output "ecs_front" {
  value = aws_security_group.ecs_front.id
}

# Output the value of the ECS backend security group so it can be refrenced in the root module
output "ecs_back" {
  value = aws_security_group.ecs_back.id
}