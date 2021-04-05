CREATE OR REPLACE FUNCTION spdv.get_usuarios(request_raw json) RETURNS json AS $$
import json

request = json.loads(request_raw)

body = request.get('body')

plan = plpy.prepare('SELECT u.id, u.email, u.nome, u.data_criacao, u.data_atualizacao FROM spdv.usuarios u WHERE u.ativo = true')
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