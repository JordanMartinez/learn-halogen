module ParentChildRelationships.ParentlikeComponents.MultipleChildren.RevealingChildSlots where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..), maybe)
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Random (randomInt)
import Halogen (get, liftEffect, put)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Scaffolding.ParentChildRenderer.ParentlikeComponents.MultipleChildrenRevealSlotsRenderer (runRevealSlotComponent)
import Web.HTML (window)
import Web.HTML.Window (alert)

main :: Effect Unit
main = runRevealSlotComponent parentComponent

-- | In other words, "This component has no 'real' state." We use Unit
-- | instead of Void because we still have to pass a value into a function
type StateType = Unit
-- | In other words, "This parent component can get and set the child's state."
data ParentAction
  = GetInfoFromChild
  | ChangeChildState
-- | In other words, "This component has no query."
type Query = Const Void
-- | In other words, "This component receives no 'real' input." We use Unit
-- | instead of Void because we still have to pass a value into a function
type Input = Unit
-- | In other words, "This component does not raise any messages."
type Message = Void

-- | Our single child uses the ChildQuery and ChildMessage types (defined
-- | after our parent component in this file)
-- | While we don't have multiple children here, we are using the
-- | `Int` type as our slot index type.
type ChildSlots = ( child :: H.Slot ChildQuery ChildMessage Int )

parentComponent :: H.Component HH.HTML Query Input Message Aff
parentComponent =
    H.mkComponent
      { initialState
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    initialState :: Input -> StateType
    initialState _ = unit

    _childLabel :: SProxy "child"
    _childLabel = SProxy

    childIndex :: Int
    childIndex = 1

    childInput :: Unit
    childInput = unit

    ignoreChildMessage :: ChildMessage -> Maybe ParentAction
    ignoreChildMessage _ = Nothing

    render :: StateType -> H.ComponentHTML ParentAction ChildSlots Aff
    render _ =
      HH.div_
        [ HH.div_
          [ HH.text "The parent's text" ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just GetInfoFromChild ]
            [ HH.text "get child state" ]
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just ChangeChildState ]
            [ HH.text "set child state" ]
          ]
        , HH.slot _childLabel childIndex childComponent childInput ignoreChildMessage
        ]

    handleAction :: ParentAction -> H.HalogenM StateType ParentAction ChildSlots Message Aff Unit
    handleAction = case _ of
      GetInfoFromChild -> do
        -- Here we show how to make a Request-type query
        childState <- H.query _childLabel childIndex $ H.request GetState

        let cState = maybe "<unknown>" show childState
        liftEffect do
          window_ <- window
          alert ("Child state was: " <> cState) window_
      ChangeChildState -> do
        intVal <- liftEffect $ randomInt 1 200

        -- Here we show how to make a Tell-type query
        void $ H.query _childLabel childIndex $ H.tell $ SetState intVal


-----------------------------------------------------

-- The below child component simply renders some HTML. It does not
-- have any state, event handling, actions, queries, or respond to input values.
type ChildState = Int
type ChildAction = Void
data ChildQuery a
  = GetState (Int -> a)
  | SetState Int a
type ChildInput = Unit
type ChildMessage = Void

type ChildComponent = H.Component HH.HTML ChildQuery ChildInput ChildMessage Aff

childComponent :: ChildComponent
childComponent =
    H.mkComponent
      { initialState: const 42
      , render
      , eval: H.mkEval $ H.defaultEval { handleQuery = handleQuery }
      }
  where
    render :: ChildState -> H.ComponentHTML ChildAction () Aff
    render _ =
      HH.div_
        [ HH.text "The child component's text" ]

    handleQuery :: forall a. ChildQuery a
                -> H.HalogenM ChildState ChildAction () ChildMessage Aff (Maybe a)
    handleQuery = case _ of
      GetState reply -> do
        state <- get
        pure $ Just $ reply state
      SetState value next -> do
        put value
        pure $ Just next
