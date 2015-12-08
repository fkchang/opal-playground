require 'opal'
require '_vendor/jquery'
require '_vendor/jquery-ui.min'
require 'opal-jquery'
require 'browser'
require 'lissio'
require 'reactive-ruby'
require 'clearwater'
require 'grand_central'
require 'browser/interval'      # gives us wrappers on javascript methods such as setTimer and setInterval
require 'browser/delay'
require 'reactive-router'

require 'opal_irb_jqconsole'

require '_vendor/codemirror'
require '_vendor/codemirror-html'
require '_vendor/codemirror-css'
require '_vendor/codemirror-ruby'
require '_vendor/codemirror-emacs'

# monkey patched because this gets reloaded everytime we run, opal-irb
# gets added as a redirected log output. Going on the assumption that
# we'll only ever add opal-irb.  May change mind w/opal-inspector
class OpalIrbLogRedirector
  def self.add_to_redirect redirector
    initialize_if_necessary
    @redirectors << redirector if @redirectors.size == 0
  end
end

Document.ready? do
  OpalIrbJqconsole.create_bottom_panel(true)
end
