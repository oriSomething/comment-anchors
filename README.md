# Comment Anchors for Atom

_Anchor your comments! A package to easily navigate your code in Atom._  
_Jump to and from different comments within your code without scrolling._

### What does it do?

Ever wondered how much time you actually waste by scrolling manually through
extremely large and long source files?   
What if your file were over 1,000 lines long, and you only wanted to see a specific part of it?  

**Comment Anchors** is your answer! Define any anchor you want, and comment-anchors
will find them and you can easily jump to them from anywhere in your code!

Default behaviour is to match `////` but you can set your anchors as anything you want.

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
if (someCondition)
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

In essence, you will define your anchors by repeating your comment token 4 times, examples below:

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
  * SASS
  * LESS
  * SCSS
  * Go
* other grammars that support multiple comments are anchored by the comment type they support.
  * i.e. PHP is anchored by:
    * `//// title` or
    * `#### title` or
    * `/**** title ****/`

### Roadmap

- [ ] Remember previous position (jump forward, jump back)
- [x] add more grammars and matches

### License

MIT
