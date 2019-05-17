# Child: Input Only

In this example, we'll take the child-like component you define and wrap it in our own parent-like component. This example will use `Int` as our `Input` type. So, our example will have to convert the `Int`/`Input` type into the child-like component's `State` type. We'll do this in the `initialState` function.

Then, every 2 seconds after the initial rendering, the parent-like component will re-render the child by passing in a random integer value (1 to 200) as the `Input` type's value. We can decide whether to handle that or not using `Maybe` and mapping the input value into the child-like component's `Action` type. We'll do this in the `receive` function and `handleAction` function.

Now look at the next file for the full example.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m ParentChildRelationships.ChildlikeComponents.InputOnly -t assets/parent-child-relationships/childlike-components/input-only.js
parcel serve assets/parent-child-relationships/childlike-components/input-only.html -o child-input-only--parcelified.html --open
```
