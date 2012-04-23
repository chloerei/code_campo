$(function(){
  $('.reply .at').live('click', function(event) {
    var $textarea = $('#new_reply textarea');
    $textarea.focus().val($textarea.val() + '@' + $(this).data('user-name') + ' ');
    event.preventDefault();
  });
})
