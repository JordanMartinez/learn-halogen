module StaticHTML.AddingCSS where

import Prelude

import CSS (backgroundColor, fontSize, orange, px, red)
import Effect (Effect)
import Halogen.HTML (ClassName(..))
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Properties (ButtonType(..))
import Halogen.HTML.Properties as HP
import Scaffolding.StaticRenderer (StaticRenderer, runStaticComponent)

main :: Effect Unit
main = runStaticComponent renderStaticHtmlWithProps

-- | Shows how to use Halogen VDOM DSL to render static HTML
-- | that also includes properties
renderStaticHtmlWithProps :: StaticRenderer
renderStaticHtmlWithProps =
  HH.div
    [ HP.id_ "top-div", CSS.style $ backgroundColor red ]
    [ HH.div
      [ HP.class_ $ ClassName "special-div" ]
      [ HH.span
        [ HP.classes [ ClassName "class1", ClassName "class2", ClassName "class3" ]
        , CSS.style do
            fontSize $ px 20.0
            backgroundColor orange
        ]
        [ HH.text "This is text in a span!" ]
      ]
    , HH.button
      [ HP.type_ ButtonButton ]
      [ HH.text "You can click me, but I don't do anything." ]
    ]
