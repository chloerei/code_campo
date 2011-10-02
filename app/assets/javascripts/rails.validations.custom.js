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

$(function(){
  $('form[data-validate]').each(function(){
    $(this).find('[id*=_confirmation]').each(function(){
      $('#' + this.id).die('keyup');
    });
  });
});
