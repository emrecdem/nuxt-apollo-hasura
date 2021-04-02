const express = require('express')
const fileUpload = require('express-fileupload')
const app = express()
const port = 7000

// default options
app.use(fileUpload())

app.post('/upload', function (req, res) {
  if (!req.files || Object.keys(req.files).length === 0) {
    return res.status(400).send('No files were uploaded.')
  }

  const files = req.files
  console.log('🎹', Object.values(files))
  try {
    // Use the mv() method to place the file somewhere on your server
    Object.values(files).map((file) => {
      const uploadPath = __dirname + '/cwl_files/' + file.name
      file.mv(uploadPath)
    })
  } catch (err) {
    return res.status(500).send(err)
  } finally {
    res.send('Files uploaded!')
  }
})

app.listen(port, () => {
  console.log(`Upload server listening at http://localhost:${port}/upload`)
})
