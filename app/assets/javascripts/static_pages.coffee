# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  # Clear errors and inputs after closing signup form
  $("#signupModal").on "hidden.bs.modal", ->
    $("#errors").html('')
    $("#user_email").val('')
    $("#user_name").val('')
    $("#user_password").val('')
    $("#user_password_confirmation").val('')

  # Display proper content due to number of done/todo tasks
  done = $("#done_count").text()
  todo = $("#todo_count").text()

  if todo is '0'
    $("#todo-tasks").hide()
    $("#no-tasks").show()
  else
    $("#todo-tasks").show()
    $("#no-tasks").hide()

  if done is '0'
    $("#done-tasks").hide()
  else
    $("#done-tasks").show()
