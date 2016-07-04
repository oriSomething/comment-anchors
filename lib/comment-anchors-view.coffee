{SelectListView} = require 'atom-space-pen-views'
{Point} = require 'atom'

#### TODO
# goes to one line after selected...
# add more languages...
# add better error handling...
# add config for custom anchors

CommentRegExpList = require './comment-list.coffee'

module.exports =
class MySelectListView extends SelectListView
  initialize: ->
    super
    @addClass('overlay from-top')
    @setError('No anchors found in file.')

    @setItems(@getItems())

    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.hide()

  getFilterKey: ->
    'text'

  viewForItem: (anchor) ->
    "<li>
      #{anchor.text}
      <div class='pull-right'>
          <kbd class='key-binding pull-right'>line: #{anchor.line}</kbd>
      </div>
    </li>"

  # User selected anchor
  confirmed: (anchor) ->
    @panel.hide();

    editor = atom.workspace.getActiveTextEditor()
    position = new Point(anchor.line, 1)

    editor.setCursorBufferPosition(position)
    editor.moveToFirstCharacterOfLine()
    editor.scrollToBufferPosition(position, center: true)
    @restoreFocus()

# //// hello
#
  getRegex: (grammar) ->
    # check if user has specified a RegExp to use
    override = atom.config.get('comment-anchors.alwaysUseSpecifiedRegExp')
    # if user has set a custom RegExp, or no RegExp found in our list
    if override or not CommentRegExpList.list[grammar]
      custom = atom.config.get('comment-anchors.customAnchorMatch')
      # get user's custom RegExp
      try
        regex = new RegExp(custom)
      # if custom regex is invalid
      catch error
        if error instanceof SyntaxError
          console.error('[COMMENT-ANCHORS]:: Check your custom regex!')
          console.error(error)
        else
          console.error(error)
        # default to JavaScript if error
        regex = CommentRegExpList.list.javascript
    else
      regex = CommentRegExpList.list[grammar]

    return regex

  # scans lines of active text editor for anchored comments
  getItems: ->
    editor = atom.workspace.getActiveTextEditor()
    grammar = editor.getGrammar().name.toLowerCase()
    lines = editor.getLineCount()
    anchors = []

    regex = @getRegex(grammar)

    while lines -= 1
      line = editor.lineTextForBufferRow(lines)
      anchor = regex.exec(line)
      if anchor
        anchors.unshift
          line: lines + 1
          text: anchor[1]

    return anchors


  # used to restore focus to the active text editor after jumping to specific line
  storeFocusedElement: ->
    @previouslyFocusedElement = $(':focus')
  restoreFocus: ->
    if @previouslyFocusedElement?.isOnDom()
      @previouslyFocusedElement.focus()
    else
      atom.views.getView(atom.workspace).focus()

  # toggles the SelectListView
  toggle: ->
    if @panel.isVisible()
      @panel.hide()
    else
      @setItems(@getItems())
      @panel.show()
      @focusFilterEditor()

  cancelled: ->
    if @panel.isVisible()
      @panel.hide()
