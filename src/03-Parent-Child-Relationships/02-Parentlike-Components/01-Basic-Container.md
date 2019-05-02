# Basic Container

In this example, you will define a parent-like component that will be given a child component to render. Both the parent and child will be static HTML components. They will not respond to `input` values, raise `messages`, or have any `action`s. Again, we'll be hiding some of the configuration from you for now until we have explained how it works.

Now look at the next file for the full example.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m ParentChildRelationships.ParentlikeComponents.BasicContainer -t assets/parent-child-relationships/parentlike-components/basic-container.js
parcel serve assets/parent-child-relationships/parentlike-components/basic-container.html -o basic-container--parcelified.html --open
```
