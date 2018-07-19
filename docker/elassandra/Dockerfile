FROM strapdata/elassandra:5.5.0.20

COPY custom-entrypoint.sh /custom-entrypoint.sh

ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["bin/cassandra"]