FROM centos:7.6.1810

ADD https://github.com/nvogel/echo/releases/download/0.0.3/echo-0.0.3-linux-amd64 /echo
RUN chmod u+x /echo
CMD ["/echo"]
