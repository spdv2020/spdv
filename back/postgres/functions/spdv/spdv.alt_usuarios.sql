CREATE OR REPLACE FUNCTION spdv.alt_usuarios(request_raw json) RETURNS json AS $$
import json
from plpy import spiexceptions
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'email': { 'type': 'string' },
    'senha': { 'type': 'string' },
    'nome':  { 'type': 'string' },
    'id': { 'type': 'number' }
  },
  'required': ['id', 'email', 'nome']
})

id = body.get('id')
email = body.get('email')
senha = body.get('senha')
nome = body.get('nome')

sql = """
  UPDATE
      spdv.usuarios u
    SET nome = $2, email = $3
    WHERE u.id = $1
"""

plan = plpy.prepare(sql, ['bigint', 'text', 'text'])

try:
  rv = plpy.execute(plan, [id, nome, email])

  if len(senha) > 8:
    sql = """
      UPDATE
          spdv.usuarios u
        SET senha = encode(public.digest($2, 'sha256'), 'base64')
        WHERE u.id = $1
    """

    plan = plpy.prepare(sql, ['bigint', 'text'])

    rv = plpy.execute(plan, [id, senha])
except spiexceptions.ExclusionViolation as e:
  response = {
    'code': 500,
    'body': {
      'message': 'Usuario "%s" já existe' % email
    }
  }
else:
  response = {
    'code': 201,
    'body': {
      'message': 'Usuario alterado com sucesso'
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;