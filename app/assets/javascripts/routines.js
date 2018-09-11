// From http : //railscasts.com/episodes/196-nested-model-form-revised
$(document).on('turbolinks:load', function() {
  // console.log('loading')
  $('form').on('click', '.remove_fields', null, function(event) {
    console.log("A");
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
    event.preventDefault();
  });

  $('form').on('click', '.add_fields', null, function(event) {
    console.log("B");
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
  });
});
