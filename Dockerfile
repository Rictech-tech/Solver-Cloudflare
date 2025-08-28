# Imagen base con Python
FROM python:3.11-slim

# Evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza e instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    git curl wget unzip \
    libnss3 libxss1 libasound2 fonts-liberation libatk1.0-0 \
    libatk-bridge2.0-0 libcups2 libdrm2 libgbm1 libgtk-3-0 \
    libxcomposite1 libxrandr2 libxi6 \
    && rm -rf /var/lib/apt/lists/*

# Instalar turnstile_solver desde GitHub
RUN pip install --no-cache-dir git+https://github.com/odell0111/turnstile_solver@main

# Instalar patchright (para el navegador parcheado)
RUN pip install --no-cache-dir patchright \
    && patchright install chrome

# Crear un directorio de trabajo
WORKDIR /app

# Exponer el puerto que usa el solver
EXPOSE 8088

# Comando por defecto para arrancar el solver
CMD ["solver", "--port", "8088", "--secret", "jWRN7DH6", "--browser-position", "--max-attempts", "3", "--captcha-timeout", "30", "--page-load-timeout", "30", "--reload-on-overrun"]