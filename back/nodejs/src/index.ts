import express from 'express'

import { execute } from './database'

import cors from 'cors'
import bodyParser from 'body-parser'
// rest of the code remains same
const app = express()

const PORT = 8081

app.use(cors())
app.use(bodyParser.json())

app.all('*', async (req: express.Request, res: express.Response) => {
  const result = await execute({
    route: req.path,
    headers: req.headers,
    body: req.body,
    method: req.method
  })

  res.status(result.code)
  res.header(result.headers)
  res.send(JSON.stringify(result.body))
})

app.listen(PORT, () => {
  console.log(`⚡️[server]: Server is running at https://localhost:${PORT}`)
})