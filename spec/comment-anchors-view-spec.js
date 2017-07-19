/* global runs */
"use strict";

const CommentAnchorsView = require("../lib/comment-anchors-view");
const sampleAnchors = require("./tests");

const path = require("path");
const fs = require("fs-plus");
const temp = require("temp");

//// Tests

describe("CommentAnchorsView", function() {
  let view;

  beforeEach(function() {
    // create temp files
    const directory = temp.mkdirSync();
    atom.project.setPaths([directory]);
    const filePath = path.join(directory, "comment-anchors.txt");
    fs.writeFileSync(filePath, "asd");
    fs.writeFileSync(path.join(directory, "sample-anchors.txt"), sampleAnchors);

    // open a temp workspace
    waitsForPromise(() => atom.workspace.open(filePath).then(noop));

    //
    return runs(() => {
      view = new CommentAnchorsView();
    });

    //
    // waitsForPromise(() => atom.packages.activatePackage('whitespace'))
  });

  describe("Always match '// MARK: ' anchors", function() {
    it("should match with forwardSlash style", function() {
      const dump = JSON.stringify(view.getItems());
      console.log(dump); // eslint-disable-line
      expect(1).toBe(1);
    });
  });
});

//// Helpers

function noop() {}
