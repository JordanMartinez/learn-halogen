# Child: Message Only

In this example, we'll take the child-like component you define and wrap it in our own parent-like component. Any time the parent-like component receives a message from the child-like component, it will log those messages by adding a `div` with the message's text to the page.

This starting example will provide two ways to log the message to the screen.
1. The child will show a counter that you can increment/decrement and a button that, when clicked, will convert the counter's current state into a String and "raise" that as a message to the parent.
2. A second button that, when clicked, will "raise" its button text as a message to the parent.

Now look at the next file for the full example.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m ParentChildRelationships.ChildlikeComponents.MessageOnly -t assets/parent-child-relationships/childlike-components/message-only.js
parcel serve assets/parent-child-relationships/childlike-components/message-only.html -o child-message-only--parcelified.html --open
```
