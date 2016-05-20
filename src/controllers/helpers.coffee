fs = require 'fs'

module.exports =
  # rmdir
  # ======
  # Remove dir and files recursevely
  rmdir: (path, cb) ->
    fs.readdir path, (err, files) ->
      # Callback with error
      return cb err if err
      if files.length > 0
        for file in files
          filepath = path + "/" + file
          if fs.statSync(filepath).isFile()
            fs.unlinkSync filepath
          else
            rmdir filepath
      fs.rmdirSync path
      # callback
      cb()
