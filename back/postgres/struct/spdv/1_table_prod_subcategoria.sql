CREATE TABLE spdv.prod_subcategoria
(
  produto_id bigint NOT NULL,
  subcategoria_id bigint NOT NULL,
  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (produto_id, subcategoria_id)
);

ALTER TABLE spdv.prod_subcategoria
  OWNER to postgres;