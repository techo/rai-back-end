;RAI.Components['pictures/list'] = Backbone.View.extend({
  events:{
    'click .add-picture-btn':    'addPicture',
    'click .remove-picture-btn': 'removePicture'
  },

  initialize: function(){
    var $template = this.$el.find('.picture-template')

    this.$actions = this.$el.find('.actions')
    this.template = _.template($template.html())

    $template.remove()
  },

  addPicture: function(evt){
    this.$actions.before( this.template() )
  },

  removePicture: function(evt){
    var $self = $(evt.currentTarget)
    var $picture = $self.closest('.picture')
    $picture.remove()
  },

})
