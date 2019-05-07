module ParentChildRelationships.ParentlikeComponents.MultipleChildren.RevealingChildSlots where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen as H
import Halogen.HTML as HH
import Scaffolding.ParentChildRenderer.ParentlikeComponents.MultipleChildrenRevealSlotsRenderer (runRevealSlotComponent)

main :: Effect Unit
main = runRevealSlotComponent parentComponent

-- | In other words, "This component has no 'real' state." We use Unit
-- | instead of Void because we still have to pass a value into a function
type StateType = Unit
-- | In other words, "This component has no actions."
type ActionType = Void
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
      -- since this parent doesn't have any actions and doesn't respond
      -- to the child, we'll just use the 'defaultEval' record here
      -- without overwriting any of its values.
      , eval: H.mkEval H.defaultEval
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

    ignoreChildMessage :: ChildMessage -> Maybe ActionType
    ignoreChildMessage _ = Nothing

    render :: StateType -> H.ComponentHTML ActionType ChildSlots Aff
    render _ =
      HH.div_
        [ HH.div_
          [ HH.text "The parent's text" ]
        , HH.slot _childLabel childIndex childComponent childInput ignoreChildMessage
        ]

-----------------------------------------------------

-- The below child component simply renders some HTML. It does not
-- have any state, event handling, actions, queries, or respond to input values.
type ChildState = Unit
type ChildAction = Void
type ChildQuery = Const Void
type ChildInput = Unit
type ChildMessage = Void

type ChildComponent = H.Component HH.HTML ChildQuery ChildInput ChildMessage Aff

childComponent :: ChildComponent
childComponent =
    H.mkComponent
      { initialState: const unit
      , render
      , eval: H.mkEval H.defaultEval
      }
  where
    render :: ChildState -> H.ComponentHTML ChildAction () Aff
    render _ =
      HH.div_
        [ HH.text "The child component's text" ]
