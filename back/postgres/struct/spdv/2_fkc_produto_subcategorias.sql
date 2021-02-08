ALTER TABLE spdv.produto_subcategorias
  ADD CONSTRAINT fkc_spd_pscat_catid FOREIGN KEY (categoria_id)
  REFERENCES spdv.produto_categorias (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;