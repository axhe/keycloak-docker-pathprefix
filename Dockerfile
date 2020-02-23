FROM quay.io/keycloak/keycloak:9.0.0

USER root

COPY docker-entrypoint-pathprefix.sh /opt/
RUN chmod +x /opt/docker-entrypoint-pathprefix.sh

COPY healthcheck.sh /opt/
RUN chmod +x /opt/healthcheck.sh

USER 1000

HEALTHCHECK --interval=30s --timeout=1s --retries=3 CMD /opt/healthcheck.sh

ENTRYPOINT ["/opt/docker-entrypoint-pathprefix.sh"]
CMD ["-b", "0.0.0.0"]