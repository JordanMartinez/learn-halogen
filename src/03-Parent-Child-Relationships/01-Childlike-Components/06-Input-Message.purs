module ParentChildRelationships.ChildlikeComponents.InputMessage where

import Prelude

import CSS (em, marginTop)
import Control.Monad.State (get, modify_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE
import Scaffolding.DynamicRenderer.StateAndEval (StateAndActionRenderer)
import Scaffolding.ParentChildRelationships.ChildlikeComponents.InputMessageRenderer (StateActionIntInputStringMessageComponent, runStateActionIntInputStringMessageComponent)
import Scaffolding.ParentChildRenderer.ChildlikeComponents.InputOnlyRenderer (ConvertParentInputToChildInitialState)
import Scaffolding.ParentChildRenderer.ChildlikeComponents.MessageOnlyRenderer (HandleAction_StateStringMessage)

main :: Effect Unit
main = runStateActionIntInputStringMessageComponent textAndButtonComponent

type State = { intValue :: Int
             , toggleState :: Boolean
             , counter :: Int
             }

data Action
  -- From Input-Only
  = ToggleButton
  | ReceiveParentInput Int
  -- From Message-Only
  | IncrementCounter
  | DecrementCounter
  | NotifyParentAboutCounterState
  | NotifyParentTextMessage String

type Message = String

textAndButtonComponent :: StateActionIntInputStringMessageComponent State Action
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
  , counter: 0
  }

render :: StateAndActionRenderer State Action
render state =
  HH.div_
    [ HH.div
      [ CSS.style do
        marginTop $ em 3.0
      ]
      [ HH.text "The input part" ]
    , HH.div_
      [ HH.text $ "The next integer is: " <> show state.intValue
      , HH.div_
        [ HH.button
          [ HE.onClick \_ -> Just ToggleButton ]
          [ HH.text $ "Button state: " <> show state.toggleState ]
        ]
      ]

    , HH.div
      [ CSS.style do
        marginTop $ em 3.0
      ]
      [ HH.text "The message part" ]
    , HH.div_
        [ HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just NotifyParentAboutCounterState ]
            [ HH.text "Log current counter value" ]
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just DecrementCounter ]
            [ HH.text $ "-"]
          , HH.button
            [ HE.onClick \_ -> Just IncrementCounter ]
            [ HH.text $ "+"]
          ]
        , HH.div_ [ HH.text $ show state.counter ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just $ NotifyParentTextMessage yourMessage ]
            [ HH.text $ "Log '" <> yourMessage <> "' to the page."]]
        ]
      ]
  where
    yourMessage = "Insert your message here"

receiveNextParentInt :: Int -> Maybe Action
receiveNextParentInt nextInputIntVal = Just $ ReceiveParentInput nextInputIntVal

handleAction :: HandleAction_StateStringMessage State Action
handleAction = case _ of
  ToggleButton -> do
    modify_ (\oldState -> oldState { toggleState = not oldState.toggleState })
  ReceiveParentInput input -> do
    modify_ (\oldState -> oldState { intValue = input })
  IncrementCounter -> do
    modify_ (\oldState -> oldState { counter = oldState.counter + 1 })
  DecrementCounter -> do
    modify_ (\oldState -> oldState { counter = oldState.counter - 1 })
  NotifyParentAboutCounterState -> do
    currentState <- get
    H.raise $ show currentState.counter
  NotifyParentTextMessage message -> do
    H.raise $ message
