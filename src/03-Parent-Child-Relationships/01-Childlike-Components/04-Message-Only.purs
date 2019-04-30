module ParentChildRelationships.ChildlikeComponents.MessageOnly where


import Prelude

import Control.Monad.State (get, modify_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Scaffolding.DynamicRenderer.StateAndEval (StateAndActionRenderer)
import Scaffolding.ParentChildRenderer.ChildlikeComponents.MessageOnlyRenderer (StateActionMessageComponent, HandleAction_StateStringMessage, runStateActionMessageComponent)

main :: Effect Unit
main = runStateActionMessageComponent textAndButtonComponent

type State = Int

data Action
  = Increment
  | Decrement
  | NotifyParentAboutState
  | NotifyParentTextMessage String

type Message = String

textAndButtonComponent :: StateActionMessageComponent State Action
textAndButtonComponent =
  { initialState: 0
  , render
  , handleAction
  }

render :: StateAndActionRenderer State Action
render counterState =
  let yourMessage = "Insert your message here"
  in
    HH.div_
      [ HH.div_
        [ HH.button
          [ HE.onClick \_ -> Just NotifyParentAboutState ]
          [ HH.text "Log current counter value" ]
        ]
      , HH.div_
        [ HH.button
          [ HE.onClick \_ -> Just Decrement ]
          [ HH.text $ "-"]
        , HH.button
          [ HE.onClick \_ -> Just Increment ]
          [ HH.text $ "+"]
        ]
      , HH.div_ [ HH.text $ show counterState ]
      , HH.div_
        [ HH.button
          [ HE.onClick \_ -> Just $ NotifyParentTextMessage yourMessage ]
          [ HH.text $ "Log '" <> yourMessage <> "' to the page."]]
      ]


handleAction :: HandleAction_StateStringMessage State Action
handleAction = case _ of
  Increment -> do
    modify_ (\oldState -> oldState + 1)
  Decrement -> do
    modify_ (\oldState -> oldState - 1)
  NotifyParentAboutState -> do
    currentState <- get
    H.raise $ show currentState
  NotifyParentTextMessage message -> do
    H.raise $ message
