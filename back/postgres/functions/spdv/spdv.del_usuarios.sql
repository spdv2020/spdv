CREATE OR REPLACE FUNCTION spdv.del_usuarios(request_raw json) RETURNS json AS $$
import json
from plpy import spiexceptions
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'id': { 'type': 'number' }
  },
  'required': ['id']
})

id = body.get('id')

sql = """
  UPDATE spdv.usuarios u SET ativo = false WHERE u.id = $1
"""

plan = plpy.prepare(sql, ['int'])

try:
  rv = plpy.execute(plan, [id])
except e:
  response = {
    'code': 500,
    'body': {
      'message': 'Não foi possível excluir o usuário'
    }
  }
else:
  response = {
    'code': 200,
    'body': {
      'message': 'Usuario removido com sucesso'
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;