variable "name" {}

output "json" {
  value = <<EOF
{
  "editable": false,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 14,
  "links": [],
  "liveNow": false,
  "panels": [
    {
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 3,
      "options": {
        "code": {
          "language": "plaintext",
          "showLineNumbers": false,
          "showMiniMap": false
        },
        "content": "# ${var.name}",
        "mode": "markdown"
      },
      "pluginVersion": "10.1.2",
      "transparent": true,
      "type": "text"
    }
  ],
  "refresh": "",
  "schemaVersion": 38,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "Home",
  "uid": "home",
  "version": 1,
  "weekStart": ""
}
EOF
}
