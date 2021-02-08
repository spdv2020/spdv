CREATE OR REPLACE FUNCTION spdv.get_usuarios(request_raw json) RETURNS json AS $$
import json

request = json.loads(request_raw)

plan = plpy.prepare('SELECT u.id, u.email, u.data_criacao, u.data_atualizacao FROM spdv.usuarios u')
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