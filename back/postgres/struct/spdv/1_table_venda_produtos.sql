CREATE TABLE spdv.venda_produtos
(
  id bigserial NOT NULL,
  valor_unit real NOT NULL,
  valor_desconto real NOT NULL DEFAULT 0,

  quantidade integer NOT NULL DEFAULT 1,

  venda_id bigint NOT NULL,
  produto_id bigint NOT NULL,

  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
);

ALTER TABLE spdv.venda_produtos
  OWNER to postgres;