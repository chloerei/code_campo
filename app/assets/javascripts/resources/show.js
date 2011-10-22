$(function(){
  var $new_comment_form = $('#new_comment');

  $('.reply a').live('click', function(event){
    var $comment = $(this).parents('.comment');
    var parent_id = $comment.data('comment-id');
    var form_id = 'new_comment_' + parent_id;
    if (!$('#' + form_id).length) {
      var form = $new_comment_form.clone();
      form.find('.alert-message').remove();
      form.attr('id', form_id).attr('action', $new_comment_form.attr('action') + '&parent_id=' + parent_id);
      var cancel_link = $('<a href="#" class="btn">Cancel</a>');
      cancel_link.click(function(event) {
        form.fadeOut('fast', function(){$(this).remove()});
        event.preventDefault();
      });
      form.find(':submit').after(cancel_link);
      form.hide().appendTo($comment).fadeIn('fast', function(){form.find('textarea').focus();});
    }
    event.preventDefault();
  });

  $('#comments form.new_comment').live('ajax:success', function() {
    $(this).hide().remove();
  });

  $('#new_comment').live('ajax:success', function() {
    $(this).find('textarea').val('');
  });

  $('form.new_comment').live('ajax:error', function(event, xhr, status) {
    var message = $('<div class="alert-message error fade in"><a href="#" class="close">×</a><p></p></div>').alert();
    message.find('p').text(xhr.responseText);
    message.hide().prependTo($(this)).fadeIn('fast');
  });
})
