const express = require("express")
const body_parser = require("body-parser")
const cors = require("cors")
const axios = require("axios")

let app = express()
const port = 3000

app.use(body_parser.json())
app.use(cors())

app.get('/', (req, res) => {
    res.send('testing api')
})

app.get('/', (req, res) => {
    res.send('ini text kedua')
})

app.get('/testing', async (req, res) =>{
    const osm = await axios.get('https://pokeapi.co/api/v2/pokemon/ditto')
    res.send(JSON.stringify(osm.data))
})

app.post('/data', (req, res) => {
    const { message } = req.body;
    res.json({ response: `Received: ${message}`})
})

app.listen(port, () => {
    console.log(`Server jalan di http://localhost:${port}`);
})




