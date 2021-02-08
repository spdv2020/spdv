CREATE OR REPLACE FUNCTION spdv.get_produtos(request_raw json) RETURNS json AS $$
import json

request = json.loads(request_raw)

sql = """
  SELECT
    p.*,
    array_to_json(
      array_remove(
        array_agg(t.nome), NULL
      )
    ) as tags
    FROM
      spdv.produtos p
    LEFT JOIN spdv.produto_tags t
      ON t.produto_id = p.id
    GROUP BY
      p.id
"""

plan = plpy.prepare(sql)
rv = plpy.execute(plan)

data = []
for i in rv:
  row = i.copy()
  row['tags'] = json.loads(row['tags'])

  data.append(row)

response = {
  'code': 200,
  'body': data
}

return json.dumps(response, separators=(',', ':'))
$$ LANGUAGE plpython3u;