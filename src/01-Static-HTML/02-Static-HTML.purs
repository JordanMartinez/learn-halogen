module StaticHTML.StaticHTML where

import Prelude

import Effect (Effect)
import Halogen.HTML as HH
import Scaffolding.StaticRenderer (StaticRenderer, runStaticComponent)

main :: Effect Unit
main = runStaticComponent renderStaticHtml

-- | Shows how to use Halogen VDOM DSL to render HTML
renderStaticHtml :: StaticRenderer
renderStaticHtml =
  HH.div_
    -- The 'div' tag takes an Array of children
    [ HH.div_
      [ HH.span_
        -- as does the `span` tag
        [ HH.text "This is text in a span!" ]
      ]
    , HH.button_
      [ HH.text "You can click me, but I don't do anything." ]
    ]
