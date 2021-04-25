CREATE OR REPLACE FUNCTION spdv.get_produto_subcategorias(request_raw json) RETURNS json AS $$
import json

request = json.loads(request_raw)

sql = """
  SELECT
    pm.*,
    pc.nome as categoria
    FROM
      spdv.produto_subcategorias pm
    INNER JOIN
      spdv.produto_categorias pc
        ON pc.id = pm.categoria_id
    WHERE
      pm.ativo = true
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

data = []
for i in rv:
  data.append(i)

response = {
  'code': 200,
  'body': data
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;