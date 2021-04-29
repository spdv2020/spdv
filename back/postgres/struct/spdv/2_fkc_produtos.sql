ALTER TABLE spdv.produtos
  ADD CONSTRAINT fkc_spd_pro_mrid FOREIGN KEY (marca_id)
  REFERENCES spdv.produto_marcas (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;

ALTER TABLE spdv.produtos
  ADD CONSTRAINT fkc_spd_pro_sbcid FOREIGN KEY (subcategoria_id)
  REFERENCES spdv.produto_subcategorias (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;