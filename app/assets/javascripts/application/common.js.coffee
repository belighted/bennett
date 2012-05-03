$ ->
  $('.alert-message a').click (e) ->
    e.preventDefault()
    $(e.target).closest('.alert-message').hide()