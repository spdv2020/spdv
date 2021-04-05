INSERT INTO spdv.produto_marcas (id, nome) VALUES (1, 'Altacopo');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (2, 'Arcor');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (3, 'Bauducco');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (4, 'Boreda');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (5, 'Clamel');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (6, 'Copobras');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (7, 'Copomais');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (8, 'Dadinho');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (9, 'Dori');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (10, 'Florestal');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (11, 'Garoto');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (12, 'Goldenplast');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (13, 'Halls');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (14, 'Hersheys');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (15, 'Italac');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (16, 'Lacta');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (17, 'M&M''s');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (18, 'Mendorato');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (19, 'Nbonn');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (20, 'Nestlé');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (21, 'Parati');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (22, 'Peccin');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (23, 'Piracanjuba');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (24, 'Prafesta');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (25, 'Santa Helena');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (26, 'Snickers');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (27, 'Trident');
INSERT INTO spdv.produto_marcas (id, nome) VALUES (28, 'Wyda');

DO $$
DECLARE maxid bigint;
BEGIN
    SELECT MAX(id) + 1 from spdv.produto_marcas into maxid;
    EXECUTE 'ALTER SEQUENCE spdv.produto_marcas_id_seq RESTART WITH ' || maxid;   
END;
$$ LANGUAGE plpgsql