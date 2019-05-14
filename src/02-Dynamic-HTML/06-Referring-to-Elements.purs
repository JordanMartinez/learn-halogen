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

-- | Our state type. Either the button is 'on' or 'off'.
type State = Boolean

-- | Our action type. It indicates the button's state should be inverted
data Action = PrintExample

-- | Shows how to add event handling.
renderExample :: StateAndActionRenderer State Action
renderExample _ =
  HH.button
    [ HE.onClick \_ -> Just PrintExample
    , HP.ref (H.RefLabel "my-button")
    ]
    [ HH.text $ "Click to print our example to the console." ]

-- | Shows how to use actions to update the component's state
handleAction :: HandleSimpleAction State Action
handleAction = case _ of
  PrintExample -> do
    H.getHTMLElementRef (H.RefLabel "my-button") >>= traverse_ \element -> do
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
