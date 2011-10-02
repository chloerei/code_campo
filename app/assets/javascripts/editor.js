//= require wmd
//= require showdown
//= require jquery.tagEditor

$(function(){
  new WMDEditor({
    input: "editor-input",
    button_bar: "editor-button-bar",
    preview: "editor-preview"
  });

  $('#editor :input[name*=tag_string]').tagEditor();

  var $form = $('#editor form[data-validate]');
  if ($form.length > 0) {
    var setting = window[$form.attr('id')];
    $('#editor :input[name*=tag_string][data-validate]').change(function(){
      $(this).isValid(setting.validators);
    });
  };
})
