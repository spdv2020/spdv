CREATE TABLE spdv.produto_tags
(
  id bigserial NOT NULL,
  nome character varying(20) NOT NULL,
  produto_id bigint NOT NULL,
  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id),
  CONSTRAINT ukc_spd_ptag_nome UNIQUE (nome, produto_id)
);

ALTER TABLE spdv.produto_tags
  OWNER to postgres;