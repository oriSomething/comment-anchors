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
    @getPreviousPosition(editor)
    position = new Point(anchor.line, 1)

    editor.setCursorBufferPosition(position)
    editor.moveToFirstCharacterOfLine()
    editor.scrollToBufferPosition(position, center: true)
    @restoreFocus()

  # scans lines of active text editor for anchored comments
  getItems: ->
    editor = atom.workspace.getActiveTextEditor()
    grammar = editor.getGrammar().name.toLowerCase()
    lines = editor.getLineCount()
    anchors = []

    # get current anchor setting
    setting = CommentRegExpList.getRegex(grammar)

    # get each line of text editor
    while (lines -= 1) > -1
      line = editor.lineTextForBufferRow(lines)
      # search each line for anchor
      # anchor = setting.regex.exec(line)
      # if anchor
      #   # get match (loop through capture groups)
      #   text = ''
      #   for i in setting.captureIndex
      #     if anchor[i]
      #       text = anchor[i]
      #   # add anchor to array
      #   anchors.unshift
      #     line: lines + 1
      #     text: text

    return anchors

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
