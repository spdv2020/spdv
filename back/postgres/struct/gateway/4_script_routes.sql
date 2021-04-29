INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/login', 'Loga o usuário', 'spdv.login');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/usuarios', 'Retorna os usuários', 'spdv.get_usuarios');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/usuarios', 'Cria um usuário', 'spdv.ins_usuarios');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('PATCH', '/usuarios', 'Altera um usuário', 'spdv.alt_usuarios');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('DELETE', '/usuarios', 'Deleta um usuário', 'spdv.del_usuarios');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/produtos', 'Retorna os produtos', 'spdv.get_produtos');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/produtos', 'Cria um produto', 'spdv.ins_produtos');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('PATCH', '/produtos', 'Edita um produto', 'spdv.alt_produtos');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('DELETE', '/produtos', 'Deleta um produto', 'spdv.del_produtos');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/produtos/categorias', 'Retorna as categorias de produtos', 'spdv.get_produto_categorias');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/produtos/categorias', 'Cria uma marca', 'spdv.ins_produto_categorias');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('PATCH', '/produtos/categorias', 'Edita uma marca', 'spdv.alt_produto_categorias');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('DELETE', '/produtos/categorias', 'Deleta uma marca', 'spdv.del_produto_categorias');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/produtos/subcategorias', 'Retorna as subcategorias de produtos', 'spdv.get_produto_subcategorias');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/produtos/subcategorias', 'Cria uma marca', 'spdv.ins_produto_subcategorias');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('PATCH', '/produtos/subcategorias', 'Edita uma marca', 'spdv.alt_produto_subcategorias');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('DELETE', '/produtos/subcategorias', 'Deleta uma marca', 'spdv.del_produto_subcategorias');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/produtos/marcas', 'Retorna as marcas de produtos', 'spdv.get_produto_marcas');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/produtos/marcas', 'Cria uma marca', 'spdv.ins_produto_marcas');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('PATCH', '/produtos/marcas', 'Edita uma marca', 'spdv.alt_produto_marcas');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('DELETE', '/produtos/marcas', 'Deleta uma marca', 'spdv.del_produto_marcas');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/clientes', 'Retorna os clientes', 'spdv.get_clientes');

INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/caixa', 'Abre um novo caixa', 'spdv.abrir_caixa');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/caixa/movimento', 'Realiza uma movimentação no caixa', 'spdv.caixa_movimento');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('DELETE', '/caixa', 'Fechar caixa', 'spdv.fechar_caixa');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/caixa', 'Recupera o caixa aberto', 'spdv.get_caixa_aberto');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/caixa/produto', 'Adiciona produto a venda', 'spdv.adicionar_produto_caixa');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('POST', '/caixa/venda', 'Fechar a venda', 'spdv.fechar_venda');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('DELETE', '/caixa/venda', 'Cancelar a venda', 'spdv.cancelar_venda');
INSERT INTO gateway.routes (method, name, description, function_name) VALUES ('GET', '/vendas', 'Relatório de vendas', 'spdv.get_vendas');