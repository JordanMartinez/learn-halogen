# Static HTML

We'll begin by first showing how to build a static HTML using Halogen's HTML DSL (domain specific language).

Starting small, there will not be any properties, css, or event handling. Rather, we'll just get used to the DSL itself. We'll render the following HTML that would appear in an HTML document's `body` element in Purescript
```html
<div>
    <div>
        <span>This is text in a span!</span>
    <div>
    <button>You can click me, but I don't do anything</button>
</div>
```

Now, look at the next file.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m StaticHTML.StaticHTML -t assets/static-html/static-html.js
parcel serve assets/static-html/static-html.html -o static-html--parcelified.html --open
```
