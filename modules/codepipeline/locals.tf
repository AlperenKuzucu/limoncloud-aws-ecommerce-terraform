locals {
  app-project-env-codepipeline = {

    magento = {
      branch       = "main"
      compute_type = "BUILD_GENERAL1_SMALL"
      image        = "aws/codebuild/standard:7.0"

      FullRepositoryId = "AlperenKuzucu/limoncloud-101-magento"
    }
  }
}
