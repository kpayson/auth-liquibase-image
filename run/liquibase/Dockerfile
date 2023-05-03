ARG LIQUIBASE_VERSION=4.21.0

FROM liquibase/liquibase:$LIQUIBASE_VERSION

# we need jq for the cloud foundry deployment
USER root
RUN apt-get update && \
    apt-get install -y  jq && \
    rm -rf /var/lib/apt/lists/*

ADD ./changelog /liquibase/changelog
ADD ./liquibase.properties /liquibase/liquibase.properties
ADD ./scripts/wait_for_db.sh /liquibase/wait_for_db.sh
