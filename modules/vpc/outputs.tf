output "public_usw2a.id" {
  value = "${aws_subnet.public_usw2a.id}"
}
output "private_usw2a.id" {
  value = "${aws_subnet.private_usw2a.id}"
}
output "private_usw2b.id" {
  value = "${aws_subnet.private_usw2b.id}"
} 
output "vpc_id" {
  value = "${aws_vpc.main.id}"
} 