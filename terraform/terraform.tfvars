db_user = "admin"
db_name = "devops_db"

public_subnets = {
    pubsub_1 = {
        cidr = "10.0.1.0/24"
        az   = "ap-southeast-2a"
    }

    pubsub_2 = {
        cidr = "10.0.2.0/24"
        az   = "ap-southeast-2b"
    }
}

private_subnets = {
    privsub_1 = {
        cidr = "10.0.3.0/24"
        az   = "ap-southeast-2a"
    }

    privsub_2 = {
        cidr = "10.0.4.0/24"
        az   = "ap-southeast-2b"
    }
}