
# output "public_ip" {
#  value       = aws_instance.my_vm.public_ip
#  description = "Public IP Address of EC2 instance"
# }

# output "instance_id" {
#  value       = aws_instance.my_vm.id
#  description = "Instance ID"
# }

output "aws_region" {
  value = data.aws_region.current.name
}

# output "aws_tsdb_database_name" {
#   value = data.aws_timestreamwrite_database.timestream_db.database_name
# }

# output "aws_tsdb_table_name" {
#   value = data.aws_region.current.name
# }
