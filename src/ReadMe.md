# Learn Halogen

Halogen works by using a tree-like structure where each entity is a `component`. A `component` is a self-contained entity that knows how to render itself based on its current state, can update its state, can detect and handle events, and can communicate with other `component`s in a hierarchial manner.

To accomplish all of this, Halogen uses a single `component` type that can be "configured" via 5 other types:
- the `state` type
- the `action` type
- the `input` type
- the `message` type
- the `query` type.

These 5 types are one reason why learning Halogen can be difficult as one can quickly feel overwhelmed by them, especially when new to the Functional Programming paradigm.

To limit this feeling of being overwhelmed, we'll provide some scaffolding that "hides" irrelevent things from you until you understand the foundational concepts first. This scaffolding code will be stored in the `Scaffolding` folder. Feel free to ignore this folder until after you have finished reading through the rest of the folder's contents.

## Outline

What follows is a modular, bottom-up approach to teaching each foundational concept and configuration type in a clear manner with examples that you can further build upon and play with.

The upcoming folders and files will show how to...
1. Render static HTML and CSS (components without state) via Halogen VDOM's DSL
2. Render dynamic HTML (components with state and simple event handling)
    - introduce the `state` type and `action` type
    - briefly overview monads and how they work
3. Overview parent and child relationships among components
    - introduce the `input`, `message`, and `query` types
    - overview the `action` type again
4. Overview lifecycle handlers
5. Expose the real and configurable `component` type we've been hiding with scaffolding and provide a template file for one to copy-paste-and-configure as needed
6. Overview the "Driver:" configuring where the top-level Halogen component is run and how to communicate with it
7. Advanced features and warnings about possible issues
8. "Where do we go from here?" and linking to other libraries

## Compilation and Viewing Instructions

In this project, we'll use a 2-step process for seeing what the Halogen code looks like.

Rather than explaining that process in each folder's compilation instructions, we'll cover the general pattern below. **Note: the below commands should NOT be run. They are illustrative.**

1. Use `Spago` to bundle the PS files into a single JS file that is referenced by a "corresponding HTML file" (see below after these instructions) in a `script` tag.
2. Use `Parcel` to create a server that serves the "corresponding HTML file"
```bash
# Bundle the PS into a JS file
spago bundle --main Path.To.Module --to assets/path/to/JS_File.js
# Parcel uses the HTML file to create a dependency tree,
# which finds the JS file we previously created
# It then creates a server and serves both.
parcel serve assets/path/to/corresponding/HTML_File.html -o HTML_File--parcelified.html --open --no-minify
```

The "corresponding HTML file" will look like this:
```html
<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Folder Title - File Title</title>
  </head>
  <body>
    <!-- Here is where we reference the bundled JS file built via Spago -->
    <script src="/ps-files-bundled-into-js-file.js" charset="utf-8"></script>
  </body>
</html>

```
