module StaticHTML.StaticHTMLUnscaffolded where

module Main where

import Prelude 
import Effect (Effect)
import Effect.Aff (Aff)
import Data.Const (Const)

import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Halogen.HTML as HH
import Halogen.HTML (HTML)

type Query = Const Unit
type Input = Unit
type State = Unit
type Output = Void
data Action = Unit

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

render :: State -> HTML (H.ComponentSlot HTML () Aff Action) Action
render _ =
  staticHtml

handleAction :: Action -> H.HalogenM State Action () Void Aff Unit
handleAction _ = pure unit

initialState :: State
initialState = unit

mkInitialState :: Input -> State
mkInitialState _ = initialState

component :: H.Component HH.HTML Query Input Output Aff
component =
  H.mkComponent 
    { initialState: mkInitialState
    , render: staticHtml
    , eval: H.mkEval $ H.defaultEval
    }

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    runUI component unit body
  
