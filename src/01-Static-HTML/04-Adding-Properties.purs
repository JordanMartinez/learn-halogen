module StaticHTML.AddingProperties where

import Prelude

import Effect (Effect)
import Halogen.HTML (ClassName(..))
import Halogen.HTML as HH
import Halogen.HTML.Properties (ButtonType(..))
import Halogen.HTML.Properties as HP
import Scaffolding.StaticRenderer (runStaticHtml, StaticHTML)

main :: Effect Unit
main = runStaticHtml staticHtmlWithProps

-- | Shows how to use Halogen VDOM DSL to render static HTML
-- | that also includes properties
staticHtmlWithProps :: StaticHTML
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
