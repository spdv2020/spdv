-- Handle request
CREATE OR REPLACE FUNCTION gateway.handle(request_raw json) RETURNS json AS $$
import json

try:
  request = json.loads(request_raw)

  plan = plpy.prepare('SELECT gateway.route($1) AS response', ["json"])
  rv = plpy.execute(plan, [request_raw], 1)

  response = json.loads(rv[0]["response"])
except plpy.SPIError as ex:
  code = 500
  message = str(ex)

  plpy.info(ex)

  response = {
    'code': code,
    'body': {
      'message': message
    }
  }

if 'headers' not in response:
  response['headers'] = {}

response['headers'].update({ 'Content-Type': 'application/json' })

response = json.dumps(response, separators=(',', ':'))

if 'route' in request and 'method' in request:
  plan = plpy.prepare('INSERT INTO gateway.requests (method, route, data_raw, response_raw) VALUES($1, $2, $3, $4)', ['gateway.method', 'text', 'json', 'json'])
  rv = plpy.execute(plan, [request.get('method'), request.get('route'), request_raw, response], 1)

return response
$$ LANGUAGE plpython3u SECURITY DEFINER SET search_path = pg_catalog, pg_temp;