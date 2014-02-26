#This Source Code Form is subject to the terms of the Mozilla Public
#License, v. 2.0. If a copy of the MPL was not distributed with this
#file, You can obtain one at http://mozilla.org/MPL/2.0/.
#Copyright (c) Jade Systems Inc. 2013, 2014

# Turbolinks issue. See: http://stackoverflow.com/questions/20252530/coffeescript-jquery-on-click-only-working-when-page-is-refreshed
# http://stackoverflow.com/questions/18770517/rails-4-how-to-use-document-ready-with-turbo-links
ready = ->
# End part 1 Turbolinks

  $('#completed_routine_category_name').autocomplete
    source: $('#completed_routine_category_name').data('autocomplete-source')

# Part two Turbolinks
$(document).ready(ready)
$(document).on('page:load', ready)
# End Turbolinks issue

