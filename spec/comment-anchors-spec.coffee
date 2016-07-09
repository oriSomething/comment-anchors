# CommentAnchors = require '../lib/comment-anchors'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.
#
# describe "CommentAnchors", ->
#   [workspaceElement, activationPromise] = []
#
#   beforeEach ->
#     workspaceElement = atom.views.getView(atom.workspace)
#     activationPromise = atom.packages.activatePackage('comment-anchors')
#
#   describe "when the comment-anchors:toggle event is triggered", ->
#     it "hides and shows the modal panel", ->
#       # Before the activation event the view is not on the DOM, and no panel
#       # has been created
#       expect(workspaceElement.querySelector('.comment-anchors')).not.toExist()
#
#       # This is an activation event, triggering it will cause the package to be
#       # activated.
#       atom.commands.dispatch workspaceElement, 'comment-anchors:toggle'
#
#       waitsForPromise ->
#         activationPromise
#
#       runs ->
#         expect(workspaceElement.querySelector('.comment-anchors')).toExist()
#
#         commentAnchorsElement = workspaceElement.querySelector('.comment-anchors')
#         expect(commentAnchorsElement).toExist()
#
#         commentAnchorsPanel = atom.workspace.panelForItem(commentAnchorsElement)
#         expect(commentAnchorsPanel.isVisible()).toBe true
#         atom.commands.dispatch workspaceElement, 'comment-anchors:toggle'
#         expect(commentAnchorsPanel.isVisible()).toBe false
#
#     it "hides and shows the view", ->
#       # This test shows you an integration test testing at the view level.
#
#       # Attaching the workspaceElement to the DOM is required to allow the
#       # `toBeVisible()` matchers to work. Anything testing visibility or focus
#       # requires that the workspaceElement is on the DOM. Tests that attach the
#       # workspaceElement to the DOM are generally slower than those off DOM.
#       jasmine.attachToDOM(workspaceElement)
#
#       expect(workspaceElement.querySelector('.comment-anchors')).not.toExist()
#
#       # This is an activation event, triggering it causes the package to be
#       # activated.
#       atom.commands.dispatch workspaceElement, 'comment-anchors:toggle'
#
#       waitsForPromise ->
#         activationPromise
#
#       runs ->
#         # Now we can test for view visibility
#         commentAnchorsElement = workspaceElement.querySelector('.comment-anchors')
#         expect(commentAnchorsElement).toBeVisible()
#         atom.commands.dispatch workspaceElement, 'comment-anchors:toggle'
#         expect(commentAnchorsElement).not.toBeVisible()
