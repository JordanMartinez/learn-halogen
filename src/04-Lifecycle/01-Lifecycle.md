# Lifecycle

Currently, there are two hooks for a component's lifecycle:
- initialization
- finalization

The initializer handler runs right after the component has been fully rendered. If the component has children components that have an initializer handler, the children's initialization handlers will run before the component's initialization handler.

The finalizer handler handler runs right before the component is fully removed. If the component has children components that have an finalizer handler, the children's finalization handlers will run before the component's finalization handler.

Each is treated like an event:
1. Indicate via `Maybe` whether or not to continue processing the initialization/finalization "event"
2. Convert the event into a value of the component's `action` type.
3. Handle that `action` type's value via `handleAction`.

To make a component support initialization and/or finalization, we must do two things:
1. Add an `Initialize`/`Finalize` value to the component's `ActionType`
2. Override the `H.defaultEval`'s corresponding `initialize` and `finalize` values with a value whose type is `Maybe ActionType`
3. Add a case in `handleAction` that specifies what to do when the component is initialized/finalized.

In sum:
```purescript
data Action
  = -- other actions
  | Initialize
  | Finalize

component :: TypeSignature
component =
  H.mkComponent
    { initializeState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                     , initialize = initialize
                                     , finalize = finalize
                                     }
    }
  where
    initialize :: Maybe Action
    initialize = Just Initialize

    finalize :: Maybe Action
    finalize = Just Finalize

    handleAction :: Action -> H.HalogenM State Query ChildSlots Input Message Monad Unit
    handleAction = case _ of
      -- other actions
      {- SomeAction -> do
        -- code....
      -}
      Initialize -> do
        -- initializer code
      Finalize -> do
        -- finalizer code
```

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

### Child Lifecycle Component

```bash
spago bundle -m Lifecycle.Child -t assets/lifecycle/lifecycle-child.js
parcel serve assets/lifecycle/lifecycle-child.html -o lifecycle-child--parcelified.html --open
```

### Parent Lifecycle Component

```bash
spago bundle -m Lifecycle.Parent -t assets/lifecycle/lifecycle-parent.js
parcel serve assets/lifecycle/lifecycle-parent.html -o lifecycle-parent--parcelified.html --open
```
