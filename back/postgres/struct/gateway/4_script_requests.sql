INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/login', 'Loga o usuário', 'spdv.login');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/usuarios', 'Retorna os usuários', 'spdv.get_usuarios');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/usuarios', 'Cria um usuário', 'spdv.ins_usuarios');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('DELETE', '/usuarios', 'Deleta um usuário', 'spdv.del_usuarios');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/produtos', 'Retorna os produtos', 'spdv.get_produtos');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/produtos', 'Cria um produto', 'spdv.ins_produtos');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('PATCH', '/produtos', 'Edita um produto', 'spdv.alt_produtos');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('DELETE', '/produtos', 'Deleta um produto', 'spdv.del_produtos');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/produtos/marcas', 'Retorna as marcas de produtos', 'spdv.get_produto_marcas');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/produtos/marcas', 'Cria uma marca', 'spdv.ins_produto_marcas');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('PATCH', '/produtos/marcas', 'Edita uma marca', 'spdv.alt_produto_marcas');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('DELETE', '/produtos/marcas', 'Deleta uma marca', 'spdv.del_produto_marcas');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/clientes', 'Retorna os clientes', 'spdv.get_clientes');