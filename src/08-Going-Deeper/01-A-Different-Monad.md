# A Different Monad

**Warning:** To understand this file and its example, you must understand one of the following:
- Monad Transformers and the ReaderT design pattern
- Free/Run

If you don't know them, see my overview of them in [Application Structure](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/21-Hello-World/05-Application-Structure)

Thus far, we have always assumed that the monad type used in components was `Aff`. But what if we wanted to use a different monad?

Since components must eventually be run in `Aff`, we'll eventually need to convert that monadic type into `Aff` no matter which monad type we use. When using monad transformers / ReaderT design pattern, that means we'll be using `Aff` as the base monad. When using `Free`/`Run`, that means we need to interpret our AST into `Aff`.

To change the monad type, there are a few steps we need to take.
First, in the component's type signature, we change `H.Component HH.HTML Query Input Message Aff` into one of the following:
- ReaderT: `forall m. MonadConstraint1 m => {- etc. -} H.Component HH.HTML Query Input Message m`
- Run: `H.Component HH.HTML Query Input Message (Run (AST1 {- + etc. -} + ()))`

Second, we'll "convert" our monadic type into `Aff` by using `H.hoist`:
```purescript
-- ReaderT
let newComponent = H.hoist (\app -> runReaderT app envInfo) orginalComponent

-- Run
let newComponent = H.hoist (\app -> runToAff app) orginalComponent
  where
    runToAff :: Run (YourEffects + ()) ~> Aff
    runToAff =
      interpret (
        case_
          # on _effectName effectAlgebra
      )
```

Third, we'll change how we write monadic code in the `handleAction` and `handleQuery` part:
```purescript
-- for ReaderT Unit Aff, this is quite simple
handleAction :: Action -> H.HalogenM State Action NoChildSlots Message m Unit
handleAction = case _ of
  PrintAlert -> do
    liftEffect do
      window >>= alert "We're using a non-Aff monad here"

-- for Run (Effects + ()), this requires using `MonadTrans`'s `lift` explicitly
handleAction :: Action -> H.HalogenM State Action NoChildSlots Message MonadType Unit
handleAction = case _ of
  -- Here, we see that we must use MonadTrans.lift to lift Run into HalogenM
  PrintAlert -> MonadTrans.lift do
    printAlert "We're using a non-Aff monad here"
```

See the next file for a full example and be aware of the below bug

### Don't Use `StateT` as the `MonadType` in a component.

We can use a different monad transformer than just ReaderT. However, be aware that using `StateT` as your monad type will not work as expected.

See https://github.com/slamdata/purescript-halogen/issues/386 for the issue.

The workaround is to use a `ReaderT Env a` where `Env` is a record that stores a `Ref` value.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

### ReaderT

```bash
spago bundle-app -m GoingDeeper.ADifferentMonad.ReaderT -t assets/going-deeper/a-different-monad--readert.js
parcel serve assets/going-deeper/a-different-monad--readert.html -o a-different-monad--readert--parcelified.html --open
```

### Run

```bash
spago bundle-app -m GoingDeeper.ADifferentMonad.Run -t assets/going-deeper/a-different-monad--run.js
parcel serve assets/going-deeper/a-different-monad--run.html -o a-different-monad--run--parcelified.html --open
```
