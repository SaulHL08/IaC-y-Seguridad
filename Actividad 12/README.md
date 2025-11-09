# Actividad 12 - HashiCorp Vault: Instalación y Seal/Unseal

## Descripción
Implementación de HashiCorp Vault para gestión segura de secretos, utilizando el método de Seal/Unseal con encriptación PGP.

## Objetivos Completados

✅ Instalación de Vault  
✅ Configuración del servidor  
✅ Generación de claves PGP  
✅ Inicialización con encriptación PGP  
✅ Proceso de Unseal manual  
✅ Gestión de secretos  

---

## 1. Instalación de Vault

### Comandos ejecutados:
```bash
sudo apt update
sudo apt install vault -y
vault version
```

**Resultado:** Vault v1.21.0 instalado correctamente

---

## 2. Configuración del Servidor

### Archivo: vault-config.hcl
```hcl
storage "file" {
  path = "./vault-data"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
}

ui = true
api_addr = "http://127.0.0.1:8200"
```

### Iniciar servidor:
```bash
vault server -config=vault-config.hcl
```

---

## 3. Generación de Claves PGP

Se generaron 4 claves PGP:
- 3 claves para Unseal Keys
- 1 clave para Root Token
```bash
gpg --batch --gen-key <<EOF
%no-protection
Key-Type: RSA
Key-Length: 2048
Name-Real: Vault Unseal Key 1
Name-Email: unseal1@hospital.local
Expire-Date: 0
EOF
```

**Claves generadas:**
- unseal1@hospital.local
- unseal2@hospital.local
- unseal3@hospital.local
- root@hospital.local

---

## 4. Inicialización con PGP

### Comando de inicialización:
```bash
vault operator init \
  -key-shares=3 \
  -key-threshold=2 \
  -pgp-keys="unseal-key-1.asc,unseal-key-2.asc,unseal-key-3.asc" \
  -root-token-pgp-key="root-key.asc"
```

**Parámetros:**
- `key-shares=3`: 3 llaves unseal generadas
- `key-threshold=2`: Se requieren 2 llaves para desbloquear
- `pgp-keys`: Encriptación de cada unseal key con PGP
- `root-token-pgp-key`: Encriptación del token root con PGP

**Resultado:**
- 3 Unseal Keys encriptadas
- 1 Root Token encriptado
- Todas las claves protegidas con PGP

---

## 5. Proceso de Unseal

### Estado inicial:
```bash
vault status
# Sealed: true
# Initialized: true
```

### Desencriptar claves:
```bash
# Desencriptar Unseal Key 1
grep "Unseal Key 1" vault-init-output.txt | awk '{print $NF}' | base64 -d | gpg -d

# Desencriptar Unseal Key 2
grep "Unseal Key 2" vault-init-output.txt | awk '{print $NF}' | base64 -d | gpg -d
```

### Aplicar Unseal Keys:
```bash
# Primera clave (progreso 1/2)
vault operator unseal [KEY_1]

# Segunda clave (progreso 2/2 - Vault desbloqueado)
vault operator unseal [KEY_2]
```

**Resultado:**
```
Sealed: false
Threshold: 2
Total Shares: 3
```

---

## 6. Autenticación y Uso

### Login con Root Token:
```bash
vault login [ROOT_TOKEN]
# Success! You are now authenticated.
```

### Habilitar secrets engine:
```bash
vault secrets enable -path=hospital kv-v2
```

### Crear secreto:
```bash
vault kv put hospital/database \
  username="admin_hospital" \
  password="SecurePass2024!"
```

### Leer secreto:
```bash
vault kv get hospital/database
```

---

## 7. Concepto de Auto-Unseal

El Auto-Unseal permite desbloquear Vault automáticamente usando servicios externos:

### Opciones de Auto-Unseal:
- **AWS KMS**: Usa claves de AWS Key Management Service
- **Azure Key Vault**: Integración con Azure
- **GCP Cloud KMS**: Usa Google Cloud KMS
- **Transit Seal**: Usa otro Vault como servicio de unseal

### Configuración ejemplo (Transit):
```hcl
seal "transit" {
  address            = "https://vault-transit:8200"
  token              = "s.xxxxx"
  key_name           = "autounseal"
  mount_path         = "transit/"
  disable_renewal    = "false"
}
```

**Ventajas:**
- ✅ Sin intervención manual
- ✅ Alta disponibilidad
- ✅ Reinicio automático
- ✅ Claves nunca expuestas

---

## 8. Medidas de Seguridad Implementadas

| Medida | Implementación |
|--------|----------------|
| Encriptación de Unseal Keys | PGP con claves RSA 2048-bit |
| Encriptación de Root Token | PGP dedicada |
| Threshold de Unseal | 2 de 3 claves requeridas |
| Almacenamiento | File backend local |
| Comunicación | Local (127.0.0.1) |
| Auditoría | Logs de acceso habilitados |

---

## 9. Comandos de Referencia Rápida

### Gestión de Estado:
```bash
# Ver estado
vault status

# Unseal
vault operator unseal [KEY]

# Seal (bloquear)
vault operator seal

# Login
vault login [TOKEN]
```

### Gestión de Secretos:
```bash
# Crear secreto
vault kv put path/to/secret key=value

# Leer secreto
vault kv get path/to/secret

# Listar secretos
vault kv list path/

# Eliminar secreto
vault kv delete path/to/secret
```

---

## 10. Conclusiones

Se implementó exitosamente HashiCorp Vault con las siguientes características:

✅ **Seguridad robusta**: Claves encriptadas con PGP  
✅ **Control de acceso**: Threshold 2/3 para unseal  
✅ **Gestión de secretos**: KV secrets engine funcional  
✅ **Trazabilidad**: Proceso documentado completamente  
✅ **Cumplimiento**: Listo para uso en producción  

El sistema está preparado para gestionar credenciales y secretos del equipo de desarrollo de manera segura y controlada.

---

## Notas de Seguridad

⚠️ **IMPORTANTE:**
- Las claves privadas NO se incluyen en este repositorio
- Los tokens de acceso están encriptados
- Las unseal keys deben distribuirse entre personas autorizadas
- Nunca compartir las claves desencriptadas en repositorios públicos
- En producción, usar Auto-Unseal con KMS

---

## Referencias

- [HashiCorp Vault Documentation](https://www.vaultproject.io/docs)
- [Seal/Unseal Concepts](https://www.vaultproject.io/docs/concepts/seal)
- [PGP Encryption](https://www.vaultproject.io/docs/concepts/pgp-gpg-keybase)
