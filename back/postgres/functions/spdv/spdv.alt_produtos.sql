CREATE OR REPLACE FUNCTION spdv.alt_produtos(request_raw json) RETURNS json AS $$
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
    'valor_unit': { 'type': 'number' },
    'codigo_barras': { 'type': 'string' },
    'marca_id': { 'type': 'number' },
    'subcategoria_id': { 'type': 'number' },
    'tags': {
      'type': 'array',
      'items': {
        'type': 'string'
      }
    }
  },
  'required': ['id', 'nome', 'valor_unit']
})

request = json.loads(request_raw)

id = body.get('id')
nome = body.get('nome')
valor_unit = body.get('valor_unit')
codigo_barras = body.get('codigo_barras')
marca_id = body.get('marca_id')
subcategoria_id = body.get('subcategoria_id')
tags = body.get('tags')

sql = """
  UPDATE spdv.produtos p
    SET nome = $2, valor_unit = $3, codigo_barras = $4, marca_id = $5, subcategoria_id = $6
    WHERE p.id = $1
"""

plan = plpy.prepare(sql, ['bigint', 'text', 'real', 'text', 'bigint', 'bigint'])

try:
  rv = plpy.execute(plan, [id, nome, valor_unit, codigo_barras, marca_id, subcategoria_id])
except spiexceptions.ExclusionViolation as e:
  response = {
    'code': 500,
    'body': {
      'message': 'Produto com código de barras "%s" já existe' % codigo_barras
    }
  }
else:
  sql = 'DELETE FROM spdv.produto_tags p WHERE p.produto_id = $1'

  plan = plpy.prepare(sql, ['bigint'])
  plpy.execute(plan, [id])

  if tags is not None:
    for tag in tags:
      sql = 'INSERT INTO spdv.produto_tags (produto_id, nome) VALUES ($1, $2)'

      plan = plpy.prepare(sql, ['bigint', 'text'])
      plpy.execute(plan, [id, tag])

  response = {
    'code': 201,
    'body': {
      'message': 'Produto alterado com sucesso'
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;