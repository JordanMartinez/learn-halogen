# Child: Query Only

In this example, we'll wrap the child-like component you define in a parent-like component that has three buttons. The following describes what will occur when a button rendered in the parent is clicked (buttons are shown in order):
1. the parent will send a "request" `query` to the child and ask it for its current state.
2. the parent will send a "tell" `query` to the child and tell it to set its current state to a new value. The parent will "forget" the child's state.
3. the parent will send a "request" `query` with additional information to the child.

Now look at the next file for the full example.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m ParentChildRelationships.ChildlikeComponents.QueryOnly -t assets/parent-child-relationships/childlike-components/query-only.js
parcel serve assets/parent-child-relationships/childlike-components/query-only.html -o child-query-only--parcelified.html --open
```
