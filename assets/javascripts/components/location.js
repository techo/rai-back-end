;RAI.Components['location/form'] = Backbone.View.extend({

  initialize: function(){
    var $selectInputs = this.$el.find('select')
    $selectInputs.selectize()
  }

})
