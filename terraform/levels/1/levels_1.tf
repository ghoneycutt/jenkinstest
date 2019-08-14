resource "null_resource" "example1" {
  provisioner "local-exec" {
    command     = "puts 'terraform/levels/1/levels_1.tf'"
    interpreter = ["ruby", "-e"]
  }
}
