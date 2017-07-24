"use strict";

const { SelectListView } = require("atom-space-pen-views");
const { Point } = require("atom");

//// Comment Anchors

const CommentRegExpList = require("./comment-list");

module.exports = class MySelectListView extends SelectListView {
  initialize() {
    super.initialize();

    this.viewTemplate = document.createElement("template");
    this.viewTemplate.innerHTML = `
      <li>
        <span class="js-text"></span>
        <div class="pull-right">
          <kbd class="key-binding pull-right">line: <span class="js-line"></span></kbd>
        </div>
      </li>`;

    this.addClass("overlay from-top");
    this.setItems(this.getItems());
    this.previousPositions = [];

    if (this.panel == null) {
      this.panel = atom.workspace.addModalPanel({ item: this });
    }

    this.panel.hide();
  }

  getEmptyMessage() {
    // "No anchors found in file --> searching for #{@getRegex().toString().slice(1, -1)}"
    return "No anchors found in file!";
  }

  getFilterKey() {
    return "text";
  }

  viewForItem(anchor) {
    const text = document.createTextNode(anchor.text);
    const line = document.createTextNode(String(anchor.line));
    const view = this.viewTemplate.content.cloneNode(true);

    view.querySelector(".js-text").appendChild(text);
    view.querySelector(".js-line").appendChild(line);

    return view;
  }

  // User selected anchor
  confirmed(anchor) {
    this.panel.hide();

    const editor = atom.workspace.getActiveTextEditor();
    this.getPreviousPosition(editor);
    const position = new Point(anchor.line, 1);

    editor.setCursorBufferPosition(position);
    editor.moveToFirstCharacterOfLine();
    editor.scrollToBufferPosition(position, { center: true });
    this.restoreFocus();
  }

  // get anchor regex
  getRegex(grammar) {
    let regex, captureIndex, customRegex, customIndex;

    // check if user has specified a RegExp to use
    const override = atom.config.get("comment-anchors.alwaysUseSpecifiedRegExp");

    // if user has set a custom RegExp, or no RegExp found in our list
    if (override || !CommentRegExpList.list[grammar]) {
      customRegex = atom.config.get("comment-anchors.customAnchorRegExp");
      customIndex = atom.config.get("comment-anchors.customAnchorRegExpIndex");
      // get user's custom RegExp
      try {
        regex = new RegExp(customRegex);
        captureIndex = customIndex;
        // if custom regex is invalid
      } catch (error) {
        /* eslint-disable no-console */
        if (error instanceof SyntaxError) {
          console.error("[COMMENT-ANCHORS]:: Check your custom regex!");
          console.error(error);
        } else {
          console.error(error);
        }
        /* eslint-enable no-console */
      }
    } else {
      regex = CommentRegExpList.list[grammar].regex;
      captureIndex = CommentRegExpList.list[grammar].captureIndex;
    }

    // if not set default to Xcode `// MARK: ` style if error
    regex = regex == null ? CommentRegExpList.list.defaults.regex : regex;
    captureIndex = captureIndex == null ? CommentRegExpList.list.defaults.captureIndex : captureIndex;

    return { regex, captureIndex };
  }

  // scans lines of active text editor for anchored comments
  getItems() {
    const editor = atom.workspace.getActiveTextEditor();

    if (!editor) {
      return;
    }
    const grammar = editor.getGrammar().name.toLowerCase();
    const lines = editor.getLineCount();
    const anchors = [];

    // get current anchor setting
    const setting = this.getRegex(grammar);

    // get each line of text editor
    // Scan each line of the text editor.
    for (let i = 0; i < lines; i++) {
      const line = editor.lineTextForBufferRow(i);
      // Search line for anchor.
      const anchor = setting.regex.exec(line);
      if (anchor) {
        // Get anchor match (loop though capture groups).
        let text = anchor[setting.captureIndex.find(i => anchor[i])];

        anchors.push({ line: i, text });
      }
    }

    return anchors;
  }

  // used to find old line information in order to jump back to spot
  getPreviousPosition(editor) {
    const prevPosition = editor.getCursorBufferPosition();
    this.previousPositions.push(prevPosition);
    if (this.previousPositions.length > 30) {
      this.previousPositions.shift();
    }
  }

  returnToPreviousPosition() {
    const editor = atom.workspace.getActiveTextEditor();
    if (this.previousPositions.length) {
      const position = this.previousPositions.pop();
      editor.setCursorBufferPosition(position);
      editor.scrollToBufferPosition(position, { center: true });
    }
  }

  // used to restore focus to the active text editor after jumping to specific line
  storeFocusedElement() {
    this.previouslyFocusedElement = $(":focus");
  }

  restoreFocus() {
    if (this.previouslyFocusedElement && this.previouslyFocusedElement.isOnDom()) {
      this.previouslyFocusedElement.focus();
    } else {
      atom.views.getView(atom.workspace).focus();
    }
  }

  // toggles the SelectListView
  toggle() {
    if (this.panel.isVisible()) {
      this.panel.hide();
    } else {
      this.setItems(this.getItems());
      this.panel.show();
      this.focusFilterEditor();
    }
  }

  cancelled() {
    if (this.panel.isVisible()) {
      this.panel.hide();
    }
  }

  // Go to next mark location
  goToNextMark() {
    const editor = atom.workspace.getActiveTextEditor();
    if (!editor) return;

    const row = editor.getCursorScreenPositions()[0].row;
    const anchors = this.getItems();

    if (anchors.length === 0) {
      return;
    }

    // Check for next anchor and go to
    for (let anchor of anchors) {
      if (anchor.line > row) {
        const position = new Point(anchor.line, 1);
        editor.setCursorBufferPosition(position);
        return;
      }
    }

    // If no forward anchor exist we go to the first anchor
    const position = new Point(anchors[0].line, 1);
    editor.setCursorBufferPosition(position);
  }
};

//// this is the end of the file (anchor used for testing purposes)
