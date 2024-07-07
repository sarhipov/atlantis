resource "local_file" "kubeconfig" {
  content  = templatefile("${path.module}/templates/kubeconfig.tpl", local.kubeconfig_template_vars)
  filename = "./kubeconfig_${var.cluster_name}"
}