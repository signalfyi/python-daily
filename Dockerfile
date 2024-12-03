# Stage 1: Base Image
FROM python:latest@sha256:22723cfdc8ca2aba70201fb9b3d8ab66b33633b260aed95609d7f21a5eb6de33 AS base

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Run any application-specific setup if necessary
RUN python setup.py install

# Stage 2: Build Stage
FROM base AS builder

# Optional: Build any additional assets or perform pre-compilation if needed
# Example: Compiling Python C extensions, frontend assets, etc.
# RUN python setup.py build_ext --inplace

# Stage 3: Final Stage
FROM python:slim@sha256:0de818129b26ed8f46fd772f540c80e277b67a28229531a1ba0fdacfaed19bcb AS final

# Set working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app /app

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python", "app.py"]