ALTER TABLE spdv.venda_produtos
  ADD CONSTRAINT fkc_spd_vprd_vnid FOREIGN KEY (venda_id)
  REFERENCES spdv.vendas (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;

ALTER TABLE spdv.venda_produtos
  ADD CONSTRAINT fkc_spd_vprd_prid FOREIGN KEY (produto_id)
  REFERENCES spdv.produtos (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION
  NOT VALID;