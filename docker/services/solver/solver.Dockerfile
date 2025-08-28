# Imagen base ligera con Python 3.11
FROM python:3.11-slim

# Variables de entorno
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TZ=America/New_York

# Instalar dependencias del sistema necesarias para Chrome/Playwright
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget unzip locales \
    libnss3 libxss1 libasound2 fonts-liberation \
    libatk1.0-0 libatk-bridge2.0-0 libcups2 \
    libdrm2 libgbm1 libgtk-3-0 \
    libxcomposite1 libxrandr2 libxi6 \
    && rm -rf /var/lib/apt/lists/*

# Configuración de locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen en_US.UTF-8

# Instalar dependencias Python
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Instalar librerías adicionales (solver y patchright)
RUN pip install --no-cache-dir git+https://github.com/odell0111/turnstile_solver@main \
    && pip install --no-cache-dir patchright \
    && patchright install chrome

# Copiar el código fuente
COPY src /app/src

# Copiar el entrypoint desde la raíz del repo (ajustado para Railway)
COPY docker/services/solver/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Definir directorio de trabajo
WORKDIR /app

# Exponer el puerto
EXPOSE 8088

# Usar entrypoint.sh para lanzar el solver
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]