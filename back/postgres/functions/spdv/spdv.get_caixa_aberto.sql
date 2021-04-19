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

CREATE OR REPLACE FUNCTION spdv.get_caixa_aberto(request_raw json) RETURNS json AS $$
import json

request = json.loads(request_raw)

sql = """
  SELECT
    spdv.get_caixa_aberto_id() as id
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

caixa = rv[0]

response = {
  'code': 200,
  'body': {
    'caixa_id': caixa['id']
  }
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;