# Configuración de almacenamiento
storage "file" {
  path = "./vault-data"
}

# Configuración del listener
listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
}

# Configuración de UI
ui = true

# API address
api_addr = "http://127.0.0.1:8200"
