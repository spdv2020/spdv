-- Execute route
CREATE OR REPLACE FUNCTION gateway.route(request_raw json) RETURNS json AS $$
import json

request = json.loads(request_raw)

route = request.get('route')
if route is None:
  raise Exception('Route is not defined')

method = request.get('method')
if method is None:
  raise Exception('Method is not defined')

plan = plpy.prepare('SELECT r.function_name FROM gateway.routes r WHERE r.method = $1 AND r.name = $2', ['gateway.method', 'text'])
rv = plpy.execute(plan, [method, route], 1)

if rv.nrows() != 1:
  plpy.error("Route %s %s not found" % (method, route), detail = 404)

function_name = rv[0]['function_name']

plan = plpy.prepare('SELECT %s($1) AS response' % function_name, ['json'])
rv = plpy.execute(plan, [request_raw])

response = rv[0]['response']

return response
$$ LANGUAGE plpython3u;