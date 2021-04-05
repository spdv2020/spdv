CREATE OR REPLACE FUNCTION spdv.login(request_raw json) RETURNS json AS $$
import jwt
import json
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'email': { 'type': 'string' },
    'senha': { 'type': 'string' }
  },
  'required': ['email', 'senha']
})

sql = """
  SELECT
    u.id,
    u.nome
    FROM
      spdv.usuarios u
    WHERE
      LOWER(u.email) = LOWER($1) AND 
      u.senha = encode(public.digest($2, 'sha256'), 'base64')
"""

email = body.get('email')
senha = body.get('senha')

plan = plpy.prepare(sql, ['text', 'text'])
rv = plpy.execute(plan, [email, senha])

if rv.nrows() != 1:
  response = {
    'code': 500,
    'body': {
      'message': 'Usuário ou senha inválidos'
    }
  }
else:
  row = rv[0]

  payload = {
    'sub': row['id'],
    'name': row['nome']
  }

  token = jwt.encode(payload, '#spdv202!', algorithm='HS256')

  response = {
    'code': 200,
    'body': {
      'token': token
    }
  }

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;