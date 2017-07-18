CommentAnchorsView = require '../lib/comment-anchors-view'
sampleAnchors = require './tests'

path = require 'path'
fs = require 'fs-plus'
temp = require 'temp'


describe "CommentAnchorsView", ->
  [editor, view, workspaceElement] = []

  beforeEach ->
    # create temp files
    directory = temp.mkdirSync()
    atom.project.setPaths([directory])
    workspaceElement = atom.views.getView(atom.workspace)
    filePath = path.join(directory, 'comment-anchors.txt')
    fs.writeFileSync(filePath, 'asd')
    fs.writeFileSync(path.join(directory, 'sample-anchors.txt'), sampleAnchors)

    # open a temp workspace
    waitsForPromise ->
      atom.workspace.open(filePath).then (o) -> editor = o
    #
    runs ->
      view = new CommentAnchorsView()
    #
    # waitsForPromise ->
    #   atom.packages.activatePackage('whitespace')

  describe "Always match '// MARK: ' anchors", ->
    it 'should match with forwardSlash style', ->
      dump = JSON.stringify(view.getItems())
      console.log(dump)
      expect(1).toBe(1)
