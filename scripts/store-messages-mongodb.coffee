# Description:
#   None
#
# Dependencies:
#   "mongoose": "3.0.2"
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   thogg4

mongoose = require "mongoose"
db = mongoose.createConnection('localhost', 'message-log')
schema = mongoose.Schema({
  message: String,
  author: String,
  date: Date,
  important: Boolean
})
Message = db.model('Message', schema)
module.exports = (robot) ->
  robot.hear /.*$/i, (msg) ->

    message = msg.message
    message.date = new Date

    # ignore topic and other messages
    return if typeof message.user.id == 'undefined'

    m = new Message({
      message: message.text,
      date: message.date,
      author: message.user.name
    })

    if message.text.match(/^!.*/)
      m.important = true
      m.message = message.text.replace('!', '')


    m.save (err) ->
      if err
        msg.reply 'I have stopped logging messages. Please fix me.'

