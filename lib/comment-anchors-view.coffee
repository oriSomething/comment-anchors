{SelectListView} = require 'atom-space-pen-views'
{Point} = require 'atom'

#### TODO
# goes to one line after selected...
# add more languages...
# add better error handling...
# publish...

CommentRegExpList = require './comment-list.coffee'

module.exports =
class MySelectListView extends SelectListView
  initialize: ->
    super
    @addClass('overlay from-top')
    @setError('No anchors found.')

    @setItems(@getItems())

    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.hide()

  getFilterKey: ->
    'text'

  viewForItem: (item) ->
    "<li>
      #{item.text}
      <div class='pull-right'>
          <kbd class='key-binding pull-right'>line: #{item.line}</kbd>
      </div>
    </li>"

  confirmed: (item) ->
    console.log("#{item.text} was selected")
    @panel.hide();

    editor = atom.workspace.getActiveTextEditor()
    position = new Point(item.line, 1)

    editor.setCursorBufferPosition(position)
    editor.moveToFirstCharacterOfLine()
    editor.scrollToBufferPosition(position, center: true)
    @restoreFocus()

  cancelled: ->
    console.log("This view was cancelled")
    if @panel.isVisible()
      @panel.hide()

  getItems: ->
    editor = atom.workspace.getActiveTextEditor()
    grammar = editor.getGrammar().name.toLowerCase()
    lines = editor.getLineCount()
    anchors = []

    regex = CommentRegExpList.list[grammar] ? CommentRegExpList.list.javascript

    while lines -= 1
      line = editor.lineTextForBufferRow(lines)
      anchor = regex.exec(line)
      if anchor
        anchors.unshift
          line: lines + 1
          text: anchor[1]

    return anchors

  storeFocusedElement: ->
    @previouslyFocusedElement = $(':focus')

  restoreFocus: ->
    if @previouslyFocusedElement?.isOnDom()
      @previouslyFocusedElement.focus()
    else
      atom.views.getView(atom.workspace).focus()

  toggle: ->

    if @panel.isVisible()
      @panel.hide()
    else
      @setItems(@getItems())
      @panel.show()
      @focusFilterEditor()
