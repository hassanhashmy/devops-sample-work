resource "kubernetes_deployment_v1" "this" {
  for_each = { for _, e in flatten(values(var.services)) : e => e }
  metadata {
    name      = each.value
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = each.value
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = each.value
        }
      }

      spec {
        container {
          image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${each.value}:${var.ecr_image_tag}"
          image_pull_policy = "Always"
          name = each.value

          port {
            container_port = 80
          }
        }
      }
    }
  }

  # Doesn't wait for rollout to be completed
  wait_for_rollout = false
}

resource "kubernetes_service_v1" "this" {
  for_each = { for _, e in flatten(values(var.services)) : e => e }
  metadata {
    name = each.value
    namespace = "default"
  }

  spec {
    port {
      name        = each.value
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    selector = {
      "app.kubernetes.io/name" = each.value
    }
  }
}

resource "kubernetes_ingress_v1" "this" {
  metadata {
    name = "app"
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {

    rule {
      http {
        dynamic "path" {
          for_each = { for _, e in flatten(values(var.services)) : e => e }

          content {
            backend {
              service {
                name = path.key
                port {
                  number = 80
                }
              }
            }

            path      = "/${path.value}"
            path_type = "Prefix"
          }
        }
      }
    }
  }
}
