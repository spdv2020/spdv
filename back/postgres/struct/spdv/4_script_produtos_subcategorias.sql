INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (1, 'Alumínio', 10);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (2, 'Amargo', 6);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (3, 'Ao leite', 6);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (4, 'Bexigas', 9);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (5, 'Branco', 6);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (6, 'Brinquedos', 9);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (7, 'Diet', 12);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (8, 'Doce' , 3);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (9, 'Dura', 2);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (10, 'Em pó', 6);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (11, 'Formas', 9);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (12, 'Isopor', 10);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (13, 'Lembrancinhas', 9);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (14, 'Light', 12);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (15, 'Mastigável', 2);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (16, 'Meio Amargo', 6);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (17, 'Mistura', 4);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (18, 'Papel', 9);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (19, 'Pastilha', 2);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (20, 'Plástico', 10);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (21, 'Recheada', 2);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (22, 'Salgado', 3);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (23, 'Snack', 4);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (24, 'Toalhas', 9);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (25, 'Tradicional', 12);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (26, 'Variedades', 6);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (27, 'Velas', 9);
INSERT INTO spdv.produto_subcategorias (id, nome, categoria_id) VALUES (28, 'Wafer', 3);


DO $$
DECLARE maxid bigint;
BEGIN
    SELECT MAX(id) + 1 from spdv.produto_subcategorias into maxid;
    EXECUTE 'ALTER SEQUENCE spdv.produto_subcategorias_id_seq RESTART WITH ' || maxid;   
END;
$$ LANGUAGE plpgsql