# Learn Halogen Outline

Show how to...
1. Render static HTML (components without state) via Halogen VDOM's DSL
2. Render dynamic HTML (components with state and simple event handling)
3. Introduce parent-child relationships between components

## Compilation and Viewing Instructions

In this project, we'll use a 2-step process for seeing what the Halogen code looks like.

Rather than explaining that process in each folder's compilation instructions, we'll cover the general pattern below. **Note: the below commands should NOT be run. They are illustrative.**

1. Use `Spago` to bundle the PS files into a single JS file that is referenced by a corresponding HTML file in a `script` tag.
2. Use `Parcel` to create a server that serves the corresponding HTML file
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
    <!-- Here is where we reference to the bundled JS file built via Spago -->
    <script src="/ps-files-bundled-into-js-file.js" charset="utf-8"></script>
  </body>
</html>

```
