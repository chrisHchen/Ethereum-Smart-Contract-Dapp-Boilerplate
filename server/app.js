import 'babel-polyfill'
import express from 'express'
import logger from 'morgan'
import compression from 'compression'
import bodyParser from 'body-parser'
import session from 'express-session'
import router from './router'

const app = express()
const port = process.PORT || 3030
const isDeveloping = process.env.NODE_ENV == 'development'

if( isDeveloping ){
  app.set('showStackError', true)
  app.use(logger(':method :url :status'))
}

app.use(compression())
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())

app.use(session({
  secret: 'mutual',
  resave: false,
  saveUninitialized: true,
  cookie: { 
    maxAge:1000*60*60*24*30
  }
}))

router(app)

const server = app.listen( port, () => {
  const host = server.address().address
  const port = server.address().port
  console.log('mutual app listening at http://%s:%s', host, port)
})
