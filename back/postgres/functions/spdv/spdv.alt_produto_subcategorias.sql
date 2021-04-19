CREATE OR REPLACE FUNCTION spdv.alt_produto_subcategorias(request_raw json) RETURNS json AS $$
import json
from plpy import spiexceptions
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'id': { 'type': 'number' },
    'nome': { 'type': 'string' },
    'categoria_id': { 'type': 'number' }
  },
  'required': ['nome', 'id', 'categoria_id']
})

request = json.loads(request_raw)

id = body.get('id')
nome = body.get('nome')
categoria_id = body.get('categoria_id')

sql = """
  UPDATE spdv.produto_subcategorias s SET nome = $1, categoria_id = $3 WHERE s.id = $2
"""

plan = plpy.prepare(sql, ['text', 'integer', 'bigint'])

try:
  rv = plpy.execute(plan, [nome, id, categoria_id])
except spiexceptions.UniqueViolation as e:
  response = {
    'code': 500,
    'body': {
      'message': 'Subcategoria "%s" já existe' % nome
    }
  }
else:
  response = {
    'code': 201,
    'body': {
      'message': 'Subcategoria alterada com sucesso'
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;