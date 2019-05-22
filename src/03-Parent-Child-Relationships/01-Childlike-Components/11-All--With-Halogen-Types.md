# Child: All (with Halogen Types)

This example is the exact same as the previous example functionality-wise, except that now we remove the scaffolding types and use the real Halogen types.

There are two types that we haven't explained yet and will cover in future files:
- `NoChildSlots` - We'll cover this when we talk about the parent components.
- `MonadType` - We'll cover this when we talk about how to couple your "pure" business logic to our "impure" Halogen components.

In the upcoming example, you should only look at two things:
- the real Halogen type signatures of the functions and values we've been explaining
- the `H.mkComponent` part and its `eval` label

## The `Eval` label

In our previous examples, we've been defining `receive`, `handleAction`, and `handleQuery` separately. In an unscaffolded Halogen component, theses are coupled together in single label: `eval`. It looks something like this:
```purescript
type TypeSignature = -- different for each one...
type EvalSpec =
  { handleAction :: TypeSignature
  , handleQuery :: TypeSignature
  , receive :: TypeSignature

  -- These two are used for lifecycle hooks
  -- We'll cover them in the `Lifecycle` folder
  , initialize :: TypeSignature
  , finalize :: TypeSignature
  }

-- in our code
H.mkComponent
  { -- other labels
  , eval: H.mkEval evalSpecRecord
  }
```
`EvalSpec` has 5 labels that allow you to configure how the component works. Only in a few situations do we need them all. There are two approaches to handling this.

In the first, one could write out the full record each time one defines a new component, and use "non-functional" values for the parts that aren't desired. However, this approach adds "noise" to the code. It's harder to see the developer's intent.

In the second, one copies a record that uses "non-functional" values for each label and then overwrites the parts that are desired with "functional" values. This highlights the developer's intent at a minimal cost.

To accomplish this second approach, we use `H.defaultEval` and record-overwriting syntax
```purescript
defaultEval :: EvalSpec
defaultEval =
 { {- labels and their non-functional values... -}
 }

componentEvalSpec :: EvalSpec
componentEvalSpec =
  defaultEval { handleAction = actualHandleActionCode
              , receive = actualReceiveCode
              }
```

Putting this all together, we would define a component like this:
```purescript
component :: HalogenComponentType -- not the full type but explains what this is
component =
    H.mkComponent
      { initialState: initialState
      , render: render
      , eval: H.mkEval $ H.defaultEval { handleAction = actualHandleActionCode
                                       , receive = actualReceiveCode
                                       }
      }
  where
    initialState :: TypeSignature
    initialState input = -- code

    render :: TypeSignature
    render state = -- code

    handleAction :: TypeSignature
    handleAction action = -- code

    receive :: TypeSignature
    receive input = -- code
```

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m ParentChildRelationships.ChildlikeComponents.All.WithHalogenTypes -t assets/parent-child-relationships/childlike-components/all--with-halogen-types.js
parcel serve assets/parent-child-relationships/childlike-components/all--with-halogen-types.html -o child-all--with-halogen-types--parcelified.html --open
```
