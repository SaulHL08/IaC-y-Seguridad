# Explicación del Algoritmo AES

## ¿Qué es AES?

**AES (Advanced Encryption Standard)** es un algoritmo de cifrado simétrico adoptado como estándar por el gobierno de EE.UU. en 2001.

### Características principales:
- **Cifrado simétrico**: La misma clave se usa para encriptar y desencriptar
- **Tamaños de clave**: 128, 192 o 256 bits
- **Tamaño de bloque**: Siempre 128 bits (16 bytes)
- **Usado en**: TLS/SSL, VPN, disco duro encriptado, etc.

---

## Componentes del Código

### 1. Generación de Clave e IV
```python
key = urandom(32)  # 256 bits - AES-256
iv = urandom(16)   # 128 bits - Tamaño de bloque
```

**Clave (Key):**
- Secreto compartido entre emisor y receptor
- En este ejemplo: 256 bits (32 bytes) = AES-256 (más seguro)
- Debe mantenerse **completamente secreta**

**IV (Initialization Vector):**
- Vector de inicialización de 128 bits
- Debe ser **único** para cada mensaje
- **NO necesita ser secreto**, pero sí aleatorio
- Previene que el mismo texto genere el mismo cifrado

---

### 2. Modo CBC (Cipher Block Chaining)
```python
modes.CBC(iv)
```

**¿Qué es CBC?**
- Modo de operación de cifrado por bloques
- Cada bloque de texto plano se combina (XOR) con el bloque cifrado anterior
- El primer bloque usa el IV
- Ventaja: El mismo texto plano produce diferentes cifrados

**Diagrama CBC:**
```
Bloque 1:  Texto_Plano ⊕ IV        → Encriptar → Cifrado_1
Bloque 2:  Texto_Plano ⊕ Cifrado_1 → Encriptar → Cifrado_2
Bloque 3:  Texto_Plano ⊕ Cifrado_2 → Encriptar → Cifrado_3
```

---

### 3. Padding PKCS7
```python
padding_length = 16 - (len(texto_plano_bytes) % 16)
padding = bytes([padding_length]) * padding_length
```

**¿Por qué se necesita?**
- AES trabaja en bloques de 16 bytes
- Si el texto no es múltiplo de 16, se completa con padding

**Ejemplo:**
- Texto: "Hola" (4 bytes)
- Falta: 16 - 4 = 12 bytes
- Padding: 12 bytes con valor 0x0C (12 en hexadecimal)
- Resultado: "Hola\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c"

---

### 4. Proceso de Encriptación
```python
encryptor = cipher.encryptor()
texto_cifrado = encryptor.update(texto_a_cifrar) + encryptor.finalize()
```

**Pasos:**
1. Convertir texto a bytes
2. Aplicar padding
3. Dividir en bloques de 16 bytes
4. Aplicar AES con clave y IV
5. Retornar texto cifrado

---

### 5. Proceso de Desencriptación
```python
decryptor = cipher.decryptor()
texto_desencriptado = decryptor.update(texto_cifrado) + decryptor.finalize()
padding_length = texto_desencriptado[-1]
texto_final = texto_desencriptado[:-padding_length]
```

**Pasos:**
1. Aplicar AES inverso con la misma clave e IV
2. Remover el padding
3. Convertir bytes a texto

---

## Seguridad de AES

### Fortalezas:
✅ **Resistente a ataques**: No hay ataques prácticos conocidos contra AES-256  
✅ **Rápido**: Muy eficiente en hardware y software  
✅ **Estándar mundial**: Usado por gobiernos y empresas  
✅ **Probado**: Años de análisis criptográfico  

### Vulnerabilidades:
⚠️ **Gestión de claves**: Si la clave se compromete, todo se compromete  
⚠️ **IV reutilizado**: Nunca reusar el mismo IV con la misma clave  
⚠️ **Modo CBC**: Vulnerable a padding oracle attacks si no se implementa correctamente  

---

## Comparación de Tamaños de Clave

| Tipo | Bits | Bytes | Seguridad | Uso |
|------|------|-------|-----------|-----|
| AES-128 | 128 | 16 | Alta | Uso general |
| AES-192 | 192 | 24 | Muy Alta | Datos sensibles |
| AES-256 | 256 | 32 | Máxima | Datos ultra-sensibles |

**En este código usamos AES-256** (máxima seguridad)

---

## Modos de Operación AES

| Modo | Características | Uso |
|------|----------------|-----|
| **CBC** | Requiere IV, no paralelizable | Cifrado de archivos |
| **CTR** | Convierte cifrado de bloque en stream | Cifrado en tiempo real |
| **GCM** | Autenticación incluida | TLS, comunicaciones seguras |
| **ECB** | ❌ Inseguro, no usar | Ninguno (obsoleto) |

---

## Ejemplo Práctico

### Entrada:
```
Texto: "Viridiana Mares R."
Clave: [32 bytes aleatorios]
IV: [16 bytes aleatorios]
```

### Salida:
```
Texto cifrado: b'\x8a\x3f\x4b...' (bytes aleatorios)
Texto desencriptado: "Viridiana Mares R."
```

**Importante:** Con la misma clave e IV, siempre produce el mismo cifrado.
Con diferente IV, produce cifrados diferentes aunque el texto sea igual.

---

## Aplicaciones Reales de AES

1. **HTTPS/TLS**: Protección de comunicaciones web
2. **VPN**: Túneles encriptados (IPsec, OpenVPN)
3. **WiFi**: WPA2/WPA3 usan AES
4. **Discos duros**: BitLocker, FileVault usan AES
5. **Mensajería**: WhatsApp, Signal usan AES
6. **Archivos ZIP**: Encriptación de archivos comprimidos

---

## Buenas Prácticas

✅ Usar AES-256 para máxima seguridad  
✅ Generar IV aleatorio para cada mensaje  
✅ Nunca reutilizar el mismo IV con la misma clave  
✅ Usar modos autenticados como GCM cuando sea posible  
✅ Proteger la clave con sistemas como Vault  
✅ Rotar claves periódicamente  

❌ NO usar ECB  
❌ NO hardcodear claves en el código  
❌ NO reutilizar IVs  
❌ NO usar claves débiles  

---

## Conclusión

AES es el estándar de cifrado simétrico más usado en el mundo por su:
- **Seguridad probada**
- **Eficiencia**
- **Flexibilidad**
- **Adopción universal**

El código implementa AES-256-CBC de manera segura, demostrando cómo encriptar y desencriptar datos de forma confiable.
