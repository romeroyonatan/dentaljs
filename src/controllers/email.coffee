email = require '../utils/email'

module.exports =

  # send_current_account
  # -------------------------------------------------------------------------
  # Send a email to person indicating their checking account
  send_current_account: (req, res, next) ->
    email.send_current_account req.params.person_id, (err) ->
      return next err if err
      res.send 'The e-mail has been sent successfully'
