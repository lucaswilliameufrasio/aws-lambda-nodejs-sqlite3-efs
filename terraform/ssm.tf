resource "aws_ssm_parameter" "efs_arn" {
  name  = "/${local.prefix}/default/EFS_ARN"
  type  = "String"
  value = aws_efs_file_system.foo.arn
  tags  = local.tags
  overwrite = true

  depends_on = [
    aws_efs_access_point.test
  ]
}

resource "aws_ssm_parameter" "efs_ap_arn" {
  name  = "/${local.prefix}/default/EFS_AP_ARN"
  type  = "String"
  value = aws_efs_access_point.test.arn
  tags  = local.tags
  overwrite = true

  depends_on = [
    aws_efs_access_point.test
  ]
}

resource "aws_ssm_parameter" "vpc_sg_ids" {
  name  = "/${local.prefix}/default/VPC_SG_IDS"
  type  = "StringList"
  value = aws_security_group.lambda.id
  tags  = local.tags
  overwrite = true
}

resource "aws_ssm_parameter" "vpc_subnet_ids" {
  name  = "/${local.prefix}/default/VPC_SUBNET_IDS"
  type  = "StringList"
  value = aws_subnet.default.id
  tags  = local.tags
  overwrite = true
}

resource "aws_ssm_parameter" "elasticache_arn" {
  name  = "/${local.prefix}/default/ELASTICACHE_ARN"
  type  = "String"
  value = aws_elasticache_cluster.example.arn
  tags  = local.tags
  overwrite = true

  depends_on = [aws_elasticache_cluster.example]
}

# Knowing that elasticache only supports
# more than one node when running in cluster
# mode, we ensure to only get the address
# of the first node. There is no intention
# to use replication mode at this moment.
# If anyone wants to configure the cluster
# mode, just change the value to:
# join(",", [for node in aws_elasticache_cluster.example.cache_nodes : "redis://${node.address}:${node.port}"])
resource "aws_ssm_parameter" "redis_url" {
  name  = "/${local.prefix}/default/REDIS_URL"
  type  = "String"
  value = "redis://${aws_elasticache_cluster.example.cache_nodes.0.address}:${aws_elasticache_cluster.example.cache_nodes.0.port}"
  tags  = local.tags
  overwrite = true

  depends_on = [aws_elasticache_cluster.example]
}


