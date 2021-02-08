CREATE TABLE spdv.clientes
(
  id bigserial NOT NULL,
  nome character varying(120) NOT NULL,
  cpf character varying(11) NOT NULL,
  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id),
  CONSTRAINT ukc_spd_cli_cpf UNIQUE (cpf)
);

ALTER TABLE spdv.clientes
  OWNER to postgres;