# Stage 1: Base Image
FROM python:latest@sha256:785fef11f44b7393c03d77032fd72e56af8b05442b051a151229145e5fbbcb29 AS base

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
FROM python:slim@sha256:af4e85f1cac90dd3771e47292ea7c8a9830abfabbe4faa5c53f158854c2e819d AS final

# Set working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app /app

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python", "app.py"]