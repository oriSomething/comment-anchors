# Comment Anchors for Atom

_Anchor your comments! A package to easily navigate your code in Atom._  
_Jump to and from different comments within your code without scrolling._

### What does it do?

Ever wondered how much time you actually waste by scrolling manually through
extremely large and long source files?   
What if your file were over 1,000 lines long, and you only wanted to see a specific part of it?  

**Comment Anchors** is your answer! Define any anchor you want, and comment-anchors
will find them and you can easily jump to them from anywhere in your code!

Default behaviour is to match `////` but you can set your anchors as anything you want!

```js

"an extremely long source file"
...
...

//// VeryImportantFunction Declaration        <--- this is an anchor
let VeryImportantFunction = function() {...};

...
... // many many lines of code...
...

//// AnotherImportantPlaceInMyCode            <--- this too!
if (!!~null)
  VeryImportantFunction(false);
else
  VeryImportantFunction(true);

```

### Demo

Just press `cmd-shift-a` / `ctrl-shift-a` and you can toggle comment-anchors anywhere!

<p align="center">
  <img src="http://i.imgur.com/IpnIMl9.gif" />
</p>

### Supported grammars and comments

* forward slash style comments `//` are anchored by `//// title`
  * javascript, js (rails), js (babel)
  * obj-c, obj-c++
  * c, c++, c#
* hash style comments `#` are anchored by `#### title`
  * coffeescript
  * shell script
  * ruby, ruby (rjs)
  * python
  * yaml
  * perl
* html style comments `<!-- -->` are anchored by `<!---- title ---->`
  * html
  * xml
* css style comments `/* */` are anchored by `/**** title ****/`
  * css
  * sass
  * less
  * scss
  * go
* other grammars that support multiple comments are anchored by the comment type they support.
  * i.e. php is anchored by:
    * `//// title`
    * `#### title`
    * `/**** title ****/`

### Roadmap

- [ ] Remember previous position (jump forward, jump back)
- [x] add more grammars and matches
