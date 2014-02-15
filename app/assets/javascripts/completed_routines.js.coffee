jQuery ->
  $('#completed_routine_category_name').autocomplete
    source: $('#completed_routine_category_name').data('autocomplete-source')
