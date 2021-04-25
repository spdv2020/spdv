CREATE OR REPLACE FUNCTION spdv.caixa_movimento(request_raw json) RETURNS json AS $$
import json
from plpy import spiexceptions
from jsonschema import validate

request = json.loads(request_raw)

body = request.get('body')

userId = request.get('userId')

valor = body.get('valor')
tipo = body.get('tipo')

validate(instance=body, schema={
  'type': 'object',
  'properties': {
    'valor': { 'type': 'number' },
    'tipo': { 'type': 'string' }
  }
})

if tipo != 'sangria' and tipo != 'aporte':
  plpy.error('Tipo de movimentação invalida')

if valor <= 0:
  plpy.error('Valor da movimentação deve ser maior que 0')

sql = """
  SELECT spdv.get_caixa_aberto_id() AS id
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

caixa = rv[0]

possui_caixa_aberto = True if caixa["id"] > 0 else False

if possui_caixa_aberto is False:
  plpy.error('Nenhum caixa está aberto')


sql = """
  INSERT
    INTO spdv.caixa_movimentos
      (caixa_id, usuario_id_movimento, valor, tipo)
    VALUES
      ($1, $2, $3, $4)
    RETURNING id
"""

if tipo == 'sangria':
  tipo = 'SANGRIA'
elif tipo == 'aporte':
  tipo = 'APORTE'

plan = plpy.prepare(sql, ['bigint', 'bigint', 'real', 'spdv.caixa_movimento_tipo'])
rv = plpy.execute(plan, [caixa['id'], userId, valor, tipo])

if len(rv) == 0:
  plpy.error('Não foi possível realizar a movimentação')

response = {
  'code': 201,
  'body': {
    'caixa_id': caixa['id'],
    'message': 'Movimentação realizada com sucesso'
  }
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;