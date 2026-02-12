# 1. Base image
FROM python:3.9-slim

# 2. Working directory inside container
WORKDIR /app

# 3. Copy dependency file
COPY requirements.txt .

# 4. Install dependencies
RUN pip install -r requirements.txt

# 5. Copy app code
COPY app.py .

# 6. Expose port
EXPOSE 80

# 7. Start app
CMD ["python", "app.py"]
