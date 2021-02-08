import { Client } from 'pg'

interface Response {
  code: number,
  headers: object,
  body: object,
  method: string
}

async function execute(data: Object) {
  const client = new Client({
    database: 'spdv',
    user: 'spdv_app',
    password: 'spdv2021',
    host: 'localhost',
    port: 5432
  })

  await client.connect()

  const res = await client.query('SELECT gateway.handle($1)::text AS response', [JSON.stringify(data)])

  await client.end()

  const response: Response = JSON.parse(res.rows[0]['response'])

  return response
}

export { execute }