# PostgreSQL con Docker

## Requisitos

* Docker Desktop instalado y funcionando.
* Integración WSL habilitada (si se utiliza WSL2).
* Acceso a la terminal Linux o PowerShell.

## Descargar la imagen de PostgreSQL

```bash
docker pull postgres:17
```

## Crear y ejecutar el contenedor

```bash
docker run -d \
  --name postgres-dev \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=valux \
  -p 5432:5432 \
  -v postgres-data:/var/lib/postgresql/data \
  postgres:17
```

### Parámetros utilizados

| Parámetro                                   | Descripción                                     |
| ------------------------------------------- | ----------------------------------------------- |
| `--name postgres-dev`                       | Nombre del contenedor                           |
| `POSTGRES_USER`                             | Usuario administrador                           |
| `POSTGRES_PASSWORD`                         | Contraseña del usuario                          |
| `POSTGRES_DB`                               | Base de datos creada automáticamente al iniciar |
| `-p 5432:5432`                              | Expone PostgreSQL en el puerto 5432             |
| `-v postgres-data:/var/lib/postgresql/data` | Volumen persistente para almacenar los datos    |

## Verificar que el contenedor está en ejecución

```bash
docker ps
```

## Conectarse a PostgreSQL desde la terminal

```bash
docker exec -it postgres-dev psql -U postgres
```

## Comandos útiles de PostgreSQL

Listar bases de datos:

```sql
\l
```

Conectarse a una base de datos:

```sql
\c valux
```

Mostrar tablas del esquema actual:

```sql
\dt
```

Salir de PostgreSQL:

```sql
\q
```

## Gestión del contenedor

Detener el contenedor:

```bash
docker stop postgres-dev
```

Iniciar el contenedor:

```bash
docker start postgres-dev
```

Reiniciar el contenedor:

```bash
docker restart postgres-dev
```

Eliminar el contenedor:

```bash
docker rm -f postgres-dev
```

## Gestión del volumen

Listar volúmenes:

```bash
docker volume ls
```

Eliminar el volumen de datos:

```bash
docker volume rm postgres-data
```

> Eliminar el volumen borrará permanentemente todas las bases de datos almacenadas en PostgreSQL.

## Datos de conexión

```text
Host: localhost
Port: 5432
Database: valux
User: postgres
Password: postgres
```

Estos datos pueden utilizarse desde aplicaciones, scripts o herramientas de administración como DBeaver o pgAdmin.