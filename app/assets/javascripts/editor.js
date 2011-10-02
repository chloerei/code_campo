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
})
