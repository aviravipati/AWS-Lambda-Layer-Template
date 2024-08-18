# Use Amazon Linux 2023 as the base image
FROM amazonlinux:2023

# Install necessary tools and Python 3.11
RUN dnf update -y && \
    dnf install -y \
    python3.11 \
    python3.11-pip \
    python3.11-devel \
    gcc \
    openssl-devel \
    zip \
    unzip

# Verify Python and pip versions
RUN python3.11 --version && pip3.11 --version

# Verify SSL module availability
RUN python3.11 -c "import ssl; print(ssl.OPENSSL_VERSION)"

# Set the working directory
WORKDIR /layer

# Create a directory for the layer content
RUN mkdir -p /layer/python/lib/python3.11/site-packages

# Copy your Lambda function code and requirements.txt
COPY app/requirements.txt .
COPY app/ .

# Create a virtual environment and install dependencies
RUN python3.11 -m venv create_layer && \
    . create_layer/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Attempt to import the necessary libraries to ensure they are installed correctly
RUN . create_layer/bin/activate && \
    python3.11 -c "import pandas; print(pandas.__version__); from openai import OpenAI;" 

# Create the required directory structure for the Lambda layer
RUN mkdir -p python && \
    cp -r create_layer/lib/python3.11/site-packages/* python/ && \
    cp -r create_layer/lib64/python3.11/site-packages/* python/ || true


# Clean up any unnecessary files
RUN find python -name "*.pyc" -delete && \
    find python -type d -name "__pycache__" -exec rm -r {} + && \
    find python -type d -name "*.egg-info" -exec rm -r {} +

# Zip the contents of the python directory to create the Lambda layer package
RUN zip -r layer_content.zip python

# Set the command to display the contents of the zip file (for debugging)
CMD ["unzip", "-l", "layer_content.zip"]