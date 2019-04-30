module Scaffolding.ParentChildRenderer.ChildlikeComponents.MessageOnlyRenderer
  ( runStateActionMessageComponent
  , HandleAction_StateStringMessage
  , StateActionMessageComponent
  )
  where

import Prelude

import CSS (em, marginTop)
import Control.Monad.State (modify_)
import Data.Array ((:))
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.VDom.Driver (runUI)
import Scaffolding.DynamicRenderer.StateAndEval (StateAndActionRenderer)

-- | When an `action` type's value is received, this function
-- | determines how to update the component (e.g. state updates) and
-- | can raise a `String` message to its parent component.
type HandleAction_StateStringMessage state action =
  (action -> H.HalogenM state action () String Aff Unit)

-- | Combines all the code we need to define a simple componenet that supports
-- | state and simple event handlinGg
type StateActionMessageComponent state action =
  { initialState :: state
  , render :: StateAndActionRenderer state action
  , handleAction :: HandleAction_StateStringMessage state action
  }

-- | Runs a component that converts the value of the `input` type provided
-- | by the parent (an `Int`) to a value of the `state` type as the
-- | child's initial state value, which is used render dynamic HTML
-- | with event handling via the `action` type.
runStateActionMessageComponent :: forall state action.
                               StateActionMessageComponent state action
                            -> Effect Unit
runStateActionMessageComponent childSpec = do
  launchAff_ do
    body <- awaitBody
    runUI (parentComponent $ stateActionMessageComponent childSpec) unit body

type ChildComponentWithStringMessage = H.Component HH.HTML (Const Unit) Unit String Aff

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
stateActionMessageComponent :: forall state action.
                               StateActionMessageComponent state action
                            -> ChildComponentWithStringMessage
stateActionMessageComponent spec =
  H.mkComponent
    { initialState: \_ -> spec.initialState
    , render: spec.render
    , eval: H.mkEval $ H.defaultEval { handleAction = spec.handleAction }
    }

data ParentAction = AddMessage String
type ParentState = Array String
type ParentQuery = Const Unit
type ParentComponent = H.Component HH.HTML ParentQuery Unit Void Aff

_child = SProxy :: SProxy "child"

type NoMessageNoQuery = H.Slot (Const Unit) Void
type ChildSlots = ( child :: NoMessageNoQuery )

parentComponent :: ChildComponentWithStringMessage -> ParentComponent
parentComponent childComp =
    H.mkComponent
      { initialState: const []
      , render: parentHtml
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       }
      }
  where
    parentHtml :: ParentState -> H.ComponentHTML ParentAction _ Aff
    parentHtml logArray =
      HH.div_
        [ HH.div_
          [ HH.text "Use your child component's html to send messages to \
                    \ the parent. It will render the message below them all"
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

    handleAction :: ParentAction -> H.HalogenM ParentState ParentAction _ Void Aff Unit
    handleAction (AddMessage msg) = do
      -- add the message to the front of the array
      modify_ (\array -> msg : array)
