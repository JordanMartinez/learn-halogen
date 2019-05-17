# Message Only

This example will swap the previous example. In this example, the parent component will render the child component and a text value that displays the latest message received from the child. Every time the child's button is clicked, the parent will receive a message from the child and update its state to that value. It will then render its text using that state.

Now look at the next file for the full example.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m ParentChildRelationships.ParentlikeComponents.SingleChild.MessageOnly -t assets/parent-child-relationships/parentlike-components/single-child/parent-message-only.js
parcel serve assets/parent-child-relationships/parentlike-components/single-child/parent-message-only.html -o parent-message-only--parcelified.html --open
```
