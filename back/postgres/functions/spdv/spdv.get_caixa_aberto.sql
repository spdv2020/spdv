CREATE OR REPLACE FUNCTION spdv.get_caixa_aberto_id() RETURNS bigint AS $$
sql = """
  SELECT
    c.id
  FROM
    spdv.caixas c
  WHERE
    c.data_fechamento IS NULL
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

if len(rv) == 0:
  return -1

caixa = rv[0]

return caixa['id']
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION spdv.total_caixa(caixa_id bigint) RETURNS real AS $$
sql = """
  SELECT SUM(v.total) AS total FROM (
    SELECT
      SUM(v.valor_total) AS total
    FROM
      spdv.vendas v 
    WHERE
      v.caixa_id = $1 AND
      v.status = 'ENCERRADO'
    UNION
    SELECT
      SUM(CASE cm.tipo
        WHEN 'APORTE' THEN cm.valor 
        WHEN 'SANGRIA' THEN -cm.valor 
        ELSE 0 
      END) AS total 
    FROM
      spdv.caixa_movimentos cm 
    WHERE
      cm.caixa_id = $1 AND 
      cm.tipo IN ('APORTE', 'SANGRIA')
  ) v
"""

plan = plpy.prepare(sql, ['bigint'])
rv = plpy.execute(plan, [caixa_id])

if len(rv) == 0:
  return 0

caixa = rv[0]

return caixa['total']
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION spdv.get_caixa_aberto(request_raw json) RETURNS json AS $$
import simplejson as json

request = json.loads(request_raw)

body = request.get('body')
userId = request.get('userId')

sql = """
  SELECT
    spdv.get_caixa_aberto_id() as id
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

caixa = rv[0]
if caixa['id'] == -1:
  response = {
    'code': 200,
    'body': {
      'caixa_id': caixa['id']
    }
  }

  return json.dumps(response, separators=(',', ':'))

sql = """
  SELECT spdv.total_caixa($1) AS total
"""

plan = plpy.prepare(sql, ['bigint'])
rv = plpy.execute(plan, [caixa['id']])

caixa['total'] = rv[0]['total']

sql = """
  SELECT
    v.id,
    SUM(ROUND(vp.quantidade * vp.valor_unit::numeric, 2)) AS total
    FROM
      spdv.vendas v
    LEFT JOIN
	    spdv.venda_produtos vp
	      ON vp.venda_id = v.id
    WHERE
      v.caixa_id = $1 AND
      v.usuario_id = $2 AND
      v.status = $3
    GROUP BY v.id
"""

plan = plpy.prepare(sql, ['bigint', 'bigint', 'spdv.venda_status'])
rv = plpy.execute(plan, [caixa['id'], userId, 'ABERTO'])

if len(rv) == 0:
  response = {
    'code': 200,
    'body': {
      'caixa_id': caixa['id'],
      'caixa_total': caixa['total']
    }
  }

  return json.dumps(response, separators=(',', ':'))

venda = rv[0]

sql = """
  SELECT 
    vp.id as venda_produto_id,
    p.nome, 
    ROUND(vp.valor_desconto::numeric, 2) as valor_desconto,
    ROUND(vp.valor_unit::numeric, 2) as valor_unit, 
    vp.quantidade,
    ROUND(vp.quantidade * vp.valor_unit::numeric, 2) as total
    FROM
      spdv.venda_produtos vp
    INNER JOIN
      spdv.produtos p
        ON p.id = vp.produto_id
    WHERE
      vp.venda_id = $1
    ORDER BY vp.id DESC
"""

plan = plpy.prepare(sql, ['bigint'])
rv = plpy.execute(plan, [venda['id']])

produtos = []
for i in rv:
  row = i.copy()

  produtos.append(row)

response = {
  'code': 200,
  'body': {
    'caixa_id': caixa['id'],
    'caixa_total': caixa['total'],
    'venda': {
      'total': venda['total'],
      'produtos': produtos
    }
  }
}

return json.dumps(response, separators=(',', ':'))

$$ LANGUAGE plpython3u;