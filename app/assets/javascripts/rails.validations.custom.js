clientSideValidations.validators.local['confirmation'] = function (element, options) {
  var confirmation = jQuery('#' + element.attr('id') + '_confirmation');
  if (confirmation.val() !== '' && element.val() !== confirmation.val()) {
    return options.message;
  }
}

$(function(){
  $('form[data-validate]').each(function(){
    $(this).find('[id*=_confirmation]').each(function(){
      $('#' + this.id).die('keyup');
    });
  });
});
