# Adding State

Hopefully, you feel comfortable working with Halogen's HTML DSL now.

Now, we'll change what HTML gets rendered based on the current state. To reduce the "code noise," we will not be using the code from previous examples. Rather, we'll be starting with a fresh example.

Refer to the below flowchart to understand what we're doing here.

![StateOnlyRenderer.svg ](../../assets/visuals/StateOnlyRenderer.svg)

```purescript
import Halogen.HTML as HH

type State = Int

stateOnlyStaticHtml :: State -> HH.ComponentHTML
stateOnlyStaticHtml intValue =
  HH.div_ [ HH.text $ show intValue ]
```

Now look at the next file.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m DynamicHtml.AddingState -t assets/dynamic-html/adding-state.js
parcel serve assets/dynamic-html/adding-state.html -o adding-state--parcelified.html --open
```
