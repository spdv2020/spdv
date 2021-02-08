CREATE TABLE spdv.produto_marcas
(
  id bigserial NOT NULL,
  nome character varying(100) NOT NULL,
  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id),
  CONSTRAINT ukc_spd_pma_nome UNIQUE (nome)
);

ALTER TABLE spdv.produto_marcas
  OWNER to postgres;