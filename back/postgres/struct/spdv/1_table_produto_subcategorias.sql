CREATE TABLE spdv.produto_subcategorias
(
  id bigserial NOT NULL,
  nome character varying(100) NOT NULL,
  categoria_id bigint NOT NULL,
  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id),
  CONSTRAINT ukc_spd_pscat_nome UNIQUE (categoria_id, nome)
);

ALTER TABLE spdv.produto_subcategorias
  OWNER to postgres;