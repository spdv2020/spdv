CREATE SCHEMA gateway
  AUTHORIZATION postgres;

CREATE TYPE gateway.method AS ENUM
(
  'GET', 'POST', 'PATCH', 'DELETE'
);