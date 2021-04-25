CREATE OR REPLACE FUNCTION spdv.fechar_venda(request_raw json) RETURNS json AS $$
import json

request = json.loads(request_raw)

body = request.get('body')

userId = request.get('userId')

desconto = request.get('desconto')
valor_recebido = request.get('valor_recebido')

sql = """
  SELECT
    spdv.get_caixa_aberto_id() AS id
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

caixa = rv[0]

possui_caixa_aberto = True if caixa["id"] > 0 else False

if possui_caixa_aberto is False:
  plpy.error('Nenhum caixa está aberto')

sql = """
  SELECT v.id
    FROM
      spdv.vendas v
    WHERE
      v.caixa_id = $1 AND
      v.usuario_id = $2 AND
      v.status = $3
"""

plan = plpy.prepare(sql, ['bigint', 'bigint', 'spdv.venda_status'])
rv = plpy.execute(plan, [caixa['id'], userId, 'ABERTO'])

if len(rv) == 0:
  plpy.error('Não existe venda aberta')

venda = rv[0]

sql = """
  UPDATE
      spdv.vendas v
    SET
      status = $2
    WHERE
      v.id = $1
"""

plan = plpy.prepare(sql, ['bigint', 'spdv.venda_status'])
rv = plpy.execute(plan, [venda['id'], 'CANCELADO'])

response = {
  'code': 200,
  'body': {
    'venda_id': venda['id'],
    'message': 'Venda cancelada com sucesso'
  }
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;