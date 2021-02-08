CREATE TABLE spdv.usuarios
(
  id bigserial NOT NULL,
  email spdv.email NOT NULL,
  senha character varying(64) NOT NULL,
  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id),
  CONSTRAINT ukc_spd_usr_username UNIQUE (email)
);

ALTER TABLE spdv.usuarios
  OWNER to postgres;