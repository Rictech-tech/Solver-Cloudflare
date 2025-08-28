# Base Python
FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=America/New_York \
    SOLVER_SERVER_PORT=8088 \
    SOLVER_SECRET=jWRN7DH6

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget unzip locales \
    libnss3 libxss1 libasound2 fonts-liberation \
    libatk1.0-0 libatk-bridge2.0-0 libcups2 \
    libdrm2 libgbm1 libgtk-3-0 \
    libxcomposite1 libxrandr2 libxi6 \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen en_US.UTF-8

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir "git+https://github.com/odell0111/turnstile_solver.git@main"
RUN pip install --no-cache-dir patchright && patchright install chrome

EXPOSE ${SOLVER_SERVER_PORT}

# ENTRYPOINT directo, sin sh -c
ENTRYPOINT ["solver"]

# CMD con variables de entorno ya definidas
CMD ["--browser", "chrome",
     "--port", "8088",
     "--secret", "jWRN7DH6",
     "--max-attempts", "3",
     "--captcha-timeout", "30",
     "--page-load-timeout", "30"]