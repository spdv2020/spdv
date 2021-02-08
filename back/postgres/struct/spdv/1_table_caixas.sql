CREATE TABLE spdv.caixas
(
  id bigserial NOT NULL,
  data_abertura timestamp without time zone NOT NULL DEFAULT NOW(),
  data_fechamento timestamp without time zone,

  usuario_id_abertura bigint NOT NULL,
  usuario_id_fechamento bigint,

  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
);

ALTER TABLE spdv.caixas
  OWNER to postgres;