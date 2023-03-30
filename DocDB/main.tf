data "aws_db_cluster_snapshot" "latest_cluster_snapshot" {
  db_cluster_identifier = "docdb-2022-10-22-05-34-49"
  most_recent           = true
  provider = aws.eastaws-profile
}

resource null_resource "snapshot_create" {
  # provider = aws.eastaws-profile
  triggers = {
    trigger = data.aws_db_cluster_snapshot.latest_cluster_snapshot.db_cluster_identifier
  }

  provisioner "local-exec" {
    # command = "aws docdb --source-region=us-east-1 copy-db-cluster-snapshot  --source-db-cluster-snapshot-identifier  ${data.aws_db_cluster_snapshot.latest_cluster_snapshot.db_cluster_snapshot_identifier} --target-db-cluster-snapshot-identifier sample-cluster-snapshot-copy --copy-tags"
    command = <<-EOT
      ./assume-iam-role.sh  --roleARN arn:aws:iam::493292241438:role/AudiAccess --awsProfile default
      aws docdb --region=us-west-2 --source-region=us-east-1 copy-db-cluster-snapshot  --source-db-cluster-snapshot-identifier  ${data.aws_db_cluster_snapshot.latest_cluster_snapshot.db_cluster_snapshot_identifier} --target-db-cluster-snapshot-identifier sample-cluster-snapshot-copy --copy-tags
    EOT
  }
  depends_on = [data.aws_db_cluster_snapshot.latest_cluster_snapshot]
  
}

# resource "aws_docdb_cluster_snapshot" "example1" {
#   provider = aws.westaws-profile
#   db_cluster_identifier          = data.aws_db_cluster_snapshot.latest_cluster_snapshot.db_cluster_identifier
#   # source_db_cluster_snapshot_identifier = data.aws_db_cluster_snapshot.latest_cluster_snapshot.db_cluster_snapshot_arn
#   db_cluster_snapshot_identifier = "resourcetestsnapshot1234"
# }

# resource "aws_db_snapshot_copy" "example" {
#   provider = aws.westaws-profile
#   source_db_snapshot_identifier = data.aws_db_cluster_snapshot.latest_cluster_snapshot.db_cluster_snapshot_arn
#   target_db_snapshot_identifier = "testsnapshot1234-copy"
# }

# resource "aws_docdb_cluster_snapshot" "example" {
#   provider = aws.eastaws-profile
#   db_cluster_identifier          = data.aws_db_cluster_snapshot.latest_cluster_snapshot.id
#   db_cluster_snapshot_identifier = "resourcetestsnapshot1234"
#   # db_cluster_snapshot_arn = data.aws_db_cluster_snapshot.latest_cluster_snapshot.db_cluster_snapshot_arn
#   source_db_cluster_snapshot_identifier = data.aws_db_cluster_snapshot.latest_cluster_snapshot.db_cluster_snapshot_arn
# }

output "DB_snapshot" {
  description = "ID of project VPC"
  value       = data.aws_db_cluster_snapshot.latest_cluster_snapshot
}