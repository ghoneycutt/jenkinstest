resource "null_resource" "example1" {
  provisioner "local-exec" {
    command     = "puts 'terraform/levels/1/2/3/levels_1_2_3.tf'"
    interpreter = ["ruby", "-e"]
  }
}
