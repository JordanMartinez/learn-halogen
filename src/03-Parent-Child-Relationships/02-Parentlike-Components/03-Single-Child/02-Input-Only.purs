module ParentChildRelationships.ParentlikeComponents.SingleChild.InputOnly where

import Prelude

-- Imports for lesson
import Data.Maybe (Maybe(..))
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

-- Imports for scaffolding
import CSS (backgroundColor, fontSize, orange, padding, px)
import Data.Const (Const)
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Random (randomInt)
import Halogen (liftEffect, put)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML.CSS as CSS
import Halogen.VDom.Driver (runUI)

-- | State of parent and child is an integer
type State = Int

main :: Effect Unit
main = do
  launchAff_ do
    body <- awaitBody
    initialInt <- liftEffect $ randomInt 1 200
    runUI parentComponent initialInt body

-- | Parent component which contains a button and child component
parentComponent :: H.Component HH.HTML (Const Unit) State Void Aff
parentComponent =
    H.mkComponent
      { initialState: identity
      , render: render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    render :: State -> ParentWithSingleChildInputOnly
    render state =
      HH.div_
        [ HH.div_ [ HH.text "This is the parent component " ]
        , HH.button
          [ HE.onClick \_ -> Just RandomState]
          [ HH.text "Click to send a random integer (the `input` value) \
                    \to the child"
          ]
        , HH.slot -- slot for child component
            _child          -- slot address label
            unit            -- (unused) slot address index
            childComponent  -- child component for the slot
            state           -- input value to pass to the component
            (const Nothing) -- (unused) function mapping outputs from component to parent query
        ]

    handleAction :: ParentAction
                 -> H.HalogenM Int ParentAction ChildSlots Void Aff Unit
    handleAction RandomState = do
      randInt <- liftEffect $ randomInt 1 200
      put randInt

-- | The parent's only action is `RandomState`
data ParentAction = RandomState

-- | A parent component that can regenerate a new `state` value (an `Int`) value
-- | and renders a child that can respond to the initial and "parent re-rendered"
-- | input values
type ParentWithSingleChildInputOnly =
  H.ComponentHTML
    ParentAction
    ChildSlots
    Aff

type ChildSlots =
    (child :: H.Slot
                (Const Unit) -- no query type
                Void         -- no message type
                Unit         -- single child, so use Unit for slot index
    )

_child :: SProxy "child"
_child = SProxy

data ChildAction = SetState State

-- | A simple child component that only renders content to the screen
childComponent :: H.Component HH.HTML (Const Unit) State Void Aff
childComponent =
    H.mkComponent
      { initialState: identity
      , render: render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , receive = \i -> Just $ SetState i
                                       }
      }
  where
    render :: State -> H.ComponentHTML ChildAction () Aff
    render state =
      HH.div
        [ CSS.style do
            fontSize $ px 20.0
            backgroundColor orange
            padding (px 20.0) (px 20.0) (px 20.0) (px 20.0)
        ]
        [ HH.text $ "This is the child component. The input value was: " <> show state ]

    handleAction :: ChildAction
                 -> H.HalogenM State ChildAction () Void Aff Unit
    handleAction (SetState i) = put i
