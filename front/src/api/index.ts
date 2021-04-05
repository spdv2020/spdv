export async function execute (method: string, path: string, body: object = {}) {
  const token = window.localStorage.getItem('token')

  const options: RequestInit = {
    method: method,
    headers: {
      'Content-Type': 'application/json',
      Authorization: token || ''
    },
    body: JSON.stringify(body)
  }

  if (method === 'GET') {
    delete options.body
  }

  const res = await fetch(`http://localhost:8081${path}`, options)

  const data = await res.json()

  if (res.status >= 400) {
    throw new Error(data.message)
  }

  return data
}
