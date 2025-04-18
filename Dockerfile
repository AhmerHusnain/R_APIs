FROM rocker/verse:4.2.0
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libicu-dev libsodium-dev libssl-dev libxml2-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site

# install the randomForest package
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("tidyverse",upgrade="never", version = "1.3.2")'
RUN Rscript -e 'remotes::install_version("plumber",upgrade="never", version = "1.2.0")'

RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone

EXPOSE 8000

ENTRYPOINT ["R", "-e", "library(plumber); library(tidyverse); library(readxl); plumb('plumber.R')$run(port=8000, host='0.0.0.0')"]