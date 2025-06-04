# Stage 1: Base Image
FROM python:latest@sha256:0bc836167214f98aca9c9bca7b4c6dc2c2a77f4a29d5029e6561a14706335102 AS base

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
FROM python:slim@sha256:56a11364ffe0fee3bd60af6d6d5209eba8a99c2c16dc4c7c5861dc06261503cc AS final

# Set working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app /app

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python", "app.py"]