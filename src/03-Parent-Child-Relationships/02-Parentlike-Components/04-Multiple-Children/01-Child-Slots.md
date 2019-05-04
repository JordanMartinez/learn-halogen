# Child Slots

This example finally reveals how to render child components properly: slots.

In this example, we will render use 2 slot types (e.g. different `query`, `message`, `index` combination) to render multiple child components.

~~Now look at the next file for the full example.~~ This is still a WIP.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m ParentChildRelationships.ParentlikeComponents.SingleChild.MessageOnly -t assets/parent-child-relationships/parentlike-components/multiple-children/child-slots.js
parcel serve assets/parent-child-relationships/parentlike-components/multiple-children/child-slots.html -o child-slots--parcelified.html --open
```
