ALTER TABLE spdv.caixa_movimentos
  ADD CONSTRAINT fkc_spd_cxm_umid FOREIGN KEY (usuario_id_movimento)
  REFERENCES spdv.usuarios (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;

ALTER TABLE spdv.caixa_movimentos
  ADD CONSTRAINT fkc_spd_cxm_cxid FOREIGN KEY (caixa_id)
  REFERENCES spdv.caixas (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;