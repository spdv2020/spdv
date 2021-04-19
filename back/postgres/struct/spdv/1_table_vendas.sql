CREATE TABLE spdv.vendas
(
  id bigserial NOT NULL,
  valor_total real NOT NULL DEFAULT 0,
  valor_recebido real NOT NULL DEFAULT 0,
  valor_troco real NOT NULL DEFAULT 0,
  valor_desconto real NOT NULL DEFAULT 0,

  metodo_pagamento spdv.venda_metodo_pagamento,
  status spdv.venda_status NOT NULL,

  caixa_id bigint NOT NULL,
  cliente_id bigint,

  usuario_id bigint NOT NULL,

  data_criacao timestamp without time zone NOT NULL DEFAULT NOW(),
  data_atualizacao timestamp without time zone NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id)
);

ALTER TABLE spdv.vendas
  OWNER to postgres;