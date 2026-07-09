# Valux Deco

Sistema web de gestión para Valux Deco desarrollado con:

- Frontend: React + Vite
- Backend: FastAPI + Uvicorn
- Base de Datos: PostgreSQL 17
- ORM: SQLAlchemy
- Entorno de ejecución: WSL2 Debian + Docker

# Sobre WSL2

El proyecto fue desarrollado íntegramente dentro de WSL2 (Windows Subsystem for Linux) utilizando Debian como distribución Linux.

WSL2 permite ejecutar un entorno Linux completo dentro de Windows, por lo que tanto el frontend, el backend como la base de datos se ejecutan dentro de Debian.

Docker se encuentra integrado con WSL2 y utiliza este entorno para ejecutar el contenedor PostgreSQL.

---

# Arquitectura del Proyecto

```text
┌─────────────────────────────────────┐
│          WSL2 Debian                │
│                                     │
│  ┌───────────────┐                  │
│  │ React + Vite  │                  │
│  │ Frontend      │                  │
│  └───────┬───────┘                  │
│          │ HTTP                     │
│          ▼                          │
│  ┌───────────────┐                  │
│  │ FastAPI       │                  │
│  │ Uvicorn       │                  │
│  └───────┬───────┘                  │
│          │ SQLAlchemy               │
│          ▼                          │
│  ┌───────────────┐                  │
│  │ PostgreSQL 17 │                  │
│  │ Docker        │                  │
│  └───────────────┘                  │
│                                     │
└─────────────────────────────────────┘
```

La aplicación se encuentra dividida en tres componentes principales:

1. Frontend desarrollado en React utilizando Vite.
2. Backend desarrollado en Python utilizando FastAPI.
3. Base de datos PostgreSQL 17 ejecutándose dentro de un contenedor Docker.

Todos los componentes se ejecutan dentro de un entorno WSL2 Debian, lo que permite disponer de un entorno de desarrollo unificado basado en Linux.
---

# Requisitos

## Software necesario

- Node.js 22 o superior
- Python 3.12 o superior
- Docker Desktop
- WSL2 Debian
- Git

---

# Clonar los repositorios

## Frontend

```bash
git clone <URL_FRONTEND>
```

## Backend

```bash
git clone <URL_BACKEND>
```

---

## Levantar la Base de Datos

La base de datos PostgreSQL se ejecuta mediante Docker. Se proporciona un archivo `docker-compose.yml` dentro de la carpeta:

```text
Environment
          | Database
```

Posicionarse en dicha carpeta:

```bash
cd Environment/Database
```

Iniciar PostgreSQL:

```bash
docker compose up -d
```

Verificar que el contenedor se encuentre en ejecución:

```bash
docker ps
```

Debería aparecer un contenedor basado en la imagen `postgres:17`.

Para detener la base de datos:

```bash
docker compose down
```

Verificar que el contenedor se encuentre ejecutándose:

```bash
docker ps
```

Debería aparecer:

```text
CONTAINER ID   IMAGE         STATUS
xxxxxxxxxxxx   postgres:17   Up
```

Para detener la base de datos:

```bash
docker compose down
```

Para detenerla conservando los datos:

```bash
docker compose stop
```

Para eliminar completamente la base de datos y volver a crearla desde cero:

```bash
docker compose down -v
```

---

Y tu `.env` del backend quedaría:

```env
DATABASE_URL=postgresql+psycopg://postgres:password@localhost:5432/valux
```

# Variables de Entorno Backend

Crear un archivo:

```text
Backend/.env
```

Ejemplo:

```env
# =========================
# APP
# =========================
APP_ENV=development
APP_NAME=valux
DEBUG=true

# =========================
# DATABASE
# =========================
DATABASE_URL=postgresql+psycopg://valux:valux-dev@localhost:5432/valux

# Pool tuning (opcional pero útil)
DB_POOL_SIZE=10
DB_MAX_OVERFLOW=20
DB_POOL_PRE_PING=true

# =========================
# AUTH
# =========================
JWT_SECRET_KEY=
JWT_ALGORITHM=HS256
JWT_ACCESS_TOKEN_EXPIRE_MINUTES=60

# =========================
# INVENTORY / BUSINESS RULES
# =========================
DEFAULT_STOCK_RESERVATION_MINUTES=15
ALLOW_NEGATIVE_STOCK=false

# =========================
# PAYMENT (ej: Mercado Pago)
# =========================
MP_ACCESS_TOKEN=
MP_PUBLIC_KEY=
MP_WEBHOOK_SECRET=

# =========================
# EMAIL (WIP)
# =========================
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email
SMTP_PASSWORD=your_password

# =========================
# LOGGING
# =========================
LOG_LEVEL=info

# =========================
# MEDIA URL
# =========================
MEDIA_BASE_URL=http://localhost:8000/static/
```

Modificar los valores según la configuración local.

---

# Configuración del Backend

Ingresar a la carpeta del backend:

```bash
cd Backend
```

## Crear entorno virtual

```bash
python -m venv venv
```

## Activar entorno virtual

### Linux / WSL

```bash
source venv/bin/activate
```

### Windows

```bash
venv\Scripts\activate
```

## Instalar dependencias

```bash
pip install -r requirements.txt
```

## Ejecutar FastAPI

```bash
uvicorn main:app --host 0.0.0.0 --reload
```

Servidor disponible en:

```text
http://localhost:8000
```

Documentación automática:

```text
http://localhost:8000/docs
```

---

# Variables de Entorno Frontend

Crear:

```text
Frontend/.env
```

Ejemplo:

```env
VITE_API_URL=http://localhost:8000
```

---

# Configuración del Frontend

Ingresar a la carpeta del frontend:

```bash
cd Frontend
```

## Instalar dependencias

```bash
npm install
```

## Ejecutar Vite

```bash
npm run dev -- --host
```

Servidor disponible en:

```text
http://localhost:5173 o urls autogeneradas
```

---

# Orden Correcto de Inicio

## 1. Iniciar PostgreSQL

```bash
docker start valux-deco
```

Verificar:

```bash
docker ps
```

---

## 2. Iniciar Backend

```bash
cd Backend

source venv/bin/activate

uvicorn main:app --host 0.0.0.0 --reload 
```

Verificar:

```text
http://localhost:8000/docs
```

---

## 3. Iniciar Frontend

```bash
cd Frontend

npm run dev -- --host
```

Verificar:

```text
http://localhost:5173
```

---

# Información Adicional

La base de datos se ejecuta en un contenedor Docker alojado dentro de WSL2 Debian. Esto permite mantener un entorno de desarrollo aislado y reproducible sin necesidad de instalar PostgreSQL directamente en Windows.

El frontend se comunica con FastAPI mediante HTTP y FastAPI accede a PostgreSQL mediante SQLAlchemy utilizando la cadena de conexión definida en el archivo `.env`.