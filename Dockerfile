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
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size
# install Carton
RUN curl -L http://cpanmin.us | perl - App::cpanminus && \
    cpanm --notest --verbose Carton
# create a new user and group for your app 
RUN groupadd -r my_app_group && useradd -r -g my_app_group -m -d /home/my_app my_app_user
# create home dir for that user 
RUN mkdir -p /home/my_app && \
    chown -R my_app_user:my_app_group /home/my_app
# switch from root to the new user 
USER my_app_user

WORKDIR /home/my_app

ENV PATH="/home/my_app/.perl/bin:${PATH}"

# Copy application dependencies and files
COPY --chown=my_app_user:my_app_group cpanfile /home/my_app
COPY --chown=my_app_user:my_app_group cpanfile.snapshot /home/my_app

# Install dependencies using Carton
RUN carton install

EXPOSE 3000

ENTRYPOINT ["carton", "exec", "--", "morbo", "my_app/script/my_app"]