output "public_usw2a.id" {
  value = "${module.vpc.public_usw2a.id}"
}
output "private_usw2a.id" {
  value = "${module.vpc.private_usw2a.id}"
}
output "private_usw2b.id" {
  value = "${module.vpc.private_usw2b.id}"
} 
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
} 