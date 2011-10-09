//= require jquery.tagEditor

$(function(){
  $(':input[name*=tag_string]').tagEditor();
  var $form = $('form');
  var setting = window[$form.attr('id')];
  $(':input[name*=tag_string][data-validate]').change(function(){
    $(this).isValid(setting.validators);
  });

  $('.tags span.delete').live('click', function(){
    var tag = $(this).siblings('.content').text();
    var that = $(this);
    $.ajax({
      url: '/settings/favorite_tags/' + tag,
      type: 'DELETE', dataType: 'script'
    }).success(function(){
      that.parent().fadeOut('fast', function(){$(this).remove()});
    });
  });
})
