#################################
######### LOAD BALANCER #########
#################################

resource "aws_lb" "main" {
  name               = "${var.project}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false
  drop_invalid_header_fields = false
  desync_mitigation_mode     = "defensive"


  tags = {
    Name      = "${var.project}-lb"
  }
}
#################################
############ HTTP ###############
#################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "http_rule_01" {
  listener_arn = aws_lb_listener.http.arn


  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = var.domain
    }
  }
}

#################################
############ HTTPS ##############
#################################

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener_rule" "https_rule_01" {
  listener_arn = aws_lb_listener.https.arn

  action {
    target_group_arn = aws_lb_target_group.main.arn
    type             = "forward"
  }

  condition {
    host_header {
      values = var.domain
    }
  }
}
