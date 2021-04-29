CREATE OR REPLACE FUNCTION spdv.get_produtos(request_raw json) RETURNS json AS $$
import simplejson as json

request = json.loads(request_raw)

sql = """
  SELECT
    p.*,
    ROUND(p.valor_unit::numeric, 2) as valor_unit,
    psc.nome as subcategoria
    FROM
      spdv.produtos p
    INNER JOIN
      spdv.produto_subcategorias psc ON psc.id = p.subcategoria_id
    WHERE
      p.ativo = true
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