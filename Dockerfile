FROM python:3.12-slim

# Sistem paketlərini yükləyirik (Postgres üçün lazımdır)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# UV paket menecerini quraşdırırıq
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Paketləri köçürüb yükləyirik
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-cache

# Layihəni köçürürük
COPY . .

# Serveri başladırıq
CMD ["uv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
