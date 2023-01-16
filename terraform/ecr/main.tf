# Create front-end repository 
resource "aws_ecr_repository" "front_end_repo" {
  name = "front_end_terra"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Create back-end repository 
resource "aws_ecr_repository" "back_end_repo" {
  name = "back_end_terra"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Output front-end repository so it can be refrenced in the root module 
output "front_ecr_repo" {
  value = aws_ecr_repository.front_end_repo
}

# Output back-end repository so it can be refrenced in the root module
output "back_ecr_repo" {
  value = aws_ecr_repository.back_end_repo
}