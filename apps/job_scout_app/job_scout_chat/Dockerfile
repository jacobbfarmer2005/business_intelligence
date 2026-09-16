FROM rocker/shiny:4.6.0

# querychat, ellmer, and RSQLite need these system libraries;
# libuv1t64 is missing from rocker/shiny:4.6.0 but its fs package needs it
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev libssl-dev libxml2-dev libuv1t64 \
    && rm -rf /var/lib/apt/lists/*

# One dated CRAN snapshot so every build installs the same versions
RUN echo 'options(repos = c(CRAN = "https://p3m.dev/cran/__linux__/noble/2026-09-01"))' \
    >> /usr/local/lib/R/etc/Rprofile.site

# DT is a Suggests of querychat but app_obj() needs it at runtime; ggsql powers the visualize tool
RUN R -q -e "install.packages(c('shiny', 'bslib', 'DBI', 'RSQLite', 'ellmer', 'shinychat', 'querychat', 'DT', 'ggsql'))"

# Fail the build now, not at runtime, if anything is missing
RUN R -q -e "stopifnot(requireNamespace('querychat'), requireNamespace('RSQLite'), requireNamespace('DT'), requireNamespace('ggsql'), requireNamespace('fs')); cat(R.version.string, as.character(packageVersion('querychat')), '\n')"

WORKDIR /app
COPY app.R app.R
COPY data/ data/

EXPOSE 7860
CMD ["R", "-q", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 7860)"]
