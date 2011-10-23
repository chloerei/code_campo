$(function(){
  $('[data-remote]').live('ajax:before', function() {
    var $loader = $('#remote-loader');
    if (!$loader.length) {
      $loader = $('<div id="remote-loader"></div>').hide().prependTo($('body'));
    }
    $loader.html('<span class="label warning">Loading...</span>');
    $loader.fadeIn();
  }).live('ajax:success', function() {
    var $loader = $('#remote-loader');
    $loader.html('<span class="label success">Done</span>');
    setTimeout(function() {
      $loader.fadeOut(function(){
        $(this).remove();
      });
    }, 1000);
  }).live('ajax:error', function() {
    var $loader = $('#remote-loader');
    var $error = $('<span class="label important">Error</span>');
    $loader.html($error);
    $error.click(function() {
      $loader.fadeOut(function(){
        $(this).remove();
      });
    });
  });
})
