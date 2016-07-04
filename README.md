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

Just press `cmd-shift-a` and you can toggle comment-anchors anywhere!

<p align="center">
  <img src="https://raw.githubusercontent.com/callodacity/comment-anchors/master/demo/demo.gif" />
</p>

### Supported grammars and comments

* javascript, js (rails), js (babel)
* coffeescript
* obj-c, obj-c++
* c, c++, c#
* shell script
* ruby, ruby (rjs)
* python
* perl
* yaml
* html
* xml
* php
* css, sass, less, scss 
* go

### Roadmap

- [ ] Remember previous position (jump forward, jump back)
- [x] add more grammars and matches
