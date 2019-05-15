module DynamicHtml.ReferringToElements where

import Prelude

import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Halogen (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Events as HE
import Scaffolding.DynamicRenderer.StateAndEval (HandleSimpleAction, StateAndActionRenderer, runStateAndActionComponent)

type State = Boolean
data Action = PrintExample

renderExample :: StateAndActionRenderer State Action
renderExample _ =
  HH.button
    [ HE.onClick \_ -> Just PrintExample
    -- here, we label this button as 'my-button', so we can refer to it later
    , HP.ref (H.RefLabel "my-button")
    ]
    [ HH.text $ "Click to print our example to the console." ]

handleAction :: HandleSimpleAction State Action
handleAction = case _ of
  PrintExample -> do
    -- Here, we use this reference to do something with the element
    H.getHTMLElementRef (H.RefLabel "my-button") >>= traverse_ \element -> do
      -- in this situation, we'll just state that the element exists
      -- and could be used here
      liftEffect $ log "We can now do something directly to the \
                         \button HTML element."

-- Now we can run the code

main :: Effect Unit
main =
  runStateAndActionComponent
    { initialState: false
    , render: renderExample
    , handleAction: handleAction
    }
