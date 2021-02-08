CREATE OR REPLACE FUNCTION spdv.ins_produto_marcas(request_raw json) RETURNS json AS $$
import json
from plpy import spiexceptions
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'nome': { 'type': 'string' }
  },
  'required': ['nome']
})

request = json.loads(request_raw)

nome = body.get('nome')

sql = """
  INSERT
    INTO
      spdv.produto_marcas (nome)
    VALUES ($1)
    RETURNING id
"""

plan = plpy.prepare(sql, ['text'])

try:
  rv = plpy.execute(plan, [nome])
except spiexceptions.UniqueViolation as e:
  response = {
    'code': 500,
    'body': {
      'message': 'Marca "%s" já existe' % nome
    }
  }
else:
  row = rv[0]

  marca_id = row['id']

  response = {
    'code': 201,
    'body': {
      'marca_id': marca_id,
      'message': 'Marca inserida com sucesso'
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;