ALTER TABLE spdv.produto_tags
  ADD CONSTRAINT fkc_spd_ptag_prid FOREIGN KEY (produto_id)
  REFERENCES spdv.produtos (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;