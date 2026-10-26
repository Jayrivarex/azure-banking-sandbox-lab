# 1. Referencia al Grupo de Recursos del Sandbox[cite: 1]
data "azurerm_resource_group" "sandbox" {
  name = var.resource_group_name
}

# 2. Azure Container Registry (ACR)[cite: 6]
resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr2026"
  resource_group_name = data.azurerm_resource_group.sandbox.name
  location            = data.azurerm_resource_group.sandbox.location
  sku                 = "Basic"
  admin_enabled       = true
}

# 3. Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks-cluster"
  resource_group_name = data.azurerm_resource_group.sandbox.name
  location            = data.azurerm_resource_group.sandbox.location
  dns_prefix          = "${var.prefix}-aks-dns"
  oidc_issuer_enabled = true # <--- Añadido explícitamente para evitar que Terraform intente desactivarlo

  default_node_pool {
    name       = "agentpool"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

# Configuración de proveedores dinámicos para Kubernetes y Helm
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}

# 4. Helm Release: kube-prometheus-stack (Prometheus + Grafana)
resource "helm_release" "prometheus_grafana" {
  name             = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "grafana.adminPassword"
    value = "BankingLab2026Security*"
  }

  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "1d"
  }
}

# 5. Azure API Management (APIM) - SKU Consumption[cite: 6]
resource "azurerm_api_management" "apim" {
  name                = "${var.prefix}-apim-sandbox"
  resource_group_name = data.azurerm_resource_group.sandbox.name
  location            = data.azurerm_resource_group.sandbox.location
  publisher_name      = "Enterprise Banking Corp"
  publisher_email     = "devops@bankingcorp.pe"
  sku_name            = "Consumption_0"
}

# 6. Azure Static Web Apps (SWA) - Nombre actualizado para evitar conflictos con el recurso anterior
resource "azurerm_static_web_app" "swa" {
  name                = "${var.prefix}-swa-frontend-v2"
  resource_group_name = data.azurerm_resource_group.sandbox.name
  location            = "centralus" # Region soportada para Static Web Apps[cite: 1]
  sku_tier            = "Free"
  sku_size            = "Free"
}