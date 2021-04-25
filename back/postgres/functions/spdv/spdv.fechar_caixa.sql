CREATE OR REPLACE FUNCTION spdv.fechar_caixa(request_raw json) RETURNS json AS $$
import json

request = json.loads(request_raw)

body = request.get('body')

userId = request.get('userId')

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
  SELECT COUNT(v.id) as total
    FROM
      spdv.vendas v
    WHERE
      v.caixa_id = $1 AND
      v.status = $2
"""

plan = plpy.prepare(sql, ['bigint', 'spdv.venda_status'])
rv = plpy.execute(plan, [caixa['id'], 'ABERTO'])

vendas = rv[0]

if vendas['total'] > 0:
  plpy.error('Não foi possível fechar o caixa. Existem vendas em aberto no momento.')

sql = """
  INSERT
      INTO spdv.caixa_movimentos
        (caixa_id, usuario_id_movimento, tipo, valor)
      VALUES ($1, $2, $3, spdv.total_caixa($1))
      RETURNING id
"""

plan = plpy.prepare(sql, ['bigint', 'bigint', 'spdv.caixa_movimento_tipo'])
rv = plpy.execute(plan, [caixa['id'], userId, 'FECHAMENTO'])

if len(rv) == 0:
  plpy.error('Falha ao fechar caixa.')

sql = """
  UPDATE
      spdv.caixas c
    SET
      data_fechamento = NOW(),
      usuario_id_fechamento = $2
    WHERE
      c.id = $1
"""

plan = plpy.prepare(sql, ['bigint', 'bigint'])
rv = plpy.execute(plan, [caixa['id'], userId])

response = {
  'code': 200,
  'body': {
    'caixa': caixa['id'],
    'message': 'Caixa fechado com sucesso'
  }
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;