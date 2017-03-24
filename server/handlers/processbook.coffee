mongoose = require "mongoose" 
Schema = mongoose.Schema;
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

dbUrl = "mongodb://localhost:27017/demodb";
dbConnection = mongoose.createConnection(dbUrl, () ->
    console.log("Successfully connected to database")
)

bookSchema = new Schema schemaObject
Books = dbConnection.model "books",bookSchema
module.exports = 
    addbook: (req, res, next) ->
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
    viewbook: (req, res, next) ->
        Books.find({},(error,result,next) =>				
            if error
                next(error)
            else
                obj =
                    flag: 1
                    data: result
                
                res.render "viewbook", obj
        )
    remove: (req, res, next) ->
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
