CREATE TABLE spdv.produto_marcas
(
  id bigserial NOT NULL,
  nome character varying(100) NOT NULL,
  ativo boolean not null default true,
  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id),
  CONSTRAINT ukc_spd_pma_nome EXCLUDE (nome WITH =) WHERE (ativo = true)
  -- CONSTRAINT ukc_spd_pma_nome UNIQUE (nome, ativo) WHERE (ativo = true)
);

ALTER TABLE spdv.produto_marcas
  OWNER to postgres;