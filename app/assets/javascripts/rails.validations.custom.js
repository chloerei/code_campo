clientSideValidations.validators.local['confirmation'] = function (element, options) {
  var confirmation = jQuery('#' + element.attr('id') + '_confirmation');
  if (confirmation.val() !== '' && element.val() !== confirmation.val()) {
    return options.message;
  }
}

clientSideValidations.validators.local['tag_string'] = function(element, options) {
  if ($.unique(element.val().split(/[,\s]+/).filter(function(tag){return tag !== "";})).length > options.limit) {
    return options.message;
  }
}

clientSideValidations.validators.local['current_password'] = function(element, options) {
  var $form = element.parents('form');
  if (element.val() === '') {
    var need_current_password = false;
    $.each(options.fields, function(key, value) {
      var field_input = $form.find('[id*=_' + key + ']');
      if (field_input.length !== 0 && field_input.val() !== value) {
        need_current_password = true;
      }
    });
    element.data('changed', true); // always check
    if (need_current_password) { return options.message; }
  }
}

$(function(){
  $('form[data-validate]').each(function(){
    $(this).find('[id*=_confirmation]').each(function(){
      $('#' + this.id).die('keyup');
    });
  });
});
