(function( $ ){
  var Editor = function(input) {
    this._input = $(input);
    this.tag_editor = $('<div class="tag-editor"></div>');
    this.tag_preview = $('<span class="tag-preview"></span>');
    this.tag_input = $('<input class="tag-input" type="text"></input>');
    this.tag_editor.append(this.tag_preview).append(this.tag_input);
    this.tag_editor.insertBefore(this._input);
    this._input.hide();

    this.tags = $.unique(this._input.val().split(/[,\s]+/).filter(function(tag){return tag !== ""}));
    this.draw_preview();

    var that = this;

    this.tag_editor.click(function(event){
      that.focus_input();
    });
    
    this.tag_input.keyup(function(event){
      that.keyup_handle(event);
    });

    this.tag_input.keydown(function(event){
      that.keydown_handle(event);
    });
  }

  Editor.prototype = {
    focus_input: function() {
      this.tag_input.focus();
    },

    keyup_handle: function(event) {
      if (event.which === 188 || event.which === 32) {
        var tag_string = this.tag_input.val();
        var new_tags = tag_string.split(/[,\s]+/).filter(function(tag){return tag !== ""});
        if (new_tags.length > 0) {
          var that = this;
          this.tag_input.val('');
          this.tags = $.merge(this.tags, new_tags.filter(function(tag){ return that.tags.indexOf(tag) === -1; }));
          this.draw_preview();
          this.update_input();
        }
      }
    },

    keydown_handle: function(event) {
      if (event.which == 8){
        if (this.tag_input.val() === '' && this.tags.length !== 0) {
          this.tag_input.val(this.tags.pop());
          this.draw_preview();
          this.update_input();
          event.preventDefault();
        }
      }
    },
    
    draw_preview: function() {
      this.tag_preview.html('');
      var that = this;
      $.each(this.tags, function(){
        that.tag_preview.append('<span>' + this + '</span>');
      });
    },

    update_input: function() {
      this._input.val(this.tags.join(', '));
    }
  }

  $.fn.tagEditor = function() {
    return this.each(function() {
      new Editor(this);
    });
  };
})( jQuery );
