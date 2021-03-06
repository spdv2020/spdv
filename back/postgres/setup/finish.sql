GRANT USAGE ON SCHEMA spdv TO spdv_app;
GRANT USAGE ON SCHEMA gateway TO spdv_app;

GRANT SELECT ON ALL TABLES IN SCHEMA spdv TO spdv_app;
GRANT SELECT ON ALL TABLES IN SCHEMA gateway TO spdv_app;

GRANT EXECUTE ON FUNCTION gateway.handle(json) TO spdv_app;

REVOKE CREATE ON SCHEMA public FROM public;