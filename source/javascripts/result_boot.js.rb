require 'opal'
require '_vendor/jquery'
require '_vendor/jquery-ui.min'
require 'opal-jquery'
require 'browser'
require 'lissio'

require 'opal_irb_jqconsole'

require '_vendor/codemirror'
require '_vendor/codemirror-html'
require '_vendor/codemirror-css'
require '_vendor/codemirror-ruby'
require '_vendor/codemirror-emacs'

Document.ready? do
  OpalIrbJqconsole.create_bottom_panel
end
