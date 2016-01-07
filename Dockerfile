FROM scratch

COPY ./bin/registry /bin/registry
COPY ./etc/config-example.yml /etc/docker/registry/config.yml

VOLUME ["/var/lib/registry"]
EXPOSE 5000
ENTRYPOINT ["/bin/registry"]
CMD ["/etc/docker/registry/config.yml"]
