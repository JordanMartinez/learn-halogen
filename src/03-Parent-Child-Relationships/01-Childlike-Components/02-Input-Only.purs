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
import Effect.Aff (Aff, Milliseconds(..), delay, forkAff, launchAff_)
import Effect.Random (randomInt)
import Halogen (liftEffect, put)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.VDom.Driver (runUI)

type State = { intValue :: Int
             , toggleState :: Boolean
             }

-- | Our component can either toggle its `toggleState`
-- | or change its `intValue`
data Action
  = Toggle
  | ReceiveParentInput Int

childComponent :: ChildComponent
childComponent =
    H.mkComponent
      { initialState: inputToState
      , render: render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , receive = receiveNextParentInt
                                       }
      }
  where

    -- | A function that converts the Input type's value (an `Int` passed in from
    -- | the parent) into a value of the child component's `State` type.
    inputToState :: Int -> State
    inputToState input =
      { intValue: input
      , toggleState: false
      }

    -- | A function that renders HTML from the component's state.
    -- | The HTML is dynamic and can respond to events by translating them into an `Action`.
    -- | These `Action`s are then consumed by `handleAction` to modify the component's state.
    render :: State -> H.ComponentHTML Action () Aff
    render state =
      HH.div_
        [ HH.text $ "The next integer is: " <> show state.intValue
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just Toggle ] -- Convert `onClick` event to `Toggle` `Action`
            [ HH.text $ "Button state: " <> show state.toggleState ]
          ]
        ]

    -- | When an `Action` type's value is received, this function
    -- | determines how to update the component (e.g. state updates).
    handleAction :: Action -> HandleActionResult
    handleAction = case _ of
      Toggle -> do
        modify_ (\oldState -> oldState { toggleState = not oldState.toggleState })
      ReceiveParentInput input -> do
        modify_ (\oldState -> oldState { intValue = input })

    -- | Receives "something" from parent, and maybe converts this to an `Action`.
    -- | In this case we always create an action from the incomming Int
    receiveNextParentInt :: Int -> Maybe Action
    receiveNextParentInt nextInputIntVal = Just $ ReceiveParentInput nextInputIntVal

type HandleActionResult = H.HalogenM -- (ignore) Halogen component eval effect monad
                            State      -- state: state to be updated
                            Action     -- action: actions handled
                            ()         -- (ignore) slots:
                            Void       -- (ignore) output:
                            Aff        -- (ignore) m: effect monad
                            Unit       -- (ignore) a: ???

type ChildComponent = H.Component -- Halogen component
                        HH.HTML      -- (ignore) surface: what to render
                        (Const Unit) -- (ignore) query: requests that can be made
                        Int          -- input: values that can be recieved when parent renders
                        Void         -- (ignore) output: messages that can be raised
                        Aff          -- (ignore) m: effect monad

type ParentState = Int
data ParentQuery a = SetState Int a
type ParentAction = Void

type ParentComponent = H.Component -- Halogen component
                         HH.HTML      -- (ignore) surface: what to render
                         ParentQuery  -- query: requests that can be made
                         Int          -- input: values that can be recieved when parent renders
                         Void         -- (ignore) output: messages that can be raised
                         Aff          -- (ignore) m: effect monad

_child :: SProxy "child"
_child = SProxy

parentComponent :: ParentComponent
parentComponent =
    H.mkComponent
      { initialState: identity -- take input as initial state
      , render: parentHtml
      , eval: H.mkEval $ H.defaultEval { handleQuery = handleQuery
                                       }
      }
  where
    parentHtml :: ParentState -> H.ComponentHTML ParentAction (child :: H.Slot (Const Unit) Void Unit) Aff
    parentHtml latestInt =
      HH.div_
        [ HH.slot _child unit childComponent latestInt (const Nothing) ]

    handleQuery :: forall a. ParentQuery a
                -> H.HalogenM ParentState ParentAction (child :: H.Slot (Const Unit) Void Unit) Void Aff (Maybe a)
    handleQuery (SetState nextInt next) = do
      put nextInt
      pure $ Just next

-- | Runs a component that converts the value of the `input` type provided
-- | by the parent (an `Int`) to a value of the `state` type as the
-- | child's initial state value, which is used render dynamic HTML
-- | with event handling via the `action` type.
main :: Effect Unit
main = do
  launchAff_ do
    body <- awaitBody
    firstIntVal <- liftEffect $ randomInt 1 200
    io <- runUI parentComponent firstIntVal body

    forkAff do
      forever do
        delay $ Milliseconds 2000.0
        nextIntVal <- liftEffect $ randomInt 1 200
        io.query $ H.tell $ SetState nextIntVal

