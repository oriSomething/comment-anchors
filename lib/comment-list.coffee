
# all lowercase

matches =
  # //// (title)
  'forwardSlash':                 /^\s*\/{4}(.+)/
  # #### (title)
  'hash':                         /^\s*#{4}(.+)/
  #  <!---- (title) ---->
  'htmlStyle':                    /^\s*<!-{4}(.+)-{4}>/
  # /**** (title) ****/
  'cssStyle':                     /^\s*\/\*{4}(.+)\*{4}\//
  # //// (title) OR /**** (title) ****/
  'cssStyleOrForwardSlash':       /^\s*\/\*{4}(.+)\*{4}\/|^\s*\/{4}(.+)/
  # //// (title) OR /**** (title) ****/ OR ####
  'cssStyleOrForwardSlashOrHash': /^\s*\/\*{4}(.+)\*{4}\/|^\s*\/{4}(.+)|^\s*#{4}(.+)/

module.exports =
list:
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
