module ParentChildRelationships.ChildlikeComponents.MessageOnly where

import Prelude

-- Imports for lesson
import Control.Monad.State (get, modify_)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

-- Imports for scaffolding
import CSS (em, marginTop)
import Data.Array ((:))
import Data.Const (Const)
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen (ComponentHTML)
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.HTML.CSS as CSS
import Halogen.VDom.Driver (runUI)

type State = Int

data Action
  = Increment
  | Decrement
  | NotifyParentAboutState
  | NotifyParentMessage Message

type Message = String

textAndButtonComponent :: StateActionMessageComponent State Action
textAndButtonComponent =
  { initialState: 0
  , render
  , handleAction
  }

render :: StateAndActionRenderer State Action
render counterState =
  let
    yourMessage :: Message
    yourMessage = "Insert your message here"
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
          [ HE.onClick \_ -> Just $ NotifyParentMessage yourMessage ]
          [ HH.text $ "Log '" <> yourMessage <> "' to the page."]]
      ]


handleAction :: HandleAction_StateMessage State Action
handleAction = case _ of
  Increment -> do
    modify_ (\oldState -> oldState + 1)
  Decrement -> do
    modify_ (\oldState -> oldState - 1)
  NotifyParentAboutState -> do
    currentState <- get
    H.raise $ show currentState
  NotifyParentMessage message -> do
    H.raise $ message

main :: Effect Unit
main = runStateActionMessageComponent textAndButtonComponent

-- Scaffolded Code --

-- | Renders HTML that can respond to events by translating them
-- | into a value of the `action` that one uses to handle the event.
type DynamicHtml action = ComponentHTML action () Aff

-- | A function that uses the `state` type's value to render HTML
-- | with simple event-handling via the `action` type.
type StateAndActionRenderer state action = (state -> DynamicHtml action)

-- | When an `action` type's value is received, this function
-- | determines how to update the component (e.g. state updates) and
-- | can raise a `Message` to its parent component.
type HandleAction_StateMessage state action =
  (action -> H.HalogenM state action () Message Aff Unit)

-- | Combines all the code we need to define a simple componenet that supports
-- | state and simple event handlinGg
type StateActionMessageComponent state action =
  { initialState :: state
  , render :: StateAndActionRenderer state action
  , handleAction :: HandleAction_StateMessage state action
  }

-- | Runs a component that converts the value of the `input` type provided
-- | by the parent (an `Int`) to a value of the `state` type as the
-- | child's initial state value, which is used to render dynamic HTML
-- | with event handling via the `action` type.
runStateActionMessageComponent :: forall state action.
                               StateActionMessageComponent state action
                            -> Effect Unit
runStateActionMessageComponent childSpec = do
  runHalogenAff do
    body <- awaitBody
    runUI (parentComponent $ stateActionMessageComponent childSpec) unit body

type ChildComponentWithMessage = H.Component HH.HTML (Const Void) Unit Message Aff

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
stateActionMessageComponent :: forall state action.
                               StateActionMessageComponent state action
                            -> ChildComponentWithMessage
stateActionMessageComponent spec =
  H.mkComponent
    { initialState: \_ -> spec.initialState
    , render: spec.render
    , eval: H.mkEval $ H.defaultEval { handleAction = spec.handleAction }
    }

data ParentAction = AddMessage Message
type ParentState = Array Message
type ParentQuery = Const Void
type ParentComponent = H.Component HH.HTML ParentQuery Unit Void Aff

_child :: SProxy "child"
_child = SProxy

type NoQuery_Message {- index -}
  = H.Slot (Const Void) Message {- index -}
type ChildSlots = ( child :: NoQuery_Message Unit )

parentComponent :: ChildComponentWithMessage -> ParentComponent
parentComponent childComp =
    H.mkComponent
      { initialState: const []
      , render: parentHtml
      , eval: H.mkEval $ H.defaultEval { handleAction = handleParentAction }
      }
  where
    parentHtml :: ParentState -> H.ComponentHTML ParentAction ChildSlots Aff
    parentHtml logArray =
      HH.div_
        [ HH.div_
          [ HH.text "Use your child component's html to send messages to \
                    \the parent. It will render the message below them all"
          ]
        , HH.slot _child unit childComp unit (\msg -> Just $ AddMessage msg)
        , HH.div
          [ CSS.style do
            marginTop $ em 3.0
          ]
          (logArray <#> \log ->
            HH.div_ [ HH.text $ "Message received: " <> log]
          )
        ]

    handleParentAction
      :: ParentAction
      -> H.HalogenM ParentState ParentAction ChildSlots Void Aff Unit
    handleParentAction (AddMessage msg) = do
      -- add the message to the front of the array
      modify_ (\array -> msg : array)
