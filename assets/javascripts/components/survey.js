;RAI.Components['survey/form'] = Backbone.View.extend({
  events:{
    "keyup .poligon-text": "autoGrow",
  },

  initialize: function(){
    var $selectInputs = this.$el.find('select')
    $selectInputs.selectize()
    var $poligonTextArea = this.$el.find('textarea.poligon-text')
    this.autoGrow({currentTarget: $poligonTextArea.get()[0] })
  },

  autoGrow: function(evt) {
    var element = evt.currentTarget
    element.style.height = "80px"
    element.style.height = (element.scrollHeight + 10)+"px"
  }

})
