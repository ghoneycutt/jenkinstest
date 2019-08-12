resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "puts 'something'"
    interpreter = ["ruby", "-e"]
  }
}
