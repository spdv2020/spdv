CREATE OR REPLACE FUNCTION spdv.ins_produtos(request_raw json) RETURNS json AS $$
import json
from plpy import spiexceptions
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'nome': { 'type': 'string' },
    'valor_unit': { 'type': 'string' },
    'codigo_barras': { 'type': 'string' },
    'marca_id': { 'type': 'number' },
    'tags': {
      'type': 'array',
      'items': {
        'type': 'string'
      }
    }
  },
  'required': ['nome', 'valor_unit']
})

request = json.loads(request_raw)

nome = body.get('nome')
valor_unit = body.get('valor_unit')
codigo_barras = body.get('codigo_barras')
marca_id = body.get('marca_id')
tags = body.get('tags')

sql = """
  INSERT
    INTO
      spdv.produtos (nome, valor_unit, codigo_barras, marca_id)
    VALUES ($1, $2, $3, $4)
    RETURNING id
"""

plan = plpy.prepare(sql, ['text', 'real', 'text', 'bigint'])

try:
  rv = plpy.execute(plan, [nome, valor_unit, codigo_barras, marca_id])
except spiexceptions.UniqueViolation as e:
  response = {
    'code': 500,
    'body': {
      'message': 'Produto "%s" já existe' % nome
    }
  }
else:
  row = rv[0]

  produto_id = row['id']

  if tags is not None:
    for tag in tags:
      sql = 'INSERT INTO spdv.produto_tags (produto_id, nome) VALUES ($1, $2)'

      plan = plpy.prepare(sql, ['bigint', 'text'])
      plpy.execute(plan, [produto_id, tag])

  response = {
    'code': 201,
    'body': {
      'produto_id': produto_id,
      'message': 'Produto inserido com sucesso'
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;