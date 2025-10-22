# Actividad 9 - Instalación de Apache con Ansible

## Descripción
Playbook de Ansible que instala y configura el servidor web Apache.

## Archivos
- `inventario.ini`: Define los hosts donde se instalará Apache
- `instalar-apache.yml`: Playbook que instala y configura Apache

## Tareas realizadas
1. Actualización del cache de paquetes
2. Instalación de Apache2
3. Inicio y habilitación del servicio
4. Verificación del estado del servicio
5. Creación de página de prueba
6. Verificación de conectividad HTTP

## Ejecución
```bash
ansible-playbook -i inventario.ini instalar-apache.yml
```

## Verificación
```bash
# Verificar estado del servicio
sudo systemctl status apache2

# Probar en navegador
http://localhost

# Probar con curl
curl http://localhost
```

## Resultado esperado
- Apache instalado y corriendo
- Servicio activo y habilitado
- Página de prueba accesible en http://localhost
