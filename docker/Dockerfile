FROM ubuntu:latest

# Update installed packages and install python3
RUN apt update && apt upgrade -y && \
    apt install -y python3 python3-pip python3-venv

# Set the workdir to /app
WORKDIR /app

# Copy the application files
COPY ./example-flask-crud /app

# Create the virtual environment
RUN python3 -m venv venv

# Install requirements using the virtual environment's pip
RUN ./venv/bin/pip install -r requirements.txt

# Setup environment variables
ENV FLASK_APP=crudapp.py

# Setup the database
RUN ./venv/bin/flask db init && \
    ./venv/bin/flask db migrate -m "entries table" && \
    ./venv/bin/flask db upgrade

# Expose flask default port
EXPOSE 80

# Run the application using the virtual environment's Flask
CMD ["./venv/bin/flask", "run", "--host=0.0.0.0", "--port", "80"]
