const { Pool } = require('pg');
const pool = new Pool({
  user: 'rnd_user',
  host: '47.250.10.195',
  database: 'amast_rnd',
  password: 'rnduser@123',
  port: 5432,
})  

module.exports = pool