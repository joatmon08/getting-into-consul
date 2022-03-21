# ASG for the Consul Servers
resource "aws_autoscaling_group" "consul_server" {
	name_prefix = "${var.main_project_tag}-server-asg-"

	launch_template {
    id = aws_launch_template.consul_server.id
    version = aws_launch_template.consul_server.latest_version
  }

	target_group_arns = [aws_lb_target_group.alb_targets.arn]

	desired_capacity = var.server_desired_count
  min_size = var.server_min_count
  max_size = var.server_max_count

	# AKA the subnets to launch resources in 
  vpc_zone_identifier = aws_subnet.private.*.id

  health_check_grace_period = 300
  health_check_type = "EC2"
  termination_policies = ["OldestLaunchTemplate"]
  wait_for_capacity_timeout = 0

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]

  tags = [
    {
      key = "Name"
      value = "${var.main_project_tag}-server"
      propagate_at_launch = true
    },
    {
      key = "Project"
      value = var.main_project_tag
      propagate_at_launch = true
    }
  ]

  # Allow time for internet access before installing external packages
  depends_on = [aws_nat_gateway.nat]
}

# ASG for the Consul Web Clients
resource "aws_autoscaling_group" "consul_client_web" {
	name_prefix = "${var.main_project_tag}-web-asg-"

	launch_template {
    id = aws_launch_template.consul_client_web.id
    version = aws_launch_template.consul_client_web.latest_version
  }

	target_group_arns = [aws_lb_target_group.alb_targets_web.arn]

	desired_capacity = var.client_web_desired_count
  min_size = var.client_web_min_count
  max_size = var.client_web_max_count

	# AKA the subnets to launch resources in 
  vpc_zone_identifier = aws_subnet.private.*.id

  health_check_grace_period = 300
  health_check_type = "EC2"
  termination_policies = ["OldestLaunchTemplate"]
  wait_for_capacity_timeout = 0

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]

  tags = [
    {
      key = "Name"
      value = "${var.main_project_tag}-web"
      propagate_at_launch = true
    },
    {
      key = "Project"
      value = var.main_project_tag
      propagate_at_launch = true
    }
  ]

  # Allow time for internet access before installing external packages
  depends_on = [aws_nat_gateway.nat]
}

# ASG for the Consul API Clients
resource "aws_autoscaling_group" "consul_client_api" {
	name_prefix = "${var.main_project_tag}-api-asg-"

	launch_template {
    id = aws_launch_template.consul_client_api.id
    version = aws_launch_template.consul_client_api.latest_version
  }

	desired_capacity = var.client_api_desired_count
  min_size = var.client_api_min_count
  max_size = var.client_api_max_count

	# AKA the subnets to launch resources in 
  vpc_zone_identifier = aws_subnet.private.*.id

  health_check_grace_period = 300
  health_check_type = "EC2"
  termination_policies = ["OldestLaunchTemplate"]
  wait_for_capacity_timeout = 0

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]

  tags = [
    {
      key = "Name"
      value = "${var.main_project_tag}-api"
      propagate_at_launch = true
    },
    {
      key = "Project"
      value = var.main_project_tag
      propagate_at_launch = true
    }
  ]

  # Allow time for internet access before installing external packages
  depends_on = [aws_nat_gateway.nat]
}

# ASG for the Ingress Gateway Clients
resource "aws_autoscaling_group" "ingress_gateway" {
	name_prefix = "${var.main_project_tag}-ingress-gateway-asg-"

	launch_template {
    id = aws_launch_template.ingress_gateway.id
    version = aws_launch_template.ingress_gateway.latest_version
  }

  target_group_arns = [aws_lb_target_group.alb_targets_ingress_gateway.arn]

	desired_capacity = var.ingress_gateway_desired_count
  min_size = var.ingress_gateway_min_count
  max_size = var.ingress_gateway_max_count

	# AKA the subnets to launch resources in 
  vpc_zone_identifier = aws_subnet.private.*.id

  health_check_grace_period = 300
  health_check_type = "EC2"
  termination_policies = ["OldestLaunchTemplate"]
  wait_for_capacity_timeout = 0

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]

  tags = [
    {
      key = "Name"
      value = "${var.main_project_tag}-ingress-gateway"
      propagate_at_launch = true
    },
    {
      key = "Project"
      value = var.main_project_tag
      propagate_at_launch = true
    }
  ]

  # Allow time for internet access before installing external packages
  depends_on = [aws_nat_gateway.nat]
}

# ASG for the Terminating Gateway Clients
resource "aws_autoscaling_group" "terminating_gateway" {
	name_prefix = "${var.main_project_tag}-terminating-gateway-asg-"

	launch_template {
    id = aws_launch_template.terminating_gateway.id
    version = aws_launch_template.terminating_gateway.latest_version
  }

  target_group_arns = [aws_lb_target_group.alb_targets_terminating_gateway.arn]

	desired_capacity = var.terminating_gateway_desired_count
  min_size = var.terminating_gateway_min_count
  max_size = var.terminating_gateway_max_count

	# AKA the subnets to launch resources in 
  vpc_zone_identifier = aws_subnet.private.*.id

  health_check_grace_period = 300
  health_check_type = "EC2"
  termination_policies = ["OldestLaunchTemplate"]
  wait_for_capacity_timeout = 0

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]

  tags = [
    {
      key = "Name"
      value = "${var.main_project_tag}-terminating-gateway"
      propagate_at_launch = true
    },
    {
      key = "Project"
      value = var.main_project_tag
      propagate_at_launch = true
    }
  ]

  # Allow time for internet access before installing external packages
  depends_on = [aws_nat_gateway.nat]
}
