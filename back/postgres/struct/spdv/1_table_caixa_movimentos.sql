CREATE TABLE spdv.caixa_movimentos
(
  id bigserial NOT NULL,
  valor real NOT NULL,
  tipo spdv.caixa_movimento_tipo NOT NULL,
  usuario_id_movimento bigint NOT NULL,

  caixa_id bigint NOT NULL,

  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
);

ALTER TABLE spdv.caixa_movimentos
  OWNER to postgres;