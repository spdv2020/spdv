CREATE OR REPLACE FUNCTION spdv.adicionar_produto_caixa(request_raw json) RETURNS json AS $$
import simplejson as json

request = json.loads(request_raw)

body = request.get('body')

userId = request.get('userId')

qtd = body.get('qtd')
codigo_barras = body.get('codigo_barras')

sql = """
  SELECT
    spdv.get_caixa_aberto_id() AS id
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

caixa = rv[0]

possui_caixa_aberto = True if caixa["id"] > 0 else False

if possui_caixa_aberto is False:
  plpy.error('Nenhum caixa está aberto')

sql = """
  SELECT
    p.id,
    p.valor_unit,
    p.nome
    FROM
      spdv.produtos p
    WHERE
      p.ativo = true AND
      p.codigo_barras = $1
"""

plan = plpy.prepare(sql, ['text'])
rv = plpy.execute(plan, [codigo_barras])

if len(rv) == 0:
  plpy.error('Produto não encontrado')

produto = rv[0]

sql = """
  SELECT v.id
    FROM
      spdv.vendas v
    WHERE
      v.caixa_id = $1 AND
      v.usuario_id = $2 AND
      v.status = $3
"""

plan = plpy.prepare(sql, ['bigint', 'bigint', 'spdv.venda_status'])
rv = plpy.execute(plan, [caixa['id'], userId, 'ABERTO'])

if len(rv) == 0:
  sql = """
    INSERT
      INTO spdv.vendas
        (caixa_id, usuario_id, status)
      VALUES ($1, $2, $3)
      RETURNING id
  """

  plan = plpy.prepare(sql, ['bigint', 'bigint', 'spdv.venda_status'])
  rv = plpy.execute(plan, [caixa['id'], userId, 'ABERTO'])

venda = rv[0]

sql = """
  INSERT
    INTO spdv.venda_produtos
      (valor_unit, quantidade, venda_id, produto_id)
    VALUES ($1, $2, $3, $4)
    RETURNING id, ROUND(valor_unit::numeric * quantidade, 2) AS total
"""

plan = plpy.prepare(sql, ['real', 'integer', 'bigint', 'bigint'])
rv = plpy.execute(plan, [produto['valor_unit'], qtd, venda['id'], produto['id']])

venda_produto = rv[0]

response = {
  'code': 200,
  'body': {
    'venda_produto_id': venda_produto['id'],
    'produto': {
      'nome': produto['nome'],
      'total': venda_produto['total']
    }
  }
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;