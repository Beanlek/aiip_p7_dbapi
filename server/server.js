const cors = require('cors');
const express = require('express');
// const http = require('http');
const app = express();

const insertImageRouter = require('./insertImage');
const getUserDetailsRouter = require('./getUserDetails');

const PORT = process.env.PORT || 8080;

var corsOptions = {
    origin: `http://localhost:8081`
};

app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({extended: true}));

app.use('/insert', insertImageRouter);
app.use('/get_user_details', getUserDetailsRouter);

app.get('/', (req, res) => {
    res.json({
        message: 'Welcome to AIIP 7th prototype.'
    });
});

app.listen(PORT, ()=>{
    console.log(`Port ${PORT} is running on localhost.`)
});