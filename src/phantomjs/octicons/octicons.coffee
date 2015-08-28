args = require('system').args
fs   = require('fs')
page = require('webpage').create()

if args.length > 1
  puts = (content) -> fs.write args[1], content, 'w'
else
  puts = (content) -> console.log content

page.open "src/phantomjs/octicons/index.html", ->
  puts page.evaluate (svgs) ->
    styleSheets = Array::filter.call document.styleSheets, (styleSheet) ->
      styleSheet.href?.match /\/octicons\.css$/
    Array::filter.call styleSheets[0].cssRules, (cssRule) ->
      cssRule.selectorText?.match /^\.octicon-[\w-]+?::before(?:\s*,\s*\.octicon-[\w-]+?::before)*$/
    .map (cssRule) ->
      selectorText = cssRule.selectorText.replace /::before/g, ""
      document = new DOMParser().parseFromString svgs[className], "text/xml" for className in selectorText.split ", " when className of svgs
      height = Math.round document.documentElement.getAttribute "height"
      width = Math.round document.documentElement.getAttribute "width"

      "#{selectorText} { width: unit(( #{width} / #{height} ), em); }"
    .join "\n"
  , do ->
    octicons = "components/octicons/svg"
    svgs = {}
    svgs[".octicon-#{svg.replace /\.svg$/i, ""}"] = fs.read "#{octicons}/#{svg}" for svg in fs.list octicons when svg.match /\.svg$/i
    svgs
  phantom.exit()
