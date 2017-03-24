processbook = require "../handlers/processbook" 
module.exports = (route) ->
	route.use (req, res, next) -> 
		console.log('Time:', Date.now());
		next();

	route.get "/", (req, res) ->
        res.render('index', { title: 'Library Application'})

	route.get "/addbook", (req, res) ->
        res.render('addbook', { title: 'Add Book'})
		
	route.post "/addbook", processbook.addbook

	route.get "/viewbook", processbook.viewbook 
	route.get "/remove/:id", processbook.remove