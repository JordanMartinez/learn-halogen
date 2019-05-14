# Referring to Rendered HTML Elements

Sometimes, in the monadic code, one wants to refer to one of the HTML elements that are rendered in the `render` function.

We can refer to such elements by doing two things:
1. Adding a `HP.ref (H.RefLabel "label-name")` to the element in question in our `render` function
2. Reference that element by using `H.getHTMLElementRef (H.RefLabel "label-name")`

## Idiomatically using `H.getHTMLElementRef`

`H.getHTMLElementRef` returns `Maybe HTMLElement`. To deal with the `Maybe` type, we could write that one of two ways.

The first way is a longer and more verbose way:
```purescript
ActionValue -> do
  maybeElement <- H.getHTMLElementRef (H.RefLabel "my-div")
  case maybeElement of
    Nothing -> pure unit
    Just htmlElement -> -- do something with element
```

The second way is the shorter and more idiomatic way:
```purescript
ActionValue -> do
  H.getHTMLElementRef (H.RefLabel "my-div") >>= traverse_ \element -> do
    -- do something with the element
```

## Full Example

For example,

```purescript
import Control.Monad.State (get, put)
import Halogen as H
import Halogen.HTML.Properties as HP

render :: State -> DynamicHtml action
render state =
  HH.div
    [ HE.onClick \_ -> Just DoSomething
    , HP.ref (H.RefLabel "my-div")
    ]
    [ HH.text "A div with text" ]

handleAction :: HandleSimpleAction State Action
handleAction = case _ of
  DoSomething -> do
    H.getHTMLElementRef (H.RefLabel "my-div")
    oldState <- get
    let newState = not oldState
    put newState
```

Now look at the next file for the full example.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m DynamicHtml.ReferringToElements -t assets/dynamic-html/referring-to-elements.js
parcel serve assets/dynamic-html/referring-to-elements.html -o referring-to-elements--parcelified.html --open
```
