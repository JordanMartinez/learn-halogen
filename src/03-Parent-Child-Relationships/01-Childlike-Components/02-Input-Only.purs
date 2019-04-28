module ParentChildRelationships.ChildlikeComponents.InputOnly where

import Prelude

import Control.Monad.State (modify_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Scaffolding.DynamicRenderer.StateAndEval (StateAndActionRenderer, HandleSimpleAction)
import Scaffolding.ParentChildRenderer.ChildlikeComponents.InputOnlyRenderer (runStateActionInputComponent, ConvertParentInputToChildInitialState, StateActionIntInputComponent)

main :: Effect Unit
main = runStateActionInputComponent textAndButtonComponent

type State = { intValue :: Int
             , toggleState :: Boolean
             }

-- | Our component can either toggle its `toggleState`
-- | or change its `intValue`
data Action
  = Toggle
  | ReceiveParentInput Int

textAndButtonComponent :: StateActionIntInputComponent State Action
textAndButtonComponent =
  { initialState: intToChildInitialState
  , render
  , handleAction
  , receive: receiveNextParentInt
  }

intToChildInitialState :: ConvertParentInputToChildInitialState State
intToChildInitialState input =
  { intValue: input
  , toggleState: false
  }

render :: StateAndActionRenderer State Action
render state =
  HH.div_
    [ HH.text $ "The next integer is: " <> show state.intValue
    , HH.div_
      [ HH.button
        [ HE.onClick \_ -> Just Toggle ]
        [ HH.text $ "Button state: " <> show state.toggleState ]
      ]
    ]

receiveNextParentInt :: Int -> Maybe Action
receiveNextParentInt nextInputIntVal = Just $ ReceiveParentInput nextInputIntVal

handleAction :: HandleSimpleAction State Action
handleAction = case _ of
  Toggle -> do
    modify_ (\oldState -> oldState { toggleState = not oldState.toggleState })
  ReceiveParentInput input -> do
    modify_ (\oldState -> oldState { intValue = input })
