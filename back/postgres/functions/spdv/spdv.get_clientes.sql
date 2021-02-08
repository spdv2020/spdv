CREATE OR REPLACE FUNCTION spdv.get_clientes(request_raw json) RETURNS json AS $$
import json

request = json.loads(request_raw)

plan = plpy.prepare('SELECT c.* FROM spdv.clientes c')
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