;RAI.Components['settlement/form'] = Backbone.View.extend({

  initialize: function(){
    var $selectInputs = this.$el.find('select')
    $selectInputs.selectize()

    new RAI.Components['pictures/list']({
      el: $('.pictures-list')
    })
  }

})
