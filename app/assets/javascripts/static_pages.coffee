# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  # Clear errors and inputs after closing signup form
  $("#signupModal").on "hidden.bs.modal", ->
    $('.form-group').each ->
      $(@).removeClass('has-error')
      $(@).find('span').hide()
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

  # Button for sending activations email
  if $('.alert-warning').length
    $('#activation-btn').show()
  
  $('.edit_user #user_email').click ->
    alert("It is needed to activate your account again after changing email address!")
  

  # Active 'Add' button when input is not nil
  $('textarea').bind 'input propertychange', ->
    $('#add_new').removeClass('disabled')
    if !$(@).val().length
      $('#add_new').addClass('disabled')

  $('#add_new').mouseup ->
    $(@).addClass('disabled')

  # $('body').on 'click','input.disabled', (event) ->
  #   event.preventDefault()

  # Detects changes in DOM
  $(document).on "DOMSubtreeModified", ->
    # Cancel edit task
    task_form = $('[id^="edit_task_"]')
    task_content = task_form.find('#task_content')
    default_text = task_content.val()
    task_content.keyup (e) ->
      if e.keyCode == 27
        console.log 'esc'
        task_form.closest('.content').html(default_text)
        task_form.hide()
    