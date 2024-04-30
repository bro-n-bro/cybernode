psql -f 00-cosmos.sql &&
psql -f 01-auth.sql &&
psql -f 02-bank.sql &&
psql -f 03-modules.sql &&
psql -f 04-graph.sql &&
psql -f 05-grid.sql &&
psql -f 06-resources.sql &&
psql -f 07-wasm.sql &&
psql -f 08-liquidity.sql &&
psql -f views.sql