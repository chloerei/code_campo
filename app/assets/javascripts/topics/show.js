$(function(){
  $('#new_reply').live('ajax:success', function() {
    $(this).find('textarea').val('');
    $(this).find('#editor-preview').text('');
  }).live('ajax:error', function(event, xhr, status) {
    var message = $('<div class="alert-message error fade in"><a href="#" class="close">×</a><p></p></div>').alert();
    message.find('p').text(xhr.responseText);
    message.hide().prependTo($(this)).fadeIn('fast');
  });
})
