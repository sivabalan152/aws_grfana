resource "grafana_data_source" "cloudwatch" {
  provider = grafana.cloud
  name   = "Cloudwatch1"
  type   = "cloudwatch"
  json_data_encoded = jsonencode({
    defaultRegion = "ap-southeast-2"

    authType      = "iam"
    custom_metrics_namespaces=  [
    "testing",
    ]

  })
}

resource "grafana_folder" "folder" {
  provider = grafana.cloud
  title = "my_foder"

}

#resource "grafana_dashboard" "dashboard" {
 # provider = grafana.cloud
 # folder = grafana_folder.folder.id
 # config_json =file("dashboard.json")
#}