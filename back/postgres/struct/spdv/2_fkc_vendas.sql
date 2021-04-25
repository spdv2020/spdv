ALTER TABLE spdv.vendas
  ADD CONSTRAINT fkc_spd_ven_cxid FOREIGN KEY (caixa_id)
  REFERENCES spdv.caixas (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;

ALTER TABLE spdv.vendas
  ADD CONSTRAINT fkc_spd_ven_usid FOREIGN KEY (usuario_id)
  REFERENCES spdv.usuarios (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;