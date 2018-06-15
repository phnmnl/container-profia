FROM ubuntu:16.04
# TODO Try instead a lighter version (based on Alpine Linux):
# FROM container-registry.phenomenal-h2020.eu/phnmnl/rbase

# Some change to trigger Jenkins

MAINTAINER Etienne Thevenot (etienne.thevenot@cea.fr)

ENV TOOL_NAME=profia
ENV TOOL_VERSION=3.1.0
ENV CONTAINER_VERSION=1.0
ENV CONTAINER_GITHUB=https://github.com/phnmnl/container-profia

LABEL version="${CONTAINER_VERSION}"
LABEL software.version="${TOOL_VERSION}"
LABEL software="${TOOL_NAME}"
LABEL base.image="ubuntu:16.04"
LABEL description=""
LABEL website="${CONTAINER_GITHUB}"
LABEL documentation="${CONTAINER_GITHUB}"
LABEL license="${CONTAINER_GITHUB}"
LABEL tags="Metabolomics"

# TODO when all RUN statements are tested and working correctly, merge them all together using "&& \"

# Update system
RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends r-base git

# Clone tool repos
RUN git clone -b v${TOOL_VERSION} https://github.com/workflow4metabolomics/profia /files/profia

# Install requirements
RUN echo 'options("repos"="http://cran.rstudio.com")' >> /etc/R/Rprofile.site
RUN R -e "install.packages(c('batch','PMCMR'), dependencies = TRUE)"

# Clean
RUN apt-get purge -y git
RUN apt-get clean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Make tool accessible through PATH
ENV PATH=$PATH:/files/profia

# Make test script accessible through PATH
ENV PATH=$PATH:/files/profia/test

# Define Entry point script
ENTRYPOINT ["/files/profia/profia_wrapper.R"]
