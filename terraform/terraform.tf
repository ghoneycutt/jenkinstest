resource "null_resource" "example1" {
  provisioner "local-exec" {
    command     = "puts 'terraform/terraform.tf'"
    interpreter = ["ruby", "-e"]
  }
}
