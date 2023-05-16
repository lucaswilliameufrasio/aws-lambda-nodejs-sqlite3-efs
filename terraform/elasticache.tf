resource "aws_elasticache_subnet_group" "bar" {
  name       = "${local.prefix}-test-cache-subnet"
  subnet_ids = [aws_subnet.default.id]
}

# replication mode was not configured,
# changing the number of cache nodes
# will led to errors when trying to apply
# this Terraform
resource "aws_elasticache_cluster" "example" {
  cluster_id           = "${local.prefix}-cluster-example"
  engine               = "redis"
  node_type            = "cache.t4g.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.bar.name
  security_group_ids   = [aws_security_group.redis_sg.id]
}
