# Learn Halogen Outline

Show how to...
1. Render static HTML (components without state)
2. Render dynamic HTML (components with state)
3. Change an HTML components' state
4. Introduce parent-child relationships between components
5. Introduce life-cycle events
6.

## Compilation and Viewing Instructions

In this project, we'll use a 2-step process for seeing what the Halogen code looks like.

Rather than explaining that process in each folder's compilation instructions, we'll cover the general pattern below. **Note: the below commands should NOT be run. They are illustrative.**

1. Bundle the PS files into a single JS file that is referenced by a corresponding HTML file.
2. Create a server via Parcel that serve the HTML file
```bash
# Bundle the PS into a JS file
spago bundle --main Path.To.Module --to assets/path/to/JS_File.js
# Parcel uses the HTML file to create a dependency tree,
# which finds the JS file we previously created
# It then creates a server and serves both.
parcel serve assets/path/to/corresponding/HTML_File.html -o HTML_File--parcelified.html --open --no-minify
```
