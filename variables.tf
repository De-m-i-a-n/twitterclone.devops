variable "POSTGRES_DB" {
  type        = string
  description = "Name for the PostgreSQL database."
}

variable "POSTGRES_USER" {
  type        = string
  description = "Username for the PostgreSQL database."
}

variable "POSTGRES_PASSWORD" {
  type        = string
  description = "Password for the PostgreSQL user."
  sensitive   = true # Marks the variable as sensitive in Terraform output
}

variable "SECRET_KEY" {
  type        = string
  description = "Django secret key."
  sensitive   = true
}

variable "DEBUG" {
  type        = string
  description = "Django debug flag (e.g., '1' for True)."
  default     = "1"
}
