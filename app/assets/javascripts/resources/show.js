$(function(){
  var $new_comment_form = $('#new_comment');

  $('.reply a').click(function(event){
    var $comment = $(this).parents('.comment');
    var parent_id = $comment.data('comment-id');
    var form_id = 'new_comment_' + parent_id;
    if (!$('#' + form_id).length) {
      var form = $new_comment_form.clone();
      form.attr('id', form_id).attr('action', $new_comment_form.attr('action') + '&parent_id=' + parent_id);
      var cancel_link = $('<a href="#" class="btn">Cancel</a>');
      cancel_link.click(function(event) {
        form.slideUp('fast', function(){$(this).remove()});
        event.preventDefault();
      });
      form.find(':submit').after(cancel_link);
      form.hide().appendTo($comment).slideDown('fast', function(){form.find('textarea').focus();});
    }
    event.preventDefault();
  });
})
