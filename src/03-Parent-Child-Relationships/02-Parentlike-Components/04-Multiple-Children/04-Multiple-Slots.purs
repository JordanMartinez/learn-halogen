module ParentChildRelationships.ParentlikeComponents.MultipleChildren.MultipleSlots where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Scaffolding.ParentChildRenderer.ParentlikeComponents.MultipleChildrenMultiSlotsRenderer (runMultiSlotComponent)
import Web.HTML (window)
import Web.HTML.Window (alert)

main :: Effect Unit
main = runMultiSlotComponent parentComponent

-- 'empty' types for these types
type StateType = Unit
type Input = Unit
type Message = Void

data ActionType
  = PrintChild1Message Int Int
  | PrintChild2Message String

type NoQuery = Const Void

type Message_Int = Int
type ChildSlot1 = H.Slot NoQuery Message_Int Int

type Message_String = String
type ChildSlot2 = H.Slot NoQuery Message_String Int

type ChildSlots =
  ( label1 :: ChildSlot1
  , label2 :: ChildSlot2
  )

_label1 :: SProxy "label1"
_label1 = SProxy

_label2 :: SProxy "label2"
_label2 = SProxy

parentComponent :: H.Component HH.HTML NoQuery Input Message Aff
parentComponent =
    H.mkComponent
      { initialState: \input -> unit
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       }
      }
  where
    separator :: H.ComponentHTML ActionType ChildSlots Aff
    separator = HH.div_ [ HH.text "...." ]

    render :: StateType -> H.ComponentHTML ActionType ChildSlots Aff
    render _ =
      HH.div_
        [ HH.div_
          [ HH.text "The parent's text" ]
        , separator
        , HH.div_
          [ HH.slot _label1 1 child1 1  (\i -> Just $ PrintChild1Message 1 i)
          , HH.slot _label1 2 child1 10 (\i -> Just $ PrintChild1Message 2 i)
          , HH.slot _label1 3 child1 42 (\i -> Just $ PrintChild1Message 3 i)
          , HH.slot _label1 4 child1 24 (\i -> Just $ PrintChild1Message 4 i)
          , HH.slot _label1 5 child1 13 (\i -> Just $ PrintChild1Message 5 i)
          ]
        , separator
        , HH.div_
          -- notice how the order of the `index` value below doesn't change
          -- the order of how these children are laid out. Rather,
          -- it just changes which `Int` value we'd need to use to
          -- refer to the correct child.
          [ HH.slot _label2 5 child2 32 (\msg -> Just $ PrintChild2Message msg)
          , HH.slot _label2 2 child2 42 (\msg -> Just $ PrintChild2Message msg)
          , HH.slot _label2 1 child2 52 (\msg -> Just $ PrintChild2Message msg)
          , HH.slot _label2 3 child2 23 (\msg -> Just $ PrintChild2Message msg)
          , HH.slot _label2 4 child2 25 (\msg -> Just $ PrintChild2Message msg)
          ]
        ]

    handleAction :: ActionType
                 -> H.HalogenM StateType ActionType ChildSlots Message Aff Unit
    handleAction = case _ of
      PrintChild1Message childIndex intValue -> do
        liftEffect do
          window_ <- window
          let message = "Child " <> show childIndex <> " emitted an Int: " <> show intValue
          alert message window_
      PrintChild2Message intValue -> do
        liftEffect do
          window_ <- window
          alert ("A child emitted an int message: " <> show intValue) window_

-----------------------------------------------------

type Child1State = Int
type Child1Input = Int
data Child1Action = EmitMessage Int

child1 :: H.Component HH.HTML NoQuery Child1Input Message_Int Aff
child1 =
    H.mkComponent
      { initialState: identity
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    render :: Int -> H.ComponentHTML Child1Action () Aff
    render inputAndState =
      HH.div_
        [ HH.button
          [ HE.onClick \_ -> Just $ EmitMessage inputAndState ]
          [ HH.text "A child1 component button"]
        ]

    handleAction :: Child1Action
                 -> H.HalogenM Child1State Child1Action () Message_Int Aff Unit
    handleAction = case _ of
      EmitMessage inputAndState -> do
        H.raise inputAndState

type Child2State = Int
type Child2Input = Int
data Child2Action = RaiseMessage String

child2 :: H.Component HH.HTML NoQuery Child2Input Message_String Aff
child2 =
    H.mkComponent
      { initialState: identity
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    render :: Child2State -> H.ComponentHTML Child2Action () Aff
    render inputAndState =
      HH.div_
        [ HH.button
          [ HE.onClick \_ -> Just $ RaiseMessage $ "Input value was: " <> show inputAndState ]
          [ HH.text "A child2 component button"]
        ]

    handleAction :: Child2Action
                 -> H.HalogenM Child2State Child2Action () Message_String Aff Unit
    handleAction = case _ of
      RaiseMessage msg -> do
        H.raise msg
