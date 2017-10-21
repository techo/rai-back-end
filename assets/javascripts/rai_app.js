;(function(){
  var root = this

  root.$window = $(window)
  root.$document = $(document)
  root.$body = $('body')
  root.$html = $('html')

  var RAI = root.RAI = root.RAI || {}
  _.extend(RAI, {
    Components: {},
    Helpers: {},
    pubSub: Backbone.Events,
    Views: {}
  })

  // Send token on every ajax call that is not GET
  RAI.CSRFtoken = $('meta[name="csrf-token"]').attr('content')
  if( typeof RAI.CSRFtoken !== 'string' || !RAI.CSRFtoken.length ) {
    RAI.CSRFtoken = null
  } else {
    $.ajaxPrefilter(function(options, originalOptions, jqXHR) {
      if( RAI.Helpers.url.isSameDomain(options.url) ) {
        jqXHR.setRequestHeader('X-CSRF-Token', RAI.CSRFtoken)
      }
    })
  }
})();
