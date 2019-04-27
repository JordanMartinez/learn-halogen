# Adding Properties

## The `HH.value_` Pattern

It's now time to explain why `div_` had that `_` suffix after it. It means there are no properties, css, or event handlers that we wish to add to that HTML tag. Looking at this in code...
```purescript
-- This syntax
HH.elementName_ [children]
-- is an abbreviation for
HH.elementName [] [ children]

-- For example
HH.div_ [ HH.text "some text!" ]
-- is an abbreviation for
HH.div [] [ HH.text "some text!" ]
-- as in, "the 'div' tag has no properties, css, or event handlers"

-- The real syntax is
HH.elementName [ {- properties, css, event_handlers -} ] [ children ]
```

## Adding Properties

Now, we will add properties to our static HTML. We'll convert the following HTML into purescript:
```html
<div id="top-div">
    <div class="special-div">
        <span class="class1 class2 class3">This is text in a span!</span>
    <div>
    <button type="button">You can click me, but I don't do anything</button>
</div>
```

Understanding this, we can now use Halogen's DSL for HTML properties via this syntax, `HP.property value`. There's a few things to be aware of when using this syntax.
- When property names are the same as keywords in Purescript (e.g. the `class` is a keyword), they often have the `_` suffix added to distinguish them from those keywords.
- To prevent you from constructing invalid data, some `HP.property` functions use newtypes to clarify what values you are creating. It may be necessary to write `HP.property $ DataConstructor value`.
```purescript
import Halogen.HTML as HH
import Scaffolding.StaticRenderer (StaticHTML)

-- new imports
import Halogen.HTML (ClassName(..))
import Halogen.HTML.Properties (ButtonType(..))

staticHtmlWithProps :: StaticHtml
staticHtmlWithProps =
  HH.div
    [ HP.id_ "top-div" ]
    [ HH.div
      [ HP.class_ $ ClassName "special-div" ]
      [ HH.span
        [ HP.classes [ ClassName "class1", ClassName "class2", ClassName "class3" ] ]
        [ HH.text "This is text in a span!" ]
      ]
    , HH.button
      [ HP.type_ ButtonButton ]
      [ HH.text "You can click me, but I don't do anything." ]
    ]

```

Now look at the next file.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m StaticHTML.AddingProperties -t assets/static-html/adding-properties.js
parcel serve assets/static-html/adding-properties.html -o adding-properties--parcelified.html --open
```
