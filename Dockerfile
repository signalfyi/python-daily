# Stage 1: Base Image
FROM python:latest@sha256:8c55c44b9e81d537f8404d0000b7331863d134db87c1385dd0ec7fefff656495 AS base

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
FROM python:slim@sha256:8f3aba466a471c0ab903dbd7cb979abd4bda370b04789d25440cc90372b50e04 AS final

# Set working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app /app

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python", "app.py"]