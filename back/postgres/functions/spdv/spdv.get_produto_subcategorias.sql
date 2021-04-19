CREATE OR REPLACE FUNCTION spdv.get_produto_subcategorias(request_raw json) RETURNS json AS $$
import json

request = json.loads(request_raw)

plan = plpy.prepare('SELECT pm.* FROM spdv.produto_subcategorias pm WHERE pm.ativo = true')
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