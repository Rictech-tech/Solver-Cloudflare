# Usa la imagen base
FROM python:3.11-slim

# Variables de entorno
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=America/New_York \
    SOLVER_SERVER_PORT=8088 \
    SOLVER_SECRET=jWRN7DH6

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget unzip locales \
    libnss3 libxss1 libasound2 fonts-liberation \
    libatk1.0-0 libatk-bridge2.0-0 libcups2 \
    libdrm2 libgbm1 libgtk-3-0 \
    libxcomposite1 libxrandr2 libxi6 \
    && rm -rf /var/lib/apt/lists/*

# Configurar locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen en_US.UTF-8

# Establecer directorio de trabajo
WORKDIR /app

# Copiar requirements.txt si lo tienes
COPY requirements.txt .

# Instalar requirements
RUN pip install --no-cache-dir -r requirements.txt

# Instalar el solver directamente desde el repo
RUN pip install --no-cache-dir "git+https://github.com/odell0111/turnstile_solver.git@main"

# Instalar patchright + Chrome
RUN pip install --no-cache-dir patchright \
    && patchright install chrome

# Exponer puerto
EXPOSE ${SOLVER_SERVER_PORT}

# Comando por defecto para iniciar el solver
CMD ["sh", "-c", "\
    echo '🚀 Iniciando solver en puerto ${SOLVER_SERVER_PORT}' && \
    exec solver --browser ${SOLVER_BROWSER:-chrome} \
                 --port ${SOLVER_SERVER_PORT:-8088} \
                 --secret ${SOLVER_SECRET:-jWRN7DH6} \
                 --max-attempts 3 \
                 --captcha-timeout 30 \
                 --page-load-timeout 30 \
"]
