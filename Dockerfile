FROM perl:latest
LABEL version="1.0"
LABEL description="Foo Bar foo.bar@gmail.com"

# add C dependencies 
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libxml2-dev \
    libexpat1-dev \
    zlib1g-dev \
    libpq-dev \
    libmariadb-dev \
    mariadb-client \
    libdbd-mariadb-perl \
    ssh \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Perl dependencies as root
RUN curl -L http://cpanmin.us | perl - App::cpanminus && \
    cpanm --notest --verbose Carton

# Create user and setup directories
RUN groupadd -r my_app_group && useradd -r -g my_app_group -m -d /home/my_app my_app_user && \
    mkdir -p /home/my_app && \
    chown -R my_app_user:my_app_group /home/my_app

# Switch to app user
USER my_app_user
WORKDIR /home/my_app

# Set up environment
ENV PATH="/home/my_app/local/bin:${PATH}"

# Copy and install dependencies
COPY --chown=my_app_user:my_app_group cpanfile /home/my_app/
COPY --chown=my_app_user:my_app_group cpanfile.snapshot /home/my_app

RUN carton install --deployment
# Copy application files
COPY --chown=my_app_user:my_app_group . /home/my_app/

EXPOSE 3000

CMD ["carton", "exec", "--", "morbo", "my_app/script/my_app"]
