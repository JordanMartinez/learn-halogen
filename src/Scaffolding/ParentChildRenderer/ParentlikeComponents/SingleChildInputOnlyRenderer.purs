module Scaffolding.ParentChildRenderer.ParentlikeComponents.SingleChildInputOnlyRenderer
  ( ParentAction(..)
  , ParentWithSingleChildInputOnly
  , InputOnlyChildComponent
  , RenderParentWithInputOnlyChild
  , runParentWithInputOnlyChild
  , singleChild_input_NoMessageNoQuery
  )
  where

import Prelude

import CSS (backgroundColor, fontSize, orange, padding, px)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Random (randomInt)
import Halogen (liftEffect, put)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.VDom.Driver (runUI)

-- | The parent's only action is `RandomState`
data ParentAction = RandomState

-- | A parent component that can regenerate a new `state` value (an `Int`) value
-- | and renders a child that can respond to initial and "parent re-rendered"
-- | input values
type ParentWithSingleChildInputOnly =
  H.ComponentHTML
    ParentAction
    (child :: H.Slot
                (Const Unit) -- no query type
                Void         -- no message type
                Unit         -- single child, so only unit for slot index
    )
    Aff

_child :: SProxy "child"
_child = SProxy

-- | A child component that renders dynamic html. It has state and
-- | responds to input, but it does not raise messages, or respond to queries.
type InputOnlyChildComponent = H.Component HH.HTML (Const Unit) Int Void Aff

-- | Defines a function for regenerating the
type HandleParentActionWithInputChild =
  ParentAction -> H.HalogenM Int ParentAction (child :: H.Slot (Const Unit) Void Unit) Void Aff Unit

-- | A parent component that, when given the child component, will render
-- | itself and the child component. No other interaction occurs between them
-- | (e.g. input, messages, queries).
type RenderParentWithInputOnlyChild =
  InputOnlyChildComponent -> Int -> ParentWithSingleChildInputOnly

-- | Runs a `ParentWithInputOnlyChild`, so that we can see our component in action.
runParentWithInputOnlyChild :: RenderParentWithInputOnlyChild
                            -> Effect Unit
runParentWithInputOnlyChild renderParent = do
  launchAff_ do
    body <- awaitBody
    initialInt <- liftEffect $ randomInt 1 200
    runUI (parentWithInput renderParent) initialInt body

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
parentWithInput :: RenderParentWithInputOnlyChild
                -> H.Component HH.HTML (Const Unit) Int Void Aff
parentWithInput renderParent =
    H.mkComponent
      { initialState: identity
      , render: \state -> renderParent simpleChildComponent state
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    handleAction :: ParentAction
                 -> H.HalogenM Int ParentAction (child :: H.Slot (Const Unit) Void Unit) Void Aff Unit
    handleAction RandomState = do
      randInt <- liftEffect $ randomInt 1 200
      put randInt

-- | Renders a child that does not respond to input, raise messages, or respond
-- | to queries inside of a parent component
singleChild_input_NoMessageNoQuery :: InputOnlyChildComponent -> Int -> ParentWithSingleChildInputOnly
singleChild_input_NoMessageNoQuery childComp input =
  HH.slot _child unit childComp input (const Nothing)

data ChildAction = SetState Int

-- | A simple child component that only renders content to the screen
simpleChildComponent :: H.Component HH.HTML (Const Unit) Int Void Aff
simpleChildComponent =
    H.mkComponent
      { initialState: identity
      , render: render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , receive = \i -> Just $ SetState i
                                       }
      }
  where
    render :: Int -> H.ComponentHTML ChildAction () Aff
    render state =
      HH.div
        [ CSS.style do
            fontSize $ px 20.0
            backgroundColor orange
            padding (px 20.0) (px 20.0) (px 20.0) (px 20.0)
        ]
        [ HH.text $ "This is the child component. The input value was: " <> show state ]

    handleAction :: ChildAction
                 -> H.HalogenM Int ChildAction () Void Aff Unit
    handleAction (SetState i) = put i
