require 'opal'
require 'opal-parser'
require 'browser'
require 'lissio'

require '_vendor/jquery'
require '_vendor/bootstrap'
require 'opal-jquery'

require '_vendor/codemirror'
require '_vendor/codemirror-html'
require '_vendor/codemirror-css'
require '_vendor/codemirror-ruby'

class CodeLinkHandler

  def initialize(location=`window.location`)
    @location = Native(location)      # inject this so we can test
  end

  def create_link_for_code opal_code, html_code, css_code
    if opal_code
      @location.origin + @location.pathname + "#code:" + `encodeURIComponent(#{opal_code})` + "&html_code=" + `encodeURIComponent(#{html_code})` + "&css_code=" + `encodeURIComponent(#{css_code})`
    else
      nil
    end
  end
  # initialize irb w/link passed in code ala try opal
  def grab_link_code
    link_code = `decodeURIComponent(#{@location.hash})`
    if link_code != ''
      raw_code = link_code[6..-1]
      opal_code, html_code, css_code = raw_code.split(/&(?:html|css)_code=/)
      { opal_code: opal_code,
        html_code: html_code,
        css_code: css_code
      }
    else
      nil
    end
  end

end

module Playground
  class Editor
    OPTIONS = { lineNumbers: true, theme: 'solarized light' }

    def initialize(dom_id, options)
      options = OPTIONS.merge(options).to_n
      @native = `CodeMirror(document.getElementById(dom_id), #{options})`
    end

    def value=(str)
      `#@native.setValue(str)`
    end

    def value
      `#@native.getValue()`
    end
  end

  class Runner
    def initialize
      @html = create_editor(:html_pane, mode: 'xml')
      @ruby = create_editor(:ruby_pane, mode: 'ruby')
      @css  = create_editor(:css_pane, mode: 'css')
      @result = Element['#result-frame']
      @code_link_hander = CodeLinkHandler.new

      @html.value = HTML
      @ruby.value = RUBY
      @css.value = CSS

      Element.find('#run-code').on(:click) { run_code }
      Element.find('#create-link').on(:click) { create_link}
      load_link_code_if_needed
      run_code
    end

    def load_link_code_if_needed
      code_hash = @code_link_hander.grab_link_code
      if code_hash
        @html.value = code_hash[:html_code]
        @ruby.value = code_hash[:opal_code]
        @css.value = code_hash[:css_code]
      end
    end

    def create_editor(id, opts)
      opts = { lineNumbers: true,
               theme: 'solarized light',
               extraKeys: {
                 'Cmd-Enter' => proc { run_code },
                 'Cmd-S' => proc { create_link}
               }
      }.merge(opts)

      Editor.new(id, opts)
    end

    def run_code
      html, css, ruby = @html.value, @css.value, @ruby.value
      javascript = Opal.compile ruby

      update_iframe(<<-HTML)
        <html>
          <head>
            <style>#{css}</style>
          </head>
          <body>
            #{html}
            <script src="javascripts/result_boot.js"></script>
            <script>
              #{javascript}
            </script>
          </body>
        </html>
      HTML
    end

    def update_iframe(html)
      %x{
        var iframe = #@result[0], doc;

        if (iframe.contentDocument) {
          doc = iframe.contentDocument;
        } else if (iframe.contentWindow) {
          doc = iframe.contentWindow.document;
        } else {
          doc = iframe.document;
        }

        doc.open()
        doc.writeln(#{html});
        doc.close();
      }
    end

    def create_link
      opal_code = @ruby.value
      html_code = @html.value
      css_code = @css.value

      Element.id('code-link').value =  @code_link_hander.create_link_for_code(opal_code, html_code, css_code)
    end
  end

  HTML = <<-HTML
<button id="main">
  Click me
</button>
  HTML

  CSS = <<-CSS
body {
  background: #eeeeee;
}
  CSS

  RUBY = <<-RUBY
Document.ready? do
  Element.find('#main').on(:click) do
    alert "Hello, World!"
  end
end
  RUBY
end

Document.ready? do
  Playground::Runner.new
end
