data "aws_codestarconnections_connection" "app-project-env" {
  name = "app-project-env-integration"
}

##############################################################
##############################################################
##############################################################


resource "aws_s3_bucket" "app-project-env" {
  for_each = local.app-project-env-codepipeline

  bucket = "${each.key}-codepipeline"
}

##############################################################


resource "aws_codepipeline" "app-project-env" {
  for_each = local.app-project-env-codepipeline

  name          = "${each.key}-pipeline"
  pipeline_type = "V2"
  role_arn      = aws_iam_role.app-project-env-codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.app-project-env[each.key].bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      namespace        = "SourceVariables"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]
      configuration = {
        DetectChanges    = "false"
        ConnectionArn    = data.aws_codestarconnections_connection.app-project-env.arn
        FullRepositoryId = each.value.FullRepositoryId
        BranchName       = each.value.branch
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      namespace        = "BuildVariables"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      configuration = {
        ProjectName = "${each.key}-build"
      }
    }
  }


}