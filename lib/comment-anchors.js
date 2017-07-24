"use strict";

const CommentAnchorsView = require("./comment-anchors-view");
const { CompositeDisposable } = require("atom");
const CommentRegExpList = require("./comment-list");

module.exports = {
  commentAnchorsView: null,
  modalPanel: null,
  subscriptions: null,

  //// activate
  activate(state) {
    this.commentAnchorsView = new CommentAnchorsView(state.commentAnchorsViewState);

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(
      atom.commands.add("atom-workspace", {
        "comment-anchors:toggle": () => this.commentAnchorsView.toggle()
      })
    );
    // Register command that returns to previous position
    this.subscriptions.add(
      atom.commands.add("atom-workspace", {
        "comment-anchors:return": () => this.commentAnchorsView.returnToPreviousPosition()
      })
    );
    // Register command that goes to the next mark
    this.subscriptions.add(
      atom.commands.add("atom-workspace", {
        "comment-anchors:goToNextMark": () => this.commentAnchorsView.goToNextMark()
      })
    );
  },

  //// deactivate
  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.commentAnchorsView.destroy();
  },

  //// serialize
  serialize() {
    return {
      commentAnchorsViewState: this.commentAnchorsView.serialize()
    };
  },

  //// package configuration
  config: {
    alwaysUseSpecifiedRegExp: {
      title: "Always use custom RegExp match for Anchors",
      description:
        "Set this to true to only match the Custom RegExp specified below, no matter the current grammar setting.",
      type: "boolean",
      default: false
    },

    customAnchorRegExp: {
      title: "Custom RegExp to Match anchors",
      description: `If Comment Anchors doesn't recognise the current grammar, it will default to this RegExp (i.e. // MARK: (title)).
        <br/>_If you include a capture group it will be the title of the anchor_.
        <br/>**"^\\s*"** matches the start of a line (with or without whitespace).
        <br/>**"\\/{2} MARK:"** matches "// MARK:".
        <br/>**"(.+)"** captures any text until the end of the line (the anchor title).
        <br/>
        <br/>**So the default RegExp will match (same as Xcode):**
        <br/>// MARK: anchorname`,

      type: "string",
      default: CommentRegExpList.list.defaults.regex.toString().slice(1, -1)
    },

    customAnchorRegExpIndex: {
      title: "Capture group index",
      description: `If you have specified a custom RegExp, enter the index of the matching capture group.
        <br/>For example:
        <br/>  The capture index to match "**(.+)**" for the RegExp "**/(####|@ANCHOR) (.+)/**" is 2.
        <br/>  This is because RegExp.exec(str) returns [match, group1, group2, ...]`,
      type: "array",
      default: CommentRegExpList.list.defaults.captureIndex
    }
  }
};
