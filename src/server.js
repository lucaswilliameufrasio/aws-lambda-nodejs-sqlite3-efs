const fastify = require('fastify')({
  logger: true,
})
const fs = require('fs')

const Database = require('better-sqlite3')

const port = process.env['PORT'] || 8080

const DATABASE_PATH = process.env.DATABASE_PATH || './users.db'

function createDatabase(tryAgain = true) {
  try {
    const database = new Database(DATABASE_PATH)
    database.exec(`
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                email TEXT NOT NULL
            );
        `)
    database.pragma('journal_mode = WAL')
    return database
  } catch (error) {
    console.error('Failed to create database', error)

    fs.unlinkSync(DATABASE_PATH)
    if (tryAgain) {
      console.log('Trying to create the database')
      return createDatabase(false)
    }
    throw error
  }
}

const database = createDatabase()

fastify.get('/', async (request, reply) => {
  return { hello: 'world' }
})

fastify.get('/users', async (request, reply) => {
  const users = database.prepare('SELECT * FROM users').all()

  return users
})

fastify.post('/users', async (request, reply) => {
  database
    .prepare('INSERT INTO users (name, email) VALUES (@name, @email)')
    .run({
      name: request.body.name,
      email: request.body.email,
    })

  return
})

const start = async () => {
  try {
    fastify.listen({ port })
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}
start()
