CREATE TABLE spdv.usuarios
(
  id bigserial NOT NULL,
  email spdv.email NOT NULL,
  senha character varying(45) NOT NULL,
  nome character varying(100) NOT NULL,
  ativo boolean not null default true,
  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id),
  CONSTRAINT ukc_spd_usr_username EXCLUDE (email WITH =) WHERE (ativo = true)
  -- CONSTRAINT ukc_spd_usr_username UNIQUE (email, ativo)
);

ALTER TABLE spdv.usuarios
  OWNER to postgres;