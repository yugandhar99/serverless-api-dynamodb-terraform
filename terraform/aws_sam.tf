# ----------------------------------------------------------------------
# Terraform Deploy template S3 Object from Yugandhar File
# ----------------------------------------------------------------------
resource "aws_s3_bucket_object" "yugandhar_deploy_object" {
  bucket = var.yugandhar_code_bucket
  key    = "yugandhar-deploy-templates/${var.app_name}-deploy-${timestamp()}.yaml"
  source = "../yugandhar/deploy.yaml"
  etag   = filemd5("../yugandhar/deploy.yaml")
}

# ----------------------------------------------------------------------
# SAM Stack 
# ----------------------------------------------------------------------
resource "aws_cloudformation_stack" "products_api_yugandhar_stack" {
  name         = "${var.app_name}-yugandhar-stack"
  capabilities = ["CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    AppName = var.app_name
  }

  template_url = "https://${var.yugandhar_code_bucket}.s3-ap-southeast-1.amazonaws.com/${aws_s3_bucket_object.yugandhar_deploy_object.id}"
}
