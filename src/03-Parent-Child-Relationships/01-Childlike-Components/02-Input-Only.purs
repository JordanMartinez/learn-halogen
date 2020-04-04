module ParentChildRelationships.ChildlikeComponents.InputOnly where

import Prelude

-- Imports for lesson
import Control.Monad.State (modify_)
import Data.Maybe (Maybe(..))
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

-- Imports for scaffolding
import Control.Monad.Rec.Class (forever)
import Data.Const (Const)
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), delay, forkAff)
import Effect.Random (randomInt)
import Halogen (liftEffect, put)
import Halogen (ComponentHTML)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)

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

-- Scaffolded Code --

-- | Renders HTML that can respond to events by translating them
-- | into a value of the `action` that one uses to handle the event.
type DynamicHtml action = ComponentHTML action () Aff

-- | A function that uses the `state` type's value to render HTML
-- | with simple event-handling via the `action` type.
type StateAndActionRenderer state action = (state -> DynamicHtml action)

-- | When an `action` type's value is received, this function
-- | determines how to update the component (e.g. state updates).
type HandleSimpleAction state action =
  (action -> H.HalogenM state action () Void Aff Unit)

-- | A function that converts the Input type's value (an `Int` passed in from
-- | the parent) into a value of the child component's `state` type.
type ConvertParentInputToChildInitialState state = (Int -> state)

-- | Combines all the code we need to define a simple componenet that supports
-- | state and simple event handling
type StateActionIntInputComponent state action =
  { initialState :: ConvertParentInputToChildInitialState state
  , render :: StateAndActionRenderer state action
  , handleAction :: HandleSimpleAction state action
  , receive :: Int -> Maybe action
  }

-- | Runs a component that converts the value of the `input` type provided
-- | by the parent (an `Int`) to a value of the `state` type as the
-- | child's initial state value, which is used render dynamic HTML
-- | with event handling via the `action` type.
runStateActionInputComponent :: forall state action.
                               StateActionIntInputComponent state action
                            -> Effect Unit
runStateActionInputComponent childSpec = do
  runHalogenAff do
    body <- awaitBody
    firstIntVal <- liftEffect $ randomInt 1 200
    io <- runUI (parentComponent $ stateActionInputComponent childSpec) firstIntVal body

    forkAff do
      forever do
        delay $ Milliseconds 2000.0
        nextIntVal <- liftEffect $ randomInt 1 200
        io.query $ H.tell $ SetState nextIntVal

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
stateActionInputComponent :: forall state action.
                               StateActionIntInputComponent state action
                            -> H.Component HH.HTML (Const Void) Int Void Aff
stateActionInputComponent spec =
  H.mkComponent
    { initialState: \input -> spec.initialState input
    , render: spec.render
    , eval: H.mkEval $ H.defaultEval { handleAction = spec.handleAction
                                     , receive = spec.receive
                                     }
    }

type ChildComponent = H.Component HH.HTML (Const Void) Int Void Aff

type ParentState = Int
data ParentQuery a = SetState Int a
type ParentAction = Void
type ParentComponent = H.Component HH.HTML ParentQuery Int Void Aff

_child :: SProxy "child"
_child = SProxy

parentComponent :: ChildComponent -> ParentComponent
parentComponent childComp =
    H.mkComponent
      { initialState: identity
      , render: parentHtml
      , eval: H.mkEval $ H.defaultEval { handleQuery = handleQuery
                                       }
      }
  where
    parentHtml :: ParentState -> H.ComponentHTML ParentAction (child :: H.Slot (Const Void) Void Unit) Aff
    parentHtml latestInt =
      HH.div_
        [ HH.slot _child unit childComp latestInt (const Nothing) ]

    handleQuery :: forall a. ParentQuery a
                -> H.HalogenM ParentState ParentAction (child :: H.Slot (Const Void) Void Unit) Void Aff (Maybe a)
    handleQuery (SetState nextInt next) = do
      put nextInt
      pure $ Just next
