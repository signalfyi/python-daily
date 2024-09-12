# Stage 1: Base Image
FROM python:latest@sha256:73840b2eacd375e9ab38d65c5ccca1f98524cabccbdc4f9d0932a55d1967a1ab AS base

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
FROM python:slim@sha256:8ac54da5710cdd31639bb66f5bc1888948fc2866c0b5b52913b4b33d8252e510 AS final

# Set working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app /app

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python", "app.py"]