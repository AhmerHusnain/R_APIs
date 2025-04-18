# Base image with R and plumber
FROM rocker/r-ver:4.2.0

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('plumber', 'httr', 'jsonlite'), repos='http://cran.rstudio.com/')"

# Copy the Plumber API file into the container
COPY plumber.R /app/plumber.R

# Expose the port the Plumber API will run on
EXPOSE 8000

# Set the working directory
WORKDIR /app

# Define the command to run the API
CMD ["R", "-e", "pr <- plumber::plumb('plumber.R'); pr$run(host = '0.0.0.0', port = 8000)"]
