CREATE TABLE gateway.requests
(
  id bigserial NOT NULL,
  method gateway.method NOT NULL,
  route character varying(100) NOT NULL,
  data_raw json NOT NULL,
  response_raw json NOT NULL,
  created_at timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
);

CREATE INDEX idx_gtw_req_route
  ON gateway.requests USING btree
    (route ASC NULLS LAST);

ALTER TABLE gateway.requests
  OWNER to postgres;