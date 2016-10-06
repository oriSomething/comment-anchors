
# all lowercase
regexps =
  'mark':         '(^\\s*\\/{2} MARK: )(.+)'
  'forwardSlash': '(^\\s*\\/{4} )(.+)'
  'hash':         '(^\\s*#### )(.+)'
  'htmlStyle':    '(^\\s*<!-{4} )(.+) -{4}>'
  'cssStyle':     '(^\\s*\\/\\*{4} )(.+) \\*{4}\\/'

matches =
  # //// (title)
  'forwardSlash': [new RegExp(regexps.forwardSlash)]
  # #### (title)
  'hash': [new RegExp(regexps.hash)]
  #  <!---- (title) ---->
  'htmlStyle': [new RegExp(regexps.htmlStyle)]
  # /**** (title) ****/
  'cssStyle': [new RegExp(regexps.cssStyle)]
  # /**** (title) ****/ OR //// (title)
  'cssStyleOrForwardSlash': [
      new RegExp(regexps.cssStyle),
      new RegExp(regexps.forwardSlash)
    ]
  # //// (title) OR /**** (title) ****/ OR ####
  'cssStyleOrForwardSlashOrHash': [
      new RegExp(regexps.forwardSlash),
      new RegExp(regexps.cssStyle),
      new RegExp(regexps.hash)
    ]
  'all': [
    new RegExp(regexps.forwardSlash),
    new RegExp(regexps.htmlStyle),
    new RegExp(regexps.cssStyle),
    new RegExp(regexps.hash),
    new RegExp(regexps.mark)
  ]
  # default Xcode style // MARK: (title)
  'defaults': [new RegExp(regexps.mark)]

list =
  'defaults':                matches['defaults']

  'javascript':              matches['forwardSlash']
  'javascript':              matches['forwardSlash']
  'javascript (rails)':      matches['forwardSlash']
  'babel es6 javascript':    matches['forwardSlash']
  'objective-c':             matches['forwardSlash']
  'objective-c++':           matches['forwardSlash']
  'c':                       matches['forwardSlash']
  'c#':                      matches['forwardSlash']
  'c# cake file':            matches['forwardSlash']
  'c# script file':          matches['forwardSlash']
  'c++':                     matches['forwardSlash']

  'coffeescript':            matches['hash']
  'coffeescript (literate)': matches['hash']
  'shell script':            matches['hash']
  'ruby':                    matches['hash']
  'ruby on rails':           matches['hash']
  'ruby on rails (rjs)':     matches['hash']
  'python':                  matches['hash']
  'python console':          matches['hash']
  'python traceback':        matches['hash']
  'perl':                    matches['hash']
  'perl 6':                  matches['hash']
  'yaml':                    matches['hash']

  'html':                    matches['htmlStyle']
  'xml':                     matches['htmlStyle']
  'html (go)':               matches['htmlStyle']
  'html (mustache)':         matches['htmlStyle']
  'html (rails)':            matches['htmlStyle']
  'html (ruby - erb)':       matches['htmlStyle']

  'php':                     matches['cssStyleOrForwardSlashOrHash']

  'css':                     matches['cssStyle']
  'sass':                    matches['cssStyleOrForwardSlash']
  'less':                    matches['cssStyleOrForwardSlash']
  'scss':                    matches['cssStyleOrForwardSlash']
  'go':                      matches['cssStyleOrForwardSlash']
  'go template':             matches['cssStyleOrForwardSlash']

module.exports =
  list: list

  getUserRegex: ->
    customRegex = atom.config.get('comment-anchors.customAnchorRegExp')
    result = null
    # get user's custom RegExp
    try
      result = new RegExp(customRegex)
    # if custom regex is invalid
    catch error
      if error instanceof SyntaxError
        console.error('[COMMENT-ANCHORS]:: Check your custom regex!')
        console.error(error)
      else
        console.error(error)

    result

  # get anchor regex
  getRegex: (grammar) ->
    # check if user has specified a RegExp to use
    override = atom.config.get('comment-anchors.alwaysUseSpecifiedRegExp')
    # do we want to use all anchor types?
    useAll = atom.config.get('comment-anchors.allAnchors')

    if useAll and not override
      result = matches.all
      if userRegex = @getUserRegex()
        result.push userRegex
      return result

    # if user has set a custom RegExp, or no RegExp found in our list
    if override or not list[grammar]
      if userRegex = @getUserRegex()
        result = [userRegex]
    else
      result = list[grammar]

    # if not set default to Xcode `// MARK: ` style if error
    result ?= list.defaults

    result
