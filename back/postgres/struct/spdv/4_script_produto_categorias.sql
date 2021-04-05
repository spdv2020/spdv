INSERT INTO spdv.produto_categorias (id, nome) VALUES (1, 'Amendoim');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (2, 'Bala');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (3, 'Biscoito');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (4, 'Bolo');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (5, 'Chiclete');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (6, 'Chocolate');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (7, 'Confeito');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (8, 'Creme de leite');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (9, 'Decoração Festa');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (10, 'Descartáveis');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (11, 'Doce Caseiro');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (12, 'Doce Tradicional');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (13, 'Geleia');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (14, 'Goma');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (15, 'Leite Condensado');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (16, 'Marshmallow');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (17, 'Pipoca');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (18, 'Pirulito');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (19, 'Salgadinho');
INSERT INTO spdv.produto_categorias (id, nome) VALUES (20, 'Sorvete');

DO $$
DECLARE maxid bigint;
BEGIN
    SELECT MAX(id) + 1 from spdv.produto_categorias into maxid;
    EXECUTE 'ALTER SEQUENCE spdv.produto_categorias_id_seq RESTART WITH ' || maxid;   
END;
$$ LANGUAGE plpgsql