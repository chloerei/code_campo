window.ClientSideValidations.validators.local['confirmation'] = function (element, options) {
  var confirmation = jQuery('#' + element.attr('id') + '_confirmation');
  if (confirmation.val() !== '' && element.val() !== confirmation.val()) {
    return options.message;
  }
}
window.ClientSideValidations.validators.local['tag_string'] = function(element, options) {
  if ($.unique(element.val().split(/[,\s]+/).filter(function(tag){return tag !== "";})).length > options.limit) {
    return options.message;
  }
}

window.ClientSideValidations.validators.local['current_password'] = function(element, options) {
  var $form = element.parents('form');
  if (element.val() === '') {
    var need_current_password = false;
    $.each(options.fields, function(key, value) {
      var field_input = $form.find('[name*="[' + key + ']"]');
      if (field_input.length !== 0 && field_input.val() !== value) {
        need_current_password = true;
      }
    });
    element.data('changed', true); // always check
    if (need_current_password) { return options.message; }
  }
}

window.ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'] = {
  add: function(element, settings, message) {
    if (element.data('valid') !== false && jQuery('label.message[for="' + element.attr('id') + '"]')[0] == undefined) {
      var error_label = jQuery('<label class="message"></label>').attr('for', element.attr('id'));

      if (element.attr('autofocus')) { element.attr('autofocus', false) };
      element.after(error_label);
    }
    jQuery('label.message[for="' + element.attr('id') + '"]').text(message);
  },
  remove: function(element, settings) {
    jQuery('label[for="' + element.attr('id') + '"].message').remove();
  }
}

$(function(){
  $('form[data-validate]').each(function(){
    $(this).find('[id*=_confirmation]').each(function(){
      $('#' + this.id).die('keyup');
    });
  });
});
