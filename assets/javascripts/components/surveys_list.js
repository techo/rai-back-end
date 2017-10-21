;RAI.Components['surveys/list'] = Backbone.View.extend({
  events:{
    'click .remove-survey-form .delete-button': 'removeSurvey'
  },

  initialize: function(){
    this.$form = this.$el.find('form.remove-survey-form')
  },

  removeSurvey: function(evt){
    if( !confirm("¿Estás seguro/a de eliminar esta encuesta?") ){
      evt.preventDefault()
    } else {
      this.$form.submit()
    }
  }

})
