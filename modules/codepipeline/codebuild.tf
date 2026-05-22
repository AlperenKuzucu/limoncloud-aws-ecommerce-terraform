resource "aws_codebuild_project" "app-project-env" {
  for_each = local.app-project-env-codepipeline

  name           = "${each.key}-build"
  description    = "${each.key}-build build and ship project"
  build_timeout  = "30"
  queued_timeout = "480"
  service_role   = aws_iam_role.app-project-env-codebuild-role.arn
  source_version = "refs/heads/${each.value.branch}"

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
  }

  environment {
    compute_type                = each.value.compute_type
    image                       = each.value.image
    type                        = "LINUX_CONTAINER" #"ARM_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  vpc_config {
    security_group_ids = [aws_security_group.app-project-env-codebuild.id]
    subnets            = var.private_subnets
    vpc_id             = var.vpc_id
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("../modules/codepipeline/buildspec_files/buildspec-${each.key}.yml")
  }
}