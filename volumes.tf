resource "aws_ebs_volume" "example" {
  count = 2
  availability_zone = "ap-south-1b"
  size              = 4

  tags = {
    Name = "my vol ${count.index+1}"
  }
}

resource "aws_volume_attachment" "volattach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.example[1].id
  instance_id = aws_instance.myinstance1.id
}
