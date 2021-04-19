CREATE OR REPLACE FUNCTION spdv.ins_produto_subcategorias(request_raw json) RETURNS json AS $$
import json
from plpy import spiexceptions
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'nome': { 'type': 'string' },
    'categoria_id': { 'type': 'number' }
  },
  'required': ['nome', 'categoria_id']
})

request = json.loads(request_raw)

nome = body.get('nome')
categoria_id = body.get('categoria_id')

sql = """
  INSERT
    INTO
      spdv.produto_subcategorias (nome, categoria_id)
    VALUES ($1, $2)
    RETURNING id
"""

plan = plpy.prepare(sql, ['text', 'bigint'])

try:
  rv = plpy.execute(plan, [nome, categoria_id])
except spiexceptions.ExclusionViolation as e:
  response = {
    'code': 500,
    'body': {
      'message': 'Subcategoria "%s" já existe' % nome
    }
  }
else:
  row = rv[0]

  subcategoria_id = row['id']

  response = {
    'code': 201,
    'body': {
      'subcategoria_id': subcategoria_id,
      'message': 'Subcategoria inserida com sucesso'
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;