CommentAnchorsView = require './comment-anchors-view'
{CompositeDisposable} = require 'atom'

module.exports = CommentAnchors =
  commentAnchorsView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @commentAnchorsView = new CommentAnchorsView(state.commentAnchorsViewState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'comment-anchors:toggle': => @commentAnchorsView.toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @commentAnchorsView.destroy()

  serialize: ->
    commentAnchorsViewState: @commentAnchorsView.serialize()
