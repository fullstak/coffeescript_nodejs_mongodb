express = require "express"
main= require "./server/main.coffee"
app = express()
router = express.Router()
bodyParser = require "body-parser"
morgan = require "morgan"

app.use(morgan("dev"))
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

app.set('views', __dirname+'/server/views')
app.set('view engine', 'pug')
app.use('/', express.static(__dirname+"/bower_components"))
app.use "/", router
main(router)

port = process.env.PORT || 3000
app.listen port, ->
	console.log "Connected to Port "+ port
	return