//= require jquery.tagEditor

$(function(){
  $(':input[name*=tag_string]').tagEditor();
  var $form = $('form');
  var setting = window[$form.attr('id')];
  $(':input[name*=tag_string][data-validate]').change(function(){
    $(this).isValid(setting.validators);
  });
})
