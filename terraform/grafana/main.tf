# Create ECS cluster for Grafana
resource "aws_ecs_cluster" "grafana" {
  name = "grafana"
}

# Create ECS task defenition for Grafana
resource "aws_ecs_task_definition" "grafana" {
  family                   = "grafana"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
 
  container_definitions = <<DEFINITION
[
  {
    "name": "grafana",
    "image": "grafana/grafana:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}

# Create ECS service for Grafana
resource "aws_ecs_service" "grafana" {
  name            = "grafana"
  cluster         = aws_ecs_cluster.grafana.id
  task_definition = aws_ecs_task_definition.grafana.arn
  desired_count   = 1
  network_configuration {
    subnets          = var.subnets.*.id
    security_groups  = var.grafana_service_security_groups
    assign_public_ip = true
  }
  launch_type = "FARGATE"
}