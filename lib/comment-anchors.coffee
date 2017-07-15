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
    # Register command that returns to previous position
    @subscriptions.add atom.commands.add 'atom-workspace', 'comment-anchors:return': => @commentAnchorsView.returnToPreviousPosition()
    # Register command that goes to the next mark  
    @subscriptions.add atom.commands.add 'atom-workspace', 'comment-anchors:goToNextMark': => @commentAnchorsView.goToNextMark()

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
    alwaysUseSpecifiedRegExp:
      title: 'Always use custom RegExp match for Anchors'
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
      default: CommentRegExpList.list.defaults.regex.toString().slice(1, -1)

    customAnchorRegExpIndex:
      title: 'Capture group index'
      description:
        'If you have specified a custom RegExp, enter the index of the matching capture group.
        <br/>For example:
        <br/>  The capture index to match "**(.+)**" for the RegExp "**/(####|@ANCHOR) (.+)/**" is 2.
        <br/>  This is because RegExp.exec(str) returns [match, group1, group2, ...]'
      type: 'array'
      default: CommentRegExpList.list.defaults.captureIndex
