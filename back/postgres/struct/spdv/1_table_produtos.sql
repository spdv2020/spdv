CREATE TABLE spdv.produtos
(
  id bigserial NOT NULL,
  nome character varying(100) NOT NULL,
  valor_unit real NOT NULL,
  codigo_barras character varying(13),
  marca_id bigint,
  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id),
  CONSTRAINT ukc_spd_pro_codbar UNIQUE (codigo_barras)
);

ALTER TABLE spdv.produtos
  OWNER to postgres;