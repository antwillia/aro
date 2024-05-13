variable "cluster_name" {
  default     = "aro-atwlab"
  type        = string
  description = "The name of the ARO cluster to create"
}

variable "user_home_dir" {
  default     = "/Users/anwillia"
  type        = string
  description = "The name of the home/username"
}

variable "resource_group_name" {
  default     = "openenv-sjsjc"
  type        = string
  description = "The name of the resource group"
}