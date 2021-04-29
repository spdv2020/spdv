CREATE OR REPLACE FUNCTION spdv.fechar_venda(request_raw json) RETURNS json AS $$
import json
import decimal

request = json.loads(request_raw)

body = request.get('body')

userId = request.get('userId')

valor_desconto = decimal.Decimal(body.get('valorDesconto'))
valor_recebido = decimal.Decimal(body.get('valorRecebido'))
metodo_pagamento = body.get('metodoPagamento')
cpf_cliente = body.get('cpfCliente')

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
  SELECT
    v.id,
    SUM(ROUND(vp.quantidade * vp.valor_unit::numeric, 2)) AS total
    FROM
      spdv.vendas v
    LEFT JOIN
	    spdv.venda_produtos vp
	      ON vp.venda_id = v.id
    WHERE
      v.caixa_id = $1 AND
      v.usuario_id = $2 AND
      v.status = $3
    GROUP BY v.id
"""

plan = plpy.prepare(sql, ['bigint', 'bigint', 'spdv.venda_status'])
rv = plpy.execute(plan, [caixa['id'], userId, 'ABERTO'])

if len(rv) == 0:
  plpy.error('Não existe venda aberta')

venda = rv[0]

subtotal = venda['total']
total = subtotal - valor_desconto
troco = valor_recebido - total

if troco < 0:
  plpy.error('O valor recebido é menor que o total da compra')

sql = """
  UPDATE
      spdv.vendas v
    SET
      valor_recebido = $2,
      valor_total = $3,
      valor_troco = $4,
      valor_desconto = $5,
      metodo_pagamento = $6,
      status = $7
    WHERE
      v.id = $1
"""

plan = plpy.prepare(sql, ['bigint', 'real', 'real', 'real', 'real', 'spdv.venda_metodo_pagamento', 'spdv.venda_status'])
rv = plpy.execute(plan, [venda['id'], valor_recebido, total, troco, valor_desconto, metodo_pagamento, 'ENCERRADO'])

if len(cpf_cliente) > 0:
  sql = """
    UPDATE
        spdv.vendas v
      SET
        cliente_cpf = $2
      WHERE
        v.id = $1
  """

  plan = plpy.prepare(sql, ['bigint', 'text'])
  rv = plpy.execute(plan, [venda['id'], cpf_cliente])

response = {
  'code': 200,
  'body': {
    'venda_id': venda['id'],
    'message': 'Venda fechada com sucesso'
  }
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;