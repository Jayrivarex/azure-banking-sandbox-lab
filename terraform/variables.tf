variable "subscription_id" {
  type        = string
  description = "ID de la suscripcion de Azure Sandbox (P9-Real Hands-On Labs)"
}

variable "resource_group_name" {
  type        = string
  default     = "1-5932e71d-playground-sandbox"
  description = "Nombre del Resource Group pre-provisionado[cite: 1]"
}

variable "location" {
  type        = string
  default     = "southcentralus"
  description = "Region permitida en el Sandbox[cite: 1]"
}

variable "prefix" {
  type        = string
  default     = "banklab"
  description = "Prefijo para los nombres de los recursos"
}