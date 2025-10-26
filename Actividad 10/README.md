# Actividad 10 - Ansible para Docker en EC2

## Descripción
Despliegue automatizado de contenedores Docker en instancias EC2 usando Terraform y Ansible.

## Archivos
- `main.tf`: Configuración de Terraform para crear 3 instancias EC2
- `inventory.ini`: Inventario de Ansible con los nodos administrados
- `run_container.yaml`: Playbook de Ansible para instalar Docker y ejecutar contenedor httpd

## Infraestructura Creada
- 3 instancias EC2 (t3.micro) en AWS us-east-1
- Security Group con puertos 22 (SSH) y 80 (HTTP)
- Contenedores httpd (Apache) corriendo en cada instancia

## Ejecución

### 1. Crear infraestructura con Terraform
```bash
terraform init
terraform apply
```

### 2. Verificar conexión con Ansible
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/ansible-docker-key.pem
ansible all -m ping -i inventory.ini
```

### 3. Instalar Docker y lanzar contenedores
```bash
ansible-playbook -i inventory.ini run_container.yaml
```

### 4. Verificar contenedores
```bash
ansible all -i inventory.ini -m shell -a "sudo docker ps" -b
```

## Verificación
Acceder a las IPs públicas en el navegador: `http://<IP_PUBLICA>`

## Limpieza
```bash
terraform destroy
```

## Notas
- Requiere AWS CLI configurado
- Key pair: ansible-docker-key
- Región: us-east-1
