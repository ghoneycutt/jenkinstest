resource "null_resource" "example1" {
  provisioner "local-exec" {
    command     = "puts 'something'"
    interpreter = ["ruby", "-e"]
  }
// no trailing } .. this will cause an error
