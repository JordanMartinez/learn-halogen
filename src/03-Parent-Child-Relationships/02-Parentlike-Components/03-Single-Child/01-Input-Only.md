# Input Only

In this example, the parent component will render a button and the child component. Every time the parent's button is clicked, the parent will pass a random int value (the `input` value) down into the child component. The child component will update its text to show that value.

Now look at the next file for the full example.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m ParentChildRelationships.ParentlikeComponents.SingleChild.InputOnly -t assets/parent-child-relationships/parentlike-components/single-child/parent-input-only.js
parcel serve assets/parent-child-relationships/parentlike-components/single-child/parent-input-only.html -o parent-input-only--parcelified.html --open
```
