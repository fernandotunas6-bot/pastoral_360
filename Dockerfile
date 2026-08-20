# PASTORAL 360 - DOCKER CONTAINER DEPLOYMENT
FROM python:3.10-slim

WORKDIR /app

# Install dependencies
RUN pip install --no-cache-dir flask flask-cors openpyxl requests

# Copy project files
COPY . /app

EXPOSE 5000

ENV PYTHONUNBUFFERED=1

CMD ["python", "server.py"]
