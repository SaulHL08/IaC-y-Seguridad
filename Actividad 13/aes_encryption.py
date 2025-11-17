# ============================================================
# Cifrado AES (Advanced Encryption Standard)
# Actividad 13 - Criptografía Simétrica
# ============================================================

from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
from os import urandom

# ============================================================
# FUNCIÓN 1: Generar clave e IV aleatorios
# ============================================================
def generar_clave_y_iv():
    """
    Genera una clave de 256 bits (32 bytes) y un IV de 128 bits (16 bytes).
    
    AES puede usar claves de:
    - 128 bits (16 bytes) - AES-128
    - 192 bits (24 bytes) - AES-192
    - 256 bits (32 bytes) - AES-256 (más seguro)
    
    IV (Initialization Vector): Vector de inicialización único para cada mensaje
    que asegura que el mismo texto plano no produzca el mismo texto cifrado.
    """
    key = urandom(32)  # Clave aleatoria de 32 bytes = 256 bits
    iv = urandom(16)   # IV aleatorio de 16 bytes = 128 bits (tamaño de bloque AES)
    return key, iv


# ============================================================
# FUNCIÓN 2: Encriptar texto con AES-256-CBC
# ============================================================
def encriptar(texto_plano, key, iv):
    """
    Encripta texto usando AES-256 en modo CBC (Cipher Block Chaining).
    
    Proceso:
    1. Crea un objeto Cipher con algoritmo AES y modo CBC
    2. Convierte el texto a bytes
    3. Aplica padding PKCS7 para completar bloques de 16 bytes
    4. Encripta el texto con padding
    
    Parámetros:
    - texto_plano: Texto a encriptar (string)
    - key: Clave de 256 bits
    - iv: Vector de inicialización de 128 bits
    
    Retorna: Texto cifrado (bytes)
    """
    # Crear objeto Cipher con AES-256 en modo CBC
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    encryptor = cipher.encryptor()  # Objeto para encriptar
    
    # Convertir texto a bytes UTF-8
    texto_plano_bytes = texto_plano.encode('utf-8')
    
    # PADDING: AES trabaja en bloques de 16 bytes
    # Si el texto no es múltiplo de 16, se agrega padding
    padding_length = 16 - (len(texto_plano_bytes) % 16)
    # Crear padding según estándar PKCS7
    padding = bytes([padding_length]) * padding_length
    texto_a_cifrar = texto_plano_bytes + padding
    
    # Proceso de encriptación
    # update() encripta el texto
    # finalize() completa el proceso y retorna cualquier dato restante
    texto_cifrado = encryptor.update(texto_a_cifrar) + encryptor.finalize()
    
    return texto_cifrado


# ============================================================
# FUNCIÓN 3: Desencriptar texto cifrado
# ============================================================
def desencriptar(texto_cifrado, key, iv):
    """
    Desencripta texto usando AES-256 en modo CBC.
    
    Proceso:
    1. Crea un objeto Cipher (igual que en encriptación)
    2. Desencripta el texto
    3. Remueve el padding PKCS7
    4. Convierte bytes a string
    
    Parámetros:
    - texto_cifrado: Texto encriptado (bytes)
    - key: Misma clave usada para encriptar
    - iv: Mismo IV usado para encriptar
    
    Retorna: Texto original (string)
    """
    # Crear objeto Cipher para desencriptar
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    decryptor = cipher.decryptor()  # Objeto para desencriptar
    
    # Desencriptar
    texto_desencriptado_con_padding = decryptor.update(texto_cifrado) + decryptor.finalize()
    
    # REMOVER PADDING
    # El último byte indica cuántos bytes de padding hay
    padding_length = texto_desencriptado_con_padding[-1]
    # Eliminar el padding del final
    texto_desencriptado = texto_desencriptado_con_padding[:-padding_length]
    
    # Convertir bytes a string UTF-8
    return texto_desencriptado.decode('utf-8')


# ============================================================
# PROGRAMA PRINCIPAL - DEMOSTRACIÓN
# ============================================================

# Generar clave e IV aleatorios
key, iv = generar_clave_y_iv()

# Texto original a encriptar
texto_original = "Saul Latiznere"

# ENCRIPTACIÓN
texto_encriptado = encriptar(texto_original, key, iv)
print(f"Texto encriptado: {texto_encriptado}")
print(f"Texto encriptado (hex): {texto_encriptado.hex()}")

# DESENCRIPTACIÓN
texto_desencriptado = desencriptar(texto_encriptado, key, iv)
print(f"Texto desencriptado: {texto_desencriptado}")

# Verificación
print(f"\n¿El texto desencriptado es igual al original? {texto_original == texto_desencriptado}")

# Mostrar información de la clave e IV
print(f"\nInformación técnica:")
print(f"Clave (hex): {key.hex()}")
print(f"IV (hex): {iv.hex()}")
print(f"Longitud de clave: {len(key)} bytes = {len(key)*8} bits")
print(f"Longitud de IV: {len(iv)} bytes = {len(iv)*8} bits")
