(function( $ ){
  var Editor = function(input) {
    this._input = $(input);
    this.tag_editor = $('<div class="tag-editor"></div>');
    this.tag_preview = $('<span class="tag-preview"></span>');
    this.tag_input = $('<input class="tag-input" type="text"></input>');
    this.tag_editor.append(this.tag_preview).append(this.tag_input);
    this.tag_editor.insertBefore(this._input);
    this._input.hide();

    this.tags = this._input.val().split(/[,\s]+/).filter(function(tag){return tag !== ""});
    this.draw_preview();

    this.typeahead();
    this.lisent();
  }

  Editor.prototype = {
    typeahead: function() {
      this.tag_input.typeahead({source: this._input.data('suggest'), items: 5});
      var typeahead = this.tag_input.data('typeahead');
      var original_select = typeahead.select;

      var that = this;
      typeahead.select = function () {
        original_select.call(this);
        that.extract_tags();
      }
    },

    lisent: function() {
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

      this.tag_input.focus(function(event){
        that.tag_editor.addClass('focus');
      });

      this.tag_input.focusout(function(event){
        //that.extract_tags();
        that.tag_editor.removeClass('focus');
      });

      this._input.parents('form').submit(function(event){
        that.extract_tags();
      });
    },

    focus_input: function() {
      this.tag_input.focus();
    },

    keyup_handle: function(event) {
      if (event.which === 188 || event.which === 32) {
        if (/[,\s]$/.test(this.tag_input.val())) {
          this.extract_tags();
        }
      }
    },

    extract_tags: function() {
      var tag_string = this.tag_input.val();
      var new_tags = tag_string.split(/[,\s]+/).filter(function(tag){return tag !== ""});
      if (new_tags.length > 0) {
        var that = this;
        this.tag_input.val('');
        this.tags = $.merge(this.tags, new_tags.filter(function(tag){ return that.tags.indexOf(tag) === -1; }));
        this.draw_preview();
        this.update_input();
      }
    },

    keydown_handle: function(event) {
      if (event.which == 8){
        if (this.tag_input.val() === '' && this.tags.length !== 0) {
          event.preventDefault();
          this.tag_input.val(this.tags.pop());
          this.draw_preview();
          this.update_input();
        }
      }
    },
    
    draw_preview: function() {
      this.tag_preview.html('');
      var that = this;
      $.each(this.tags, function(){
        var tag_element = $('<span class="tag"><span class="content">' + this + '</span><span class="delete">x</span></span>');
        tag_element.find('span.delete').click(function(){
          that.delete_tag($(this).siblings('.content').text());
        });
        that.tag_preview.append(tag_element);
      });
    },

    update_input: function() {
      this._input.val(this.tags.join(', ')).change();
    },

    delete_tag: function(delete_tag) {
      this.tags = this.tags.filter(function(tag){ return tag !== delete_tag });
      this.draw_preview();
      this.update_input();
    }
  }

  $.fn.tagEditor = function() {
    return this.each(function() {
      new Editor(this);
    });
  };
})( jQuery );
