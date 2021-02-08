ALTER TABLE spdv.caixas
  ADD CONSTRAINT fkc_spd_cai_ufec FOREIGN KEY (usuario_id_fechamento)
  REFERENCES spdv.usuarios (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;

ALTER TABLE spdv.caixas
  ADD CONSTRAINT fkc_spd_cai_uaber FOREIGN KEY (usuario_id_abertura)
  REFERENCES spdv.usuarios (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;