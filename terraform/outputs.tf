output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "URL de autenticación para Azure Container Registry"
}

output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "Nombre del cluster AKS"
}

output "apim_gateway_url" {
  value       = azurerm_api_management.apim.gateway_url
  description = "URL del Gateway de APIM"
}

output "swa_default_host_name" {
  value       = azurerm_static_web_app.swa.default_host_name
  description = "URL del Static Web App"
}