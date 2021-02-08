ALTER TABLE spdv.prod_subcategoria
  ADD CONSTRAINT fkc_spd_prdscat_prid FOREIGN KEY (produto_id)
  REFERENCES spdv.produtos (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;

ALTER TABLE spdv.prod_subcategoria
  ADD CONSTRAINT fkc_spd_prdscat_scatid FOREIGN KEY (subcategoria_id)
  REFERENCES spdv.produto_subcategorias (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;