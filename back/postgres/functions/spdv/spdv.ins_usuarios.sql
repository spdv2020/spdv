CREATE OR REPLACE FUNCTION spdv.ins_usuarios(request_raw json) RETURNS json AS $$
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
    'nome':  { 'type': 'string' }
  },
  'required': ['email', 'senha', 'nome']
})

email = body.get('email')
senha = body.get('senha')
nome = body.get('nome')

sql = """
  INSERT
    INTO
      spdv.usuarios (email, senha, nome)
    VALUES
      ($1, encode(public.digest($2, 'sha256'), 'base64'), $3)
    RETURNING id
"""

plan = plpy.prepare(sql, ['text', 'text', 'text'])

try:
  rv = plpy.execute(plan, [email, senha, nome])
except spiexceptions.ExclusionViolation as e:
  response = {
    'code': 500,
    'body': {
      'message': 'Usuario "%s" já existe' % email
    }
  }
else:
  row = rv[0]

  usuario_id = row['id']

  response = {
    'code': 201,
    'body': {
      'usuario_id': usuario_id,
      'message': 'Usuario inserido com sucesso'
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;