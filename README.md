# Comment Anchors for Atom

_Anchor your comments! A package to easily navigate your code in Atom._  
_Jump to and from different comments within your code without scrolling._

> If you've ever used Xcode, comment anchors are exactly the same as its `// MARK: anchor-name`.

### What does it do?

Ever wondered how much time you actually waste by scrolling manually through
extremely large and long source files?   
What if your file were over 1,000 lines long, and you only wanted to see a specific part of it?  

**Comment Anchors** is your answer! Define any anchor you want, and comment-anchors
will find them and you can easily jump to them from anywhere in your code!

Default behaviour is to matches all lines with `// MARK: `.  
The comment anchors package additionally adds symbol anchors as well.  

This means that anchors will be a longer variation of your comment style, for example:
- `//` anchored by `////`
- `/* */` anchored by `/**** ****/`
- `<!-- -->` anchored by `<!---- ---->`.  

You can also configure this package to recognise any anchor you want!

```js

"an extremely long javascript source file"
// MARK: variable declarations              <--- this is an anchor
var a, b, c;
var foo, bar, baz;

//// Utility functions Declaration          <--- this too!
let VeryImportantFunction = function() {...};
let createElement = function() {...};
let destroyElement = function() {...};
let getElement = function() {...};

// @ANCHOR AnotherImportantPlaceInMyCode     <--- Set anchors to whatever you want!
if (someCondition) {
  VeryImportantFunction(false);
}
else {
  VeryImportantFunction(true);
}

```

### Settings and features

**Jump back**  
Comment Anchors remembers your previous position. So if you jumped to an anchor, just bring up the command palette and call `comment-anchors:return` and you'll jump right back to where you came from.

**Custom anchors**  
In settings you can define whatever anchor you like, you can also set it to override any default settings.

### Demo

Just press `cmd-shift-a` / `ctrl-shift-a` and you can toggle comment-anchors anywhere!

<p align="center">
  <img src="http://i.imgur.com/IpnIMl9.gif" />
</p>

### Supported grammars and comments

In essence, you will define your anchors by repeating your comment token 4 times, examples below:

* All grammars will anchor `// MARK: `
* Forward slash style comments `//` are anchored by `//// title`
  * JavaScript, js (rails), js (babel)
  * Obj-C, Obj-C++
  * C, C++, C#
* Hash style comments `#` are anchored by `#### title`
  * CoffeeScript
  * Shell Script
  * Ruby, Ruby on Rails (rjs)
  * Python
  * YAML
  * Perl
* HTML style comments `<!-- -->` are anchored by `<!---- title ---->`
  * HTML
  * XML
* CSS style comments `/* */` are anchored by `/**** title ****/`
  * CSS
  * SASS  (or `//// title`)
  * LESS  (or `//// title`)
  * SCSS  (or `//// title`)
  * Go
* other grammars that support multiple comments are anchored by the comment type they support.
  * i.e. PHP is anchored by:
    * `//// title` or
    * `#### title` or
    * `/**** title ****/`

### Roadmap

- [x] Remember previous position (jump forward, jump back)
- [x] add more grammars and matches
- [ ] think of more improvements

### License

MIT
