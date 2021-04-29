CREATE OR REPLACE FUNCTION spdv.get_dashboard(request_raw json) RETURNS json AS $$
import simplejson as json

request = json.loads(request_raw)

body = request.get('body')
userId = request.get('userId')

sql = """
  SELECT
    COALESCE(SUM(v.valor_total), 0) AS valor_total,
	  date_trunc('day', NOW()) as data_atual
  FROM
    spdv.vendas v
  WHERE
    v.status = 'ENCERRADO' AND
    date_trunc('day', v.data_atualizacao) = date_trunc('day', NOW())
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

venda_dia = rv[0]

sql = """
  SELECT
    COALESCE(SUM(v.valor_total), 0) AS valor_total
  FROM
    spdv.vendas v
  WHERE
    v.status = 'ENCERRADO' AND
    date_trunc('month', v.data_atualizacao) = date_trunc('month', NOW())
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

venda_mes = rv[0]

sql = """
  SELECT
    x.nome
  FROM (
	  SELECT p.id,
	         p.nome,
	         SUM(vp.quantidade) as total
	    FROM spdv.vendas v
	  INNER JOIN spdv.venda_produtos vp ON vp.venda_id = v.id
	  INNER JOIN spdv.produtos p ON p.id = vp.produto_id
	  WHERE v.status = 'ENCERRADO' AND
      date_trunc('month', v.data_atualizacao) = date_trunc('month', NOW())
	  GROUP BY p.id
	  ORDER BY total DESC
  ) x LIMIT 1
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

produto_vendido = 'N/A'
if len(rv) > 0:
  produto_vendido = rv[0]['nome']

sql = """
  SELECT
    EXTRACT(MONTH FROM v.data_atualizacao) AS mes,
    COALESCE(SUM(v.valor_total), 0) AS valor_total
  FROM
    spdv.vendas v
  WHERE
    v.status = 'ENCERRADO'
	AND EXTRACT(YEAR FROM v.data_atualizacao) = EXTRACT(YEAR FROM NOW())
  GROUP BY
    mes
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

venda_p_mes = []
for i in rv:
  row = i.copy()
  venda_p_mes.append(row)

response = {
  'code': 200,
  'body': {
    'data_atual': venda_dia['data_atual'],
    'valor_dia': venda_dia['valor_total'],
    'valor_mes': venda_mes['valor_total'],
    'vendas_mes': venda_p_mes,
    'produto_vendido': produto_vendido
  }
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;