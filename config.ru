require File.expand_path('../config/application', __FILE__)

map('/api/v1/') { run Rai::Api::V1 }
map('/download/') { run Rai::Download }
map('/') { run Rai::Editor }