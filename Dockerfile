FROM centos:7.4.1708

ADD https://github.com/nvogel/echo/releases/download/0.0.1/echo /
RUN chmod u+x /echo
CMD ["/echo"]
