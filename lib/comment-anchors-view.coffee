{SelectListView} = require 'atom-space-pen-views'
{Point} = require 'atom'

CommentRegExpList = require './comment-list.coffee'

module.exports =
class MySelectListView extends SelectListView
  initialize: ->
    super
    @addClass('overlay from-top')
    @setItems(@getItems())
    @previousPositions = [];

    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.hide()

  getEmptyMessage: ->
    # "No anchors found in file --> searching for #{@getRegex().toString().slice(1, -1)}"
    "No anchors found in file!"

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
    if not editor
      return

    @getPreviousPosition(editor)
    position = new Point(anchor.line, 1)

    editor.setCursorBufferPosition(position)
    editor.moveToFirstCharacterOfLine()
    editor.scrollToBufferPosition(position, center: true)
    @restoreFocus()

  # scans lines of active text editor for anchored comments
  getItems: ->
    editor = atom.workspace.getActiveTextEditor()
    if not editor
      return []

    line = editor.getLineCount()
    anchors = []
    # get current anchor setting
    criteria = CommentRegExpList.getRegex(editor.getGrammar().name.toLowerCase())
    # get each line of text editor
    while (line -= 1) > -1
      text = editor.lineTextForBufferRow(line)
      result = null
      criteria.some (test) -> result = text.match(test)
      if result
        anchors.unshift
          line: line + 1
          text: result[2]
    anchors

  # used to find old line information in order to jump back to spot
  getPreviousPosition: (editor) ->
    prevPosition = editor.getCursorBufferPosition()
    @previousPositions.push(prevPosition)
    if @previousPositions.length > 30
      @previousPositions.shift()
  returnToPreviousPosition: ->
    editor = atom.workspace.getActiveTextEditor()
    if @previousPositions.length
      position = @previousPositions.pop()
      editor.setCursorBufferPosition(position)
      editor.scrollToBufferPosition(position, center: true)

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


#### this is the end of the file (anchor used for testing purposes)
