const express = require('express')
const app = express()
const bodyParser = require('body-parser')
const port = 8080

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
app.use('*', (req, res, next) => {
 console.log(`${req.method} request to ${req.originalUrl}`)
 next()
})
app.use(express.static('dist'))

app.listen(port, '0.0.0.0', (req, res) => {
 console.log(`Server listening on localhost:${port}`)
})
