const express = require('express');
const dotenv = require('dotenv');
const morgan = require('morgan');
const formidable = require('express-formidable');
// const db = require('./config/firebase');


// Load env variables from .env file
dotenv.config({
    path: './config/config.env'
});

// Connect to database


// Using express
const app = express();

// //Body Parser 
app.use(formidable())

// Morgan for logging

if(process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'));
}

app.use("/", require('./routes/index'));


// PORT and listening 
const PORT = process.env.PORT || 5000;
app.listen(PORT, ()=>{
    console.log(`Server is running at ${process.env.NODE_ENV} mode on port ${PORT}`);
}) 