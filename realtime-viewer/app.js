const app = require('express')();
var http = require('http').createServer(app);
const io = require('socket.io')(http);
const path = require('path');

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const nginxAccessSchema = new Schema({
  request: { type: String },
  timestamp: { type: Number },
  status: { type: String },
});

var nginxAccessModel = mongoose.model('NginxAccess', nginxAccessSchema);

mongoose.connect(process.env.MONGODB_URI);

const db = mongoose.connection;

db.on('error', console.error.bind(console, 'Connection Error:'));

db.once('open', () => {
  db.createCollection(process.env.MONGODB_COLLECTION, function (_err) {
    if (_err) {
      console.error(_err)
      process.exit(1)
    }
    const taskCollection = db.collection(process.env.MONGODB_COLLECTION);
    const changeStream = taskCollection.watch();

    changeStream.on('change', (change) => {
      if (change.operationType === 'insert') {
        const task = change.fullDocument;
        io.emit('inserted', {
          id: task._id,
          request: task.request,
          timestamp: task.timestamp,
          status: task.status,
        })
      }
    });
  });
});

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.get('/', function (req, res) {
  res.render('index');
})

http.listen(3000)