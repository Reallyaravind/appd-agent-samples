const express = require('express');

// Constants
const PORT = 3000;

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello From Node App!!!...');
});

app.listen(PORT, () => {
  console.log(`Running on ${PORT}`);
});