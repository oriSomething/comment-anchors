module.exports = """

The comment anchors below begin at each SOL

// MARK: XcodeStyle noWhitespace

//// forwardSlash style noWhitespace

#### hashStyle noWhitespace

/**** cssStyle noWhitespace ****/

<!---- htmlStyle noWhitespace ---->

The comment anchors below have preceeding whitespace

  // MARK: XcodeStyle

  // === custom style ===

  //// forwardSlash style

  #### hashStyle

  /**** cssStyle ****/

  <!---- htmlStyle ---->

The comment anchors below have preceeding chars (shouldn't work)

foo // MARK: XcodeStyle
foo
foo // === custom style ===
foo
foo //// forwardSlash style
foo
foo #### hashStyle
foo
foo /**** cssStyle ****/
foo
foo <!---- htmlStyle ---->


The comment anchors below have following chars

// MARK: XcodeStyle foo

// === custom style === foo

//// forwardSlash style foo

#### hashStyle foo

/**** cssStyle ****/ foo

<!---- htmlStyle ----> foo
 """
