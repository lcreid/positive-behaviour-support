#This Source Code Form is subject to the terms of the Mozilla Public
#License, v. 2.0. If a copy of the MPL was not distributed with this
#file, You can obtain one at http://mozilla.org/MPL/2.0/.
#Copyright (c) Jade Systems Inc. 2013, 2014

#From http://railscasts.com/episodes/196-nested-model-form-revised

# Turbolinks issue. See: http://stackoverflow.com/questions/20252530/coffeescript-jquery-on-click-only-working-when-page-is-refreshed
# http://stackoverflow.com/questions/18770517/rails-4-how-to-use-document-ready-with-turbo-links
ready = ->
# End part 1 Turbolinks

jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    console.log("A")
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    console.log("B")
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

# Part two Turbolinks
$(document).ready(ready)
$(document).on('page:load', ready)
# End Turbolinks issue

