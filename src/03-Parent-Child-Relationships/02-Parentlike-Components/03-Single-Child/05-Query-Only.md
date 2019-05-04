# Query Only

In this example, the parent component will use the child component's `Query` type
1. to request information from the child (e.g. 'what is your state?')
2. to command the child to do something (e.g. 'set your state to X.')

Specifically, the parent will render
1. its knowledge of the child's state
2. a button for getting the child's state
3. a button for setting the child's state and clearing out its memory of the child's state
4. a button for setting the child's state and getting back the doubled version of the child's state

Now look at the next file for the full example.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m ParentChildRelationships.ParentlikeComponents.SingleChild.QueryOnly -t assets/parent-child-relationships/parentlike-components/single-child/parent-query-only.js
parcel serve assets/parent-child-relationships/parentlike-components/single-child/parent-query-only.html -o parent-query-only--parcelified.html --open
```
