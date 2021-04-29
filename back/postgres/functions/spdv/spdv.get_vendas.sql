CREATE OR REPLACE FUNCTION spdv.get_vendas(request_raw json) RETURNS json AS $$
import simplejson as json

request = json.loads(request_raw)

sql = """
  SELECT
    v.*,
    v.valor_total + v.valor_desconto as valor_subtotal,
    SUM(vt.quantidade) AS qtd_produtos
    FROM
      spdv.vendas v
    LEFT JOIN spdv.venda_produtos vt
      ON vt.venda_id = v.id
    GROUP BY
      v.id
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

data = []
for i in rv:
  row = i.copy()

  data.append(row)

response = {
  'code': 200,
  'body': data
}

return json.dumps(response, separators=(',', ':'), use_decimal=True)
$$ LANGUAGE plpython3u;