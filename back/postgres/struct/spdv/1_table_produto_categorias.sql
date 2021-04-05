CREATE TABLE spdv.produto_categorias
(
  id bigserial NOT NULL,
  nome character varying(100) NOT NULL,
  ativo boolean not null default true,
  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id),
  CONSTRAINT ukc_spd_pcat_nome EXCLUDE (nome WITH =) WHERE (ativo = true)
  -- CONSTRAINT ukc_spd_pcat_nome UNIQUE (nome)
);

ALTER TABLE spdv.produto_categorias
  OWNER to postgres;