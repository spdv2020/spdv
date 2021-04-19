CREATE OR REPLACE FUNCTION spdv.abrir_caixa(request_raw json) RETURNS json AS $$
import json
from plpy import spiexceptions
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

userId = request.get('userId')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'aporte': { 'type': 'number' }
  }
})

request = json.loads(request_raw)

nome = body.get('aporte')

sql = """
  SELECT spdv.get_caixa_aberto_id() AS id
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

caixa = rv[0]

possui_caixa_aberto = True if caixa["id"] > 0 else False

if possui_caixa_aberto:
  plpy.error('Um caixa já está aberto')

sql = """
  INSERT
    INTO spdv.caixas
      (data_abertura, usuario_id_abertura)
    VALUES
      (NOW(), $1)
    RETURNING id
"""

plan = plpy.prepare(sql, ["bigint"])
rv = plpy.execute(plan, [userId])

caixa = rv[0]

response = {
  'code': 201,
  'body': {
    'caixa_id': caixa['id'],
    'message': 'Caixa aberto com sucesso'
  }
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;