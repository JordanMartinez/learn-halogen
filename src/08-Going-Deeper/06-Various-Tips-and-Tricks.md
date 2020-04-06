# Various Tips and Tricks

## Calling `handleAction`/`handleQuery` within itself.

Let's say our component has an action called `AttemptStateReset`. When we handle this action via `handleAction`, we'll run code that does a number of checks to determine whether or not to reset the component's state.

There might be times where our code gets complicated and we don't want to repeat ourselves. One way for dealing with this is to call `handleAction` within `handleAction`:

```purescript
handleAction :: Action -> HalogenM ....
handleAction = case _ of
  AttemptStateReset -> do
    param1 <- checkParam1
    param2 <- checkParam2
    param3 <- checkParam3
    if (param1 && param2 && param3)
      then do
        put defaultValue
      else pure unit
  DoSomething1 -> do
    -- some code here
    importantComputation

    -- oh! we should see whether we need to reset our state.
    -- Rather than rewriting our code above, why not just run the
    -- `AttemptStateReset` code?
    handleAction AttemptStateReset

    -- ok, now we can continue doing stuff

  DoSomething2 -> do
    -- we don't use it here
    pure unit
  DoSomething3 -> do
    -- some other code....

    -- we want to check it here, too
    handleAction AttemptStateReset
```

Note that this also works within `handleQuery`
```purescript
handleQuery :: forall a. Query a -> HalogenM .... (Maybe a)
handleQuery = case _ of
  GetValueThatRequiresExpensiveComputation reply -> do
    value <- expensiveComputation
    pure $ Just $ reply value
  SomeRequest reply -> do
    arg1 <- someOtherComputation

    -- now we can use it here
    arg2 <- handleQuery $ H.request $ GetValueThatRequiresExpensiveComputation

    pure $ Just $ reply $ arg1 arg2
```
Because `handleAction` and `handleQuery` both return the `HalogenM` monadic type, we can use them in our action handlers and our query handlers.

```purescript
handleAction :: Action -> HalogenM ....
handleAction = case _ of
  DoExampleAction -> do
    arg2 <- handleQuery $ H.request $ SomeRequest
    doComputation arg2
  SomeAction -> do
    pure unit

handleQuery :: forall a. Query a -> HalogenM .... (Maybe a)
handleQuery = case _ of
  DoExampleQuery reply -> do
    handleAction SomeAction
    pure $ Just $ reply "Done."
  SomeRequest reply -> do
    pure $ Just $ reply unit
```

## Using `HH.text ""` as an empty placeholder HTML value

### The Design Pattern

Sometimes, we want to render HTML content based on some condition. When the condition is true, that content should be rendered. When it's not, it should not be rendered.

Halogen's HTML DSL uses the `Array` type for an element's children for performance reasons. In other words, `HH.div_ [ child1, child2, child3 ]`. As a result, one must have always have a value in the array; one cannot write something like...
```purescript
HH.div_
  [ alwaysRenderChild1
  , if condition renderChild2 else renderNothing
  , alwaysRenderChild3
  ]
```
... because there is no such "renderNothing" for HTML. So, the closest thing we have to `renderNothing` is `HH.text ""`.

Yes, something is still rendered. So, one might think, "Why not rewrite our render function to remove that possibility? Why not write something like this:"
```purescript
if condition
  then
    HH.div_
      [ alwaysRenderChild1
      , renderChild2
      , alwaysRenderChild3
      ]
  else
  HH.div_
    [ alwaysRenderChild1
    , alwaysRenderChild3
    ]
```
There are three reasons not to write this:
1. One must keep these two versions (or maybe more depending on the number of conditions) of the same code in sync with one another. As one adds more complexity, this gets harder to maintain / get right.
2. The code isn't as readable, so it's harder to see how one state is different from another.
3. The above code might not be as performant in some situations as just using `HH.text ""`. By using this placeholder HTML value, the index values of the other children do not change. If we don't use that placeholder value, then `alwaysRenderChild3`'s index will switch from 3 to 2 and vice-versa.

### Utility Functions

The below list demonstrate two utility functions you will likely use to reduce boilerplate:
- [whenElem](https://github.com/thomashoneyman/purescript-halogen-realworld/blob/v1.0.0/src/Component/HTML/Utils.purs#L27-L31)
- [maybeElem](https://github.com/thomashoneyman/purescript-halogen-realworld/blob/v1.0.0/src/Component/HTML/Utils.purs#L21-L25)

## A better way to assign multiple CSS classes

If we look at Halogen's code, we'll see that there are two ways to assign a class to an HTML element:
- single class: `HP.class_ $ ClassName "class-name"`
- multiple classes: HP.classes [ ClassName "class1", ClassName "class2" ]

As a result, when we want to added a lot of clases to a component (e.g. if we were using Tachyons to style our components using functional css), assigning multiple classes can get especially tedious and boilerplate-y:
```purescript
HP.classes
  [ ClassName "class1"
  , ClassName "class2"
  , ClassName "class3"
  , ClassName "class4"
  , ClassName "class5"
  , ClassName "class6"
  ]
```
After a while, one might choose to reduce some of that boilerplate by using `map`/`<$>` from `Functor:
```purescript
HP.classes $ ClassName <$>
  [ "class1"
  , "class2"
  , "class3"
  , "class4"
  , "class5"
  , "class6"
  ]
```
Fortunately, there's an even better way than the `Functor` approach (as I discovered after looking at the source code for `halogen-formless`). The trick is to use one `String` value that adds spaces between the classes:
```purescript
HP.class_ $ ClassName "class1 class2 class3 class4 class5 class6"
```
Since the `HP.class_ $ ClassName` part is boilerplate-y, we can abstract this into an easier function:
```purescript
class_ :: forall r t. String -> HH.IProp ( "class" :: String | r ) t
class_ = HP.class_ <<< ClassName

-- which allows us to now write:
HH.div
  [ class_ "class1 class2 class3 class4 class5 class6" ]
  [ HH.text "Much easier..." ]
```

## Styling Components

See [Thomas' comment in "Styling question"](https://github.com/thomashoneyman/purescript-halogen-realworld/issues/46#issuecomment-537170339)

## Rendering Valid/Invalid Input Data

If one reads through [Text Input not tracking state](https://discourse.purescript.org/t/text-input-not-tracking-state/1070/3) and, more specifically, [Gary's comment about using Either String ValidatedValue](https://discourse.purescript.org/t/text-input-not-tracking-state/1070/3), this can help with knowing how to deal with uncontrolled components.

## How to type empty queries, messages, inputs?

You can use `Void` and `Unit` as this project does

```purs
type MyQuery = Const Void
type MyInput = Unit
type MyMessages = Void
simpleChildComponent :: H.Component HH.HTML MyQuery () MyInput MyMessages Aff

-- and render using `unit` for values and `absurd` for functions

let index = unit -- or some integer
let input = unit -- on first render passed to `initialState` and to `receive` on subsequent renders if `input` is changed
let messageHandler = absurd
HH.slot _proxy index simpleChildComponent input messageHandler

```

it's also possible to use `forall` like this is done in halogen examples ([1](https://github.com/purescript-halogen/purescript-halogen/blob/bb715fe5c06ba3048f4d8b377ec842cd8cf37833/examples/higher-order-components/src/Harness.purs#L43), [2](https://github.com/purescript-halogen/purescript-halogen/blob/bb715fe5c06ba3048f4d8b377ec842cd8cf37833/examples/components-inputs/src/Container.purs#L39))

```purs
simpleChildComponent :: forall query input messages . H.Component HH.HTML query () input messages Aff

-- and render using `unit` for values and `absurd` or `const unit` for functions

let index = unit
let input = unit
let messageHandler = absurd
HH.slot _proxy index simpleChildComponent input messageHandler
```
