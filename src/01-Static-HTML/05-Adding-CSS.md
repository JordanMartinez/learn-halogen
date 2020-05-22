# Adding CSS

## Explaining how `purescript-css` and `purescript-halogen-css` work together

Purescript has a library called [`purescript-css`](https://pursuit.purescript.org/packages/purescript-css/4.0.0) that enables one to add correctly-typed inline CSS. However, Halogen cannot use the library as is. Rather, we must use the adapter library, [`purescript-halogen-css`](https://pursuit.purescript.org/packages/purescript-halogen-css/6.0.0).

There's a few things to be aware of with the syntax:
- All of the `key` and `value` functions/values are from `purescript-css`, so look there for CSS types rather than `purescript-halogen-css`.
- Similar to our properties, some CSS will require a syntax like this--`key $ DataConstructor value`--to prevent you from constructing invalid inline css.

### CSS' single and multi key-pair syntax

When we have one key-value pair, we use this syntax, `CSS.style $ key value`. When we wish to have multiple key-value pairs, we must use the monadic "do notation" syntax:
```purescript
import Halogen.HTML.CSS as CSS

CSS.style $ do
    key value
    key value
    key value
```

When we have many pairs, this style adds many lines and makes it harder to read our code. So, one way for dealing with this is putting the code in a `where` clause:
```purescript
renderer =
    HH.div
      [ HP.id_ "some-div"
      , cssStyleForSomeDiv
      ]
      [ HH.text "some text" ]
  where
    cssStyleForSomeDiv = CSS.style do
      key1 value1
      key2 value2
      key3 value3
      key4 value4
      key5 value5
```

## Adding CSS

Now, we'll render the following HTML that includes CSS in Halogen:
```html
<div id="top-div" style="background-color: red;">
    <div class="special-div">
        <span class="class1 class2 class3" style="font-size: 20px; background-color: orange;">This is text in a span!</span>
    <div>
    <button type="button">You can click me, but I don't do anything</button>
</div>
```

```purescript
-- purescript-halogen-css
import Halogen.HTML.CSS as CSS

-- purescript-css
import CSS (backgroundColor, fontSize, orange, px, red)

staticHtmlWitPropsAndCss :: StaticHtml
staticHtmlWitPropsAndCss =
  HH.div
    [ HP.id_ "top-div", CSS.style $ backgroundColor red ]
    [ HH.div [ HP.class_ $ ClassName "special-div" ]
      [ HH.span
        [ HP.classes [ ClassName "class1", ClassName "class2", ClassName "class3" ]
        , CSS.style do
            fontSize $ px 20.0
            backgroundColor orange
        ]
        [ HH.text "This is text in a span!" ]
      ]
    , HH.button
        [ HP.type_ "button" ]
        [ HH.text "You can click me, but I don't do anything." ]
    ]
```

Now look at the next file.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m StaticHTML.AddingCSS -t assets/static-html/adding-css.js
parcel serve assets/static-html/adding-css.html -o adding-css--parcelified.html --open
```
