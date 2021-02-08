export async function execute (method: string, path: string, body: object = {}) {
  const options: RequestInit = {
    method: method,
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(body)
  }

  if (method === 'GET') {
    delete options.body
  }

  const res = await fetch(`http://localhost:8081${path}`, options)

  return await res.json()
}
