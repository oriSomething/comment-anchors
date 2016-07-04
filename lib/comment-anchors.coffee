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

    customAnchorMatch:
      title: 'Custom RegExp to Match anchors'
      description:
        'If Comment Anchors doesn\'t recognise the current grammar, it will default to this RegExp (i.e. ////).
        <br/>If you include a capture group it will be the title of the anchor.
        <br/>**"^\\s*"** matches the start of a line.
        <br/>**"\\/{4}"** matches "/" 4 times.
        <br/>**"(.+)"** captures any text until the end of the line (the anchor title).'
      type: 'string'
      default: CommentRegExpList.list.javascript.toString().slice(1, -1)
