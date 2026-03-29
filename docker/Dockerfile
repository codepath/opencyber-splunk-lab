# docker/Dockerfile
#
# NOTE: This image is large (~2 GB) due to Splunk Enterprise.
# Students should pull the pre-built image from ghcr.io rather than building locally.
# On first container start, lab data is indexed automatically (~60 seconds).

FROM --platform=linux/amd64 ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 2. Download and install Splunk Enterprise
#    Splunk Enterprise has no arm64 package — amd64 runs under Rosetta 2 on Apple Silicon.
ARG SPLUNK_VERSION=9.0.4.1
ARG SPLUNK_BUILD=419ad9369127
RUN wget -qO /tmp/splunk.deb \
      "https://download.splunk.com/products/splunk/releases/${SPLUNK_VERSION}/linux/splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-linux-2.6-amd64.deb" && \
    dpkg -i /tmp/splunk.deb && \
    rm /tmp/splunk.deb

# 3. Configure admin credentials and Free license.
#    Both written to /opt/splunk/etc/system/local/ at build time so they apply
#    on every container start without requiring a runtime restart.
RUN printf '[user_info]\nUSERNAME = admin\nPASSWORD = codepath\n' \
      > /opt/splunk/etc/system/local/user-seed.conf && \
    printf '[license]\nactive_group = Free\n' \
      > /opt/splunk/etc/system/local/server.conf

# 4. Ensure the lab sentinel is never baked into the image.
#    Splunk's installer may leave files in /opt/splunk/var that get copied into
#    fresh named volumes on first use — if the sentinel exists there, the
#    first-run data indexing in the entrypoint would be silently skipped.
RUN rm -f /opt/splunk/var/.lab-initialized

# 5. Copy lab-owned data files
#    webauth.csv and the four malware investigation CSVs live in cyb102-vm-setup
#    for now and are downloaded below; they can move here once this lab owns them.
COPY docker/files/ /opt/splunk-data/

# 6. Download remaining data files from cyb102-vm-setup
ARG DATA_REPO=https://raw.githubusercontent.com/codepath/cyb102-vm-setup/main/Files/unit5
RUN wget -qO /opt/splunk-data/webauth.csv          "${DATA_REPO}/webauth.csv"          && \
    wget -qO /opt/splunk-data/webserver02.csv       "${DATA_REPO}/webserver02.csv"       && \
    wget -qO /opt/splunk-data/uploadedhashes.csv    "${DATA_REPO}/uploadedhashes.csv"    && \
    wget -qO /opt/splunk-data/failedlogins64.csv    "${DATA_REPO}/failedlogins64.csv"    && \
    wget -qO /opt/splunk-data/BlueCoatProxy01.csv   "${DATA_REPO}/BlueCoatProxy01.csv"

EXPOSE 8000

COPY --chmod=755 docker/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
