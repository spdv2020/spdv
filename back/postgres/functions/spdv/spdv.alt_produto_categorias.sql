CREATE OR REPLACE FUNCTION spdv.alt_produto_categorias(request_raw json) RETURNS json AS $$
import json
from plpy import spiexceptions
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'id': { 'type': 'number' },
    'nome': { 'type': 'string' }
  },
  'required': ['nome', 'id']
})

request = json.loads(request_raw)

id = body.get('id')
nome = body.get('nome')

sql = """
  UPDATE spdv.produto_categorias s SET nome = $1 WHERE s.id = $2
"""

plan = plpy.prepare(sql, ['text', 'integer'])

try:
  rv = plpy.execute(plan, [nome, id])
except spiexceptions.UniqueViolation as e:
  response = {
    'code': 500,
    'body': {
      'message': 'Categoria "%s" já existe' % nome
    }
  }
else:
  response = {
    'code': 201,
    'body': {
      'message': 'Categoria alterada com sucesso'
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;