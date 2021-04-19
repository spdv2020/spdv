CREATE SCHEMA spdv
  AUTHORIZATION postgres;

CREATE TYPE spdv.caixa_movimento_tipo AS ENUM
(
  'SANGRIA', 'APORTE', 'VENDA'
);

CREATE TYPE spdv.venda_metodo_pagamento AS ENUM
(
  'DINHEIRO', 'DEBITO', 'CREDITO'
);

CREATE TYPE spdv.venda_status AS ENUM
(
  'ENCERRADO', 'ABERTO', 'CANCELADO'
);

CREATE DOMAIN spdv.email AS TEXT CHECK
(
  VALUE ~ '^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'
);