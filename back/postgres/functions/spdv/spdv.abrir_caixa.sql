CREATE OR REPLACE FUNCTION spdv.ins_produtos(request_raw json) RETURNS json AS $$
import json
from plpy import spiexceptions
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'aporte': { 'type': 'number' }
  }
})

request = json.loads(request_raw)

nome = body.get('aporte')

sql = """
  SELECT
    COUNT(c.caixa_id) as total
  FROM
    spdv.caixas c
  WHERE
    c.data_fechamento IS NULL
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

caixa = rv[0]

possui_caixa_aberto = True if caixa["total"] > 0 else False

if possui_caixa_aberto:
  plpy.error('Um caixa já está aberto')


response = {
  'code': 201,
  'body': {
    'message': 'Produto inserido com sucesso'
  }
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;