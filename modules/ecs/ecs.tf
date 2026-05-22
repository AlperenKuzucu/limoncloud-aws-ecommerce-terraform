locals {
  ecs_locals = {
    magento = {
      image         = "bitnami/magento:2.4.6" # Magento 2.4.6 uses PHP 8.1
      containerPort = [80]
      hostPort      = [80]

      target_group_arn  = var.target_group_arn
      lb_container_port = 80

      cpu    = 2048
      memory = 4096
    }
  }
}


resource "aws_ecs_cluster" "app-project-env" {
  name = "app-project-env-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


resource "aws_ecs_cluster_capacity_providers" "app-project-env" {
  cluster_name       = aws_ecs_cluster.app-project-env.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}


resource "aws_ecs_service" "app-project-env" {
  for_each = local.ecs_locals

  name            = each.key
  cluster         = aws_ecs_cluster.app-project-env.id
  task_definition = aws_ecs_task_definition.app-project-env[each.key].arn
  desired_count   = 2
  propagate_tags  = "SERVICE"

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 0
  platform_version                   = "LATEST"
  enable_ecs_managed_tags            = true


  network_configuration {
    security_groups = ["${aws_security_group.ecs-sg.id}"]
    subnets         = var.ecs_subnets
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 1
  }

  dynamic "load_balancer" {
    for_each = lookup(each.value, "target_group_arn", null) != null ? [each.value] : []
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = each.key
      container_port   = load_balancer.value.lb_container_port
    }
  }
  dynamic "load_balancer" {
    for_each = lookup(each.value, "target_group_arn_int", null) != null ? [each.value] : []
    content {
      target_group_arn = load_balancer.value.target_group_arn_int
      container_name   = each.key
      container_port   = load_balancer.value.lb_container_port
    }
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = [aws_ecs_task_definition.app-project-env]

  lifecycle {
    ignore_changes = [desired_count]
  }

  # lifecycle {
  #   ignore_changes = [task_definition]
  # }
}

resource "aws_ecs_task_definition" "app-project-env" {
  for_each = local.ecs_locals

  family       = "td-${each.key}"
  network_mode = "awsvpc"
  cpu          = each.value.cpu
  memory       = each.value.memory

  container_definitions = jsonencode([
    {
      name      = each.key
      image     = each.value.image
      essential = true

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/${each.key}"
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = lookup(each.value, "containerPort", []) != [] ? [
        for i, containerPort in each.value.containerPort : {
          containerPort = containerPort
          hostPort      = each.value.hostPort[i]
          protocol      = "tcp"
          name          = "${each.key}-${each.value.hostPort[i]}-tcp"
        }
      ] : []

      environment = [
        for key, value in lookup(each.value, "environment", {}) : {
          name  = key
          value = tostring(value)
        }
      ]
    }
  ])

  requires_compatibilities = ["FARGATE"]

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64" #"ARM64"
  }

  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn      = aws_iam_role.ecsTaskExecutionRole.arn
}






resource "aws_appautoscaling_target" "app-project-env" {
  for_each = local.ecs_locals

  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.app-project-env.name}/${each.key}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "app-project-env_mem" {
  for_each = local.ecs_locals

  name               = "${each.key}-mem"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/${aws_ecs_cluster.app-project-env.name}/${each.key}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    disable_scale_in   = false
    scale_in_cooldown  = 150
    scale_out_cooldown = 30
    target_value       = 80

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }

  depends_on = [aws_appautoscaling_target.app-project-env]
}

resource "aws_appautoscaling_policy" "app-project-env_cpu" {
  for_each = local.ecs_locals

  name               = "${each.key}-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/${aws_ecs_cluster.app-project-env.name}/${each.key}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    disable_scale_in   = false
    scale_in_cooldown  = 150
    scale_out_cooldown = 30
    target_value       = 80

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }

  depends_on = [aws_appautoscaling_target.app-project-env]
}
