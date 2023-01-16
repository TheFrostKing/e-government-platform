# Create an Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.subnets.*.id
  
# Disable deletion protection
  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}-alb-${var.environment}"
    Environment = var.environment
  }
}

# Create a target group for the frontend
resource "aws_alb_target_group" "frontend" {
  name        = "frontend-tg-${var.environment}"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

# Health check for the frontend
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_front
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.name}-tg-${var.environment}"
    Environment = var.environment
  }
}

# Create a target group for the backend
resource "aws_alb_target_group" "backend" {
  name        = "backend-tg-${var.environment}"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

# Health check for the backend
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTPS"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_back
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.name}-tg-${var.environment}"
    Environment = var.environment
  }
}


# Redirect to https listener
resource "aws_alb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.main.id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.alb_tls_cert_arn


  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.frontend.id
  }
}

# Redirect traffic to target group
resource "aws_alb_listener" "backend_listener" {
    load_balancer_arn = aws_lb.main.id
    port              = 444
    protocol          = "HTTPS"

    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = var.alb_tls_cert_arn

    default_action {
     type = "forward"
     target_group_arn = aws_alb_target_group.backend.id
    }
}

# Output the value of the target group so it can be refrenced in the root module
output "aws_alb_target_group_front" {
  value = aws_alb_target_group.frontend.arn
}

# Output the value of the target group so it can be refrenced in the root module
output "aws_alb_target_group_back" {
  value = aws_alb_target_group.backend.arn
}

# Output the value of the ALB so it can be refrenced in the root module
output "alb_arn" {
  value = aws_lb.main.id
}
