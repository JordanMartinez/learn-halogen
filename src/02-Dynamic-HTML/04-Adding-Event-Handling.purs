module DynamicHtml.AddingEventHandling where

import Prelude

import Control.Monad.State (get, put)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Scaffolding.DynamicRenderer.StateAndEval (HandleSimpleAction, StateAndActionRenderer, runStateAndActionComponent)

-- | Our state type. Either the button is 'on' or 'off'.
type State = Boolean

-- | Our action type. It indicates the button's state should be inverted
data Action = Toggle

-- | Shows how to add event handling.
toggleButton :: StateAndActionRenderer State Action
toggleButton isOn =
  let toggleLabel = if isOn then "ON" else "OFF"
  in
    HH.button
      [ HE.onClick \_ -> Just Toggle ]
      [ HH.text $ "The button is " <> toggleLabel ]

-- | Shows how to use actions to update the component's state
handleAction :: HandleSimpleAction State Action
handleAction = case _ of
  Toggle -> do
    oldState <- get
    let newState = not oldState
    put newState

    -- or, with one line, we could use
    -- modify_ \oldState -> not oldState


-- Now we can run the code

main :: Effect Unit
main =
  runStateAndActionComponent
    { initialState: false
    , render: toggleButton
    , handleAction: handleAction
    }
