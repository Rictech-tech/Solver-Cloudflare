# Base Python
FROM python:3.11-slim

# Variables de entorno
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=America/New_York \
    SOLVER_SERVER_PORT=8088 \
    SOLVER_SECRET=jWRN7DH6

# Dependencias del sistema necesarias para Chrome
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget unzip locales \
    ca-certificates \
    fonts-liberation \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 \
    libdrm2 libgbm1 libgtk-3-0 libnss3 libx11-xcb1 libxcomposite1 \
    libxdamage1 libxrandr2 libxss1 libxtst6 xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Configurar locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen en_US.UTF-8

# Directorio de trabajo
WORKDIR /app

# Copiar requirements si existen
COPY requirements.txt .

# Instalar requirements
RUN pip install --no-cache-dir -r requirements.txt

# Instalar solver y patchright + Chrome
RUN pip install --no-cache-dir "git+https://github.com/odell0111/turnstile_solver.git@main" \
    && pip install --no-cache-dir patchright \
    && patchright install chrome

# Exponer puerto
EXPOSE ${SOLVER_SERVER_PORT}

# ENTRYPOINT directo
ENTRYPOINT ["solver"]

# CMD con logs limitados usando log-level (solo info crítica, warnings y errores)
CMD [ "--browser", "chrome", "--port", "8088", "--secret", "jWRN7DH6", "--max-attempts", "3", "--captcha-timeout", "30", "--page-load-timeout", "30", "--log-level", "WARN"]
