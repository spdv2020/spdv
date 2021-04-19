CREATE OR REPLACE FUNCTION spdv.ins_produto_categorias(request_raw json) RETURNS json AS $$
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
      spdv.produto_categorias (nome)
    VALUES ($1)
    RETURNING id
"""

plan = plpy.prepare(sql, ['text'])

try:
  rv = plpy.execute(plan, [nome])
except spiexceptions.ExclusionViolation as e:
  response = {
    'code': 500,
    'body': {
      'message': 'Categoria "%s" já existe' % nome
    }
  }
else:
  row = rv[0]

  categoria_id = row['id']

  response = {
    'code': 201,
    'body': {
      'categoria_id': categoria_id,
      'message': 'Categoria inserida com sucesso'
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;