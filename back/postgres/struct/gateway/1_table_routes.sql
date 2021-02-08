CREATE TABLE gateway.routes
(
  id bigserial NOT NULL,
  method gateway.method NOT NULL,
  name character varying(100) NOT NULL,
  description character varying(300),
  function_name character varying(200) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT ukc_gtw_rou_name UNIQUE (method, name)
);

ALTER TABLE gateway.routes
  OWNER to postgres;