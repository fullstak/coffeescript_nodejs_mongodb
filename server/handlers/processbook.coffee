mongoose = require "mongoose" 
Schema = mongoose.Schema

schemaObject = 
    booktitle: 
        type:String,
        required: true,
        trim: true
    bookqty: 
        type:String,
        required: true,
        trim: true
    bookaurthor: 
        type:String,
        required: true,
        trim: true
    updatedAt: 
        type: Date
        default: Date.now

isDbConnected = false
dbUrl = "mongodb://localhost:27017/demodb";
dbConnection = mongoose.createConnection(dbUrl)
dbConnection.on('error',() ->
  console.log('Error! Database connection failed.');
)
dbConnection.once('open', (argument) ->
    isDbConnected = false
    console.log('Database connection established!');
)
checkDBConnection = ()->
    return isDbConnected
bookSchema = new Schema schemaObject
Books = dbConnection.model "books",bookSchema
module.exports = 
    addbook: (req, res, next) ->
        if checkDBConnection()
            postBook = new Books(req.body)
            postBook.save((error,result) ->
                if error
                    obj =
                        flag: 2
                        msg: error.message
                    res.send obj
                else
                    obj =
                        flag: 1
                    res.redirect("viewbook")
            )
        else
            obj =
                flag: 2
                msg: 'Mongo DB not installed or running !!!'
            res.send obj
        
    viewbook: (req, res, next) ->
        if checkDBConnection()
            Books.find({},(error,result,next) =>				
                if error
                    next(error)
                else
                    obj =
                        flag: 1
                        data: result
                    
                    res.render "viewbook", obj
            )
        else
            obj =
                flag: 2
                msg: 'Mongo DB not installed or running !!!'
            res.send obj
    remove: (req, res, next) ->
        if checkDBConnection()
            Books.findOneAndRemove({'_id': req.params.id},(error,result,next) =>
                console.log result				
                if error
                    next(error)
                else
                    obj =
                        flag: 1
                        data: result
                    
                    res.redirect("/viewbook")
            )
        else
            obj =
                flag: 2
                msg: 'Mongo DB not installed or running !!!'
            res.send obj 
