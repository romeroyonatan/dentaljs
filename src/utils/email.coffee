# Utils for project
email = require 'emailjs'
pug = require 'pug'
config = require '../config'
Accounting = require '../models/accounting'
Person = require '../models/person'

TEMPLATE_CURRENT_ACCOUNT_TXT = 'views/emails/current_account.txt.jade'
SUBJECT_CURRENT_ACCOUNT_TXT = 'Estado de la cuenta'

module.exports =
  # send_current_account
  # -------------------------------------------------------------------------
  # Send a email to person indicating their checking account
  send_current_account: (person_id, cb) ->
    console.log 'finding person', person_id
    # find accounting for person
    Person.findById person_id, (err, person) ->
      console.error err if err

      # Return if person wasnt found
      if not person?
        console.log "Person", person_id, "not found"
        cb false if cb?
        return false

      # dont send email if person hasnt email
      if person.email
        Accounting.find(person:person)
          .populate('childs')
          .sort(date: -1)
          .exec (err, list) ->
            console.error err if err

            # calculate balance
            balance = 0
            for item in list
              balance += item.assets
              balance -= item.debit

            # generate email from template
            compile = pug.compileFile TEMPLATE_CURRENT_ACCOUNT_TXT
            text = compile
              name: person.first_name
              total: balance
              items: list

            # connect to server
            server = email.server.connect
              host: config.EMAIL_HOST
              user: config.EMAIL_USER
              password: config.EMAIL_PASSWORD
              tls: yes
            console.log 'server', server
            console.log 'Try to send email to', person.email
            # send email
            server.send
              text: text
              from: config.EMAIL_FROM
              to: person.email
              subject: SUBJECT_CURRENT_ACCOUNT_TXT
            , (err, message) ->
              # log error or success message
              console.error err if err
              console.log 'Email sended to', person.email if not err
              console.log message

            # call callback Function
            cb?()
      else
        console.log "Person", person.first_name, person.last_name,
                    "hasnt email"
