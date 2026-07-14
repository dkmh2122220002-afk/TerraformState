variable "VNET01" {
  description = "This is default VNET address range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ZONE1" {
  type = map(string)
  default = {
    01 = "10.0.1.0/24"
    02 = "10.0.2.0/24"
  }
}

variable "ZONE2" {
  type = map(string)
  default = {
    01 = "10.0.3.0/24"
    02 = "10.0.4.0/24"
  }
}

variable "SUBNET_AppGW" {
  type = map(string)
  default = {
    01 = "10.0.250.0/24"
    02 = "10.0.251.0/24"
  }
}

variable "DNS01_IP" {
  type    = string
  default = "10.0.1.100"
}

variable "DNS02_IP" {
  type    = string
  default = "10.0.2.100"
}

variable "LIST_KNOWN_PORT" {
  type = map(string)
  default = {
    HTTP  = "80"
    HTTPS = "443"
    FTP   = "21"
    SSH   = "22"
    DNS   = "53"
  }
}


variable "VM_SKU" {
  type = map(string)
  default = {
    WEB = "Standard_D2s_v3"
    DB  = "Standard_D2s_v3"
  }
}

variable "tags" {
  type = map(string)
  default = {
    ManagedBy = "Terraform"
    Owner     = "Hien"
  }
}

variable "Disk_Size" {
  type = map(string)
  default = {
    WEB = "20"
    DB  = "30"
  }
}

variable "Environment" {
  type    = string
  default = "DEV"
}