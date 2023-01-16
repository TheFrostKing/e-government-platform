# Specify the ECS task execution IAM role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Specify the ECS task IAM role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-ecsTaskRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach the task execution IAM role
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create a CloudWatch group for the front-end
resource "aws_cloudwatch_log_group" "front" {
  name = "/ecs/front-task-${var.environment}"

  tags = {
    Name        = "${var.name}-task-${var.environment}"
    Environment = var.environment
  }
}

# Create a CloudWatch group for the back-end
resource "aws_cloudwatch_log_group" "back" {
  name = "/ecs/back-task-${var.environment}"

  tags = {
    Name        = "${var.name}-task-${var.environment}"
    Environment = var.environment
  }
}

# Create a ECS task definition for the front-end
resource "aws_ecs_task_definition" "front" {
  family                   = "Frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 8192
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = jsonencode([{
    name        = "front-service-${var.environment}"
    image       = "${var.front_ecr_repo}"
    essential   = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 3000
      hostPort      = 3000
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.front.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
}])

  tags = {
    Name        = "front-task-${var.environment}"
    Environment = var.environment
  }
}

# Create a ECS task definition for the back-end
resource "aws_ecs_task_definition" "back" {
  family                   = "Backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = jsonencode([{
    name        = "back-service-${var.environment}"
    image       = "${var.back_ecr_repo}"
    essential   = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = 5000
      hostPort      = 5000
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.back.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
}])

  tags = {
    Name        = "back-task-${var.environment}"
    Environment = var.environment
  }
}

# Create an ECS cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.name}-cluster-${var.environment}"
  tags = {
    Name        = "${var.name}-cluster-${var.environment}"
    Environment = var.environment
  }
}

# Create a ECS service for the front-end
resource "aws_ecs_service" "front" {
  name                               = "front-service-${var.environment}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.front.arn
  desired_count                      = var.service_desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.public_subnets.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_front
    container_name   = "front-service-${var.environment}"
    container_port   = 3000
  }

  # we ignore task_definition changes as the revision changes on deploy
  # of a new version of the application
  # desired_count is ignored as it can change due to autoscaling policy
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

# Create a ECS service for the back-end
resource "aws_ecs_service" "back" {
  name                               = "back-service-${var.environment}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.back.arn
  desired_count                      = var.service_desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.private_subnets.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_back
    container_name   = "back-service-${var.environment}"
    container_port   = 5000
  }

  # we ignore task_definition changes as the revision changes on deploy
  # of a new version of the application
  # desired_count is ignored as it can change due to autoscaling policy
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

# Create AutoScaling for the front-end
resource "aws_appautoscaling_target" "ecs_target_front" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.front.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Create AutoScaling for the back-end
resource "aws_appautoscaling_target" "ecs_target_back" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.back.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Create AutoScaling memory policy for the front-end
resource "aws_appautoscaling_policy" "ecs_policy_memory_front" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_front.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_front.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_front.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

# Create AutoScaling memory policy for the back-end
resource "aws_appautoscaling_policy" "ecs_policy_memory_back" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_back.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_back.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_back.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

# Create AutoScaling cpu policy for the front-end
resource "aws_appautoscaling_policy" "ecs_policy_cpu_front" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_front.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_front.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_front.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

# Create AutoScaling cpu policy for the back-end
resource "aws_appautoscaling_policy" "ecs_policy_cpu_back" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_back.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_back.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_back.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
