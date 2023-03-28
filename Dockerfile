FROM islasgeci/base:1.0.0
COPY . /workdir
RUN Rscript -e "remotes::install_github('IslasGECI/testtools')"
