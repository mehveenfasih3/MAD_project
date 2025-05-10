# Use the official Python image
FROM python:3.12-slim

# Install system dependencies needed by mysqlclient, pyzbar, and OpenCV
RUN apt-get update && apt-get install -y \
    pkg-config \
    libmariadb-dev \
    gcc \
    python3-dev \
    zlib1g-dev \
    libzbar0 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the dependencies file to the container
COPY requirements.txt /app/

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire app to the container
COPY . /app/

# Expose the port your app runs on
EXPOSE 5000

# Start the Flask app with Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]