data "aws_security_group" "default" {
    depends_on = [module.vpc]

    filter {
        name = "vpc_id"
        values = [module.vpc.vpc_id]
    }

    filter {
        name = "group_name"
        values = [default]

    
    }
}