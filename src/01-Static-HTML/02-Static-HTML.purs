module StaticHTML.StaticHTML where

-- Imports for lesson

import Prelude

import Data.Const (Const)
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

-- | Shows how to use Halogen VDOM DSL to render HTML without properties or CSS
staticHtml :: StaticHTML
staticHtml =
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

--- Scaffolded code below ---

main :: Effect Unit
main = runHalogenAff do
  body <- awaitBody
  runUI (staticComponent staticHtml) unit body

-- | HTML written in Purescript via Halogen's HTML DSL
-- | that is always rendered the same and does not include any event handling.
type StaticHTML = H.ComponentHTML Unit () Aff

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
staticComponent :: StaticHTML
                -> H.Component HH.HTML (Const Void) Unit Void Aff
staticComponent renderHtml =
  H.mkComponent
    { initialState: const unit
    , render: \_ -> renderHtml
    , eval: H.mkEval H.defaultEval
    }
