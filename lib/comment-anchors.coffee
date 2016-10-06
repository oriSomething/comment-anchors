CommentAnchorsView = require './comment-anchors-view'
{CompositeDisposable} = require 'atom'

CommentRegExpList = require './comment-list.coffee'

module.exports = CommentAnchors =
  commentAnchorsView: null
  modalPanel: null
  subscriptions: null

  #### activate
  activate: (state) ->
    @commentAnchorsView = new CommentAnchorsView(state.commentAnchorsViewState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'comment-anchors:toggle': => @commentAnchorsView.toggle()
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'comment-anchors:highlight': => @highlight()
    # Register command that returns to previous position
    @subscriptions.add atom.commands.add 'atom-workspace', 'comment-anchors:return': => @commentAnchorsView.returnToPreviousPosition()

    @markers = []

  unhighlight: ->
    @markers.forEach (marker) -> marker.destroy()
    @markers = []

  highlight: ->
    editor = atom.workspace.getActiveTextEditor()
    if not editor
      return

    # editor.onDidChange =>
      # @unhighlight()
    # Get matching criteria
    criteria = CommentRegExpList.getRegex(editor.getGrammar().name.toLowerCase())

    # Go through each line and test for anchors
    line = editor.getLineCount()
    while (line -= 1) > -1
      text = editor.lineTextForBufferRow(line)
      result = null
      criteria.some (test) -> result = text.match(test)
      if result
        # mark text
        start = result.index + result[1].length
        end = start + result[2].length
        range = [[line, start], [line, end]]
        marker = editor.markBufferRange(range, { invalidate: 'touch' });
        # Update the marker on change
        marker.onDidChange (e) =>
          marker.destroy()
          if e.newHeadBufferPosition.row != e.newTailBufferPosition.row
            return
          newLine = e.newHeadBufferPosition.row
          text = editor.lineTextForBufferRow(newLine)
          result = null
          criteria.some (test) -> result = text.match(test)
          if result
            start = result.index + result[1].length
            end = start + result[2].length
            range = [[newLine, start], [newLine, end]]
            m = editor.markBufferRange(range, { invalidate: 'touch' });
            decoration = editor.decorateMarker(m, { type: 'highlight', class: 'comment-anchor' })
            @markers.push m
        decoration = editor.decorateMarker(marker, { type: 'highlight', class: 'comment-anchor' })
        @markers.push marker

  #### deactivate
  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @commentAnchorsView.destroy()

  #### serialize
  serialize: ->
    commentAnchorsViewState: @commentAnchorsView.serialize()

  #### package configuration
  config:
    allAnchors:
      title: 'Search for every type of anchor'
      description: '
        The package will highlight every match for any of the following:
        <br> `// MARK: <name>`
        <br> `//// <name>`
        <br> `#### <name>`
        <br> `/**** <name> ****/`
        <br> `<!---- <name> ---->`
        <br> (Plus custom anchor defined below)'
      type: 'boolean'
      default: false

    alwaysUseSpecifiedRegExp:
      title: 'Only use custom RegExp match for Anchors'
      description: 'Set this to true to only match the Custom RegExp specified below, no matter the current grammar setting.'
      type: 'boolean'
      default: false

    customAnchorRegExp:
      title: 'Custom RegExp to Match anchors'
      description:
        'If Comment Anchors doesn\'t recognise the current grammar, it will default to this RegExp (i.e. // MARK: (title)).
        <br/>_If you include a capture group it will be the title of the anchor_.
        <br/>**"^\\s*"** matches the start of a line (with or without whitespace).
        <br/>**"\\/{2} MARK:"** matches "// MARK:".
        <br/>**"(.+)"** captures any text until the end of the line (the anchor title).
        <br/>
        <br/>**So the default RegExp will match (same as Xcode):**
        <br/>// MARK: anchorname'
      type: 'string'
      default: CommentRegExpList.list.defaults[0].toString().slice(1, -1)
