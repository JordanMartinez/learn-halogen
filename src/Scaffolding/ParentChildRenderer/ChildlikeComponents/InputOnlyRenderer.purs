module Scaffolding.ParentChildRenderer.ChildlikeComponents.InputOnlyRenderer
  ( runStateActionInputComponent
  , ConvertParentInputToChildInitialState
  , StateActionIntInputComponent
  )
  where

import Prelude

import Control.Monad.Rec.Class (forever)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), delay, forkAff, launchAff_)
import Effect.Random (randomInt)
import Halogen (liftEffect, put)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)
import Scaffolding.DynamicRenderer.StateAndEval (StateAndActionRenderer, HandleSimpleAction)

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
  launchAff_ do
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
                            -> H.Component HH.HTML (Const Unit) Int Void Aff
stateActionInputComponent spec =
  H.mkComponent
    { initialState: \input -> spec.initialState input
    , render: spec.render
    , eval: H.mkEval $ H.defaultEval { handleAction = spec.handleAction
                                     , receive = spec.receive
                                     }
    }

type ChildComponent = H.Component HH.HTML (Const Unit) Int Void Aff

type ParentState = Int
data ParentQuery a = SetState Int a
type ParentAction = Void
type ParentComponent = H.Component HH.HTML ParentQuery Int Void Aff

_child = SProxy :: SProxy "child"

type NoMessageNoQuery = H.Slot (Const Unit)  Void
type ChildSlots = ( child :: NoMessageNoQuery )

parentComponent :: ChildComponent -> ParentComponent
parentComponent childComp =
    H.mkComponent
      { initialState: identity
      , render: parentHtml
      , eval: H.mkEval $ H.defaultEval { handleQuery = handleQuery
                                       }
      }
  where
    parentHtml :: ParentState -> H.ComponentHTML ParentAction _ Aff
    parentHtml latestInt =
      HH.div_
        [ HH.slot _child unit childComp latestInt (const Nothing) ]

    handleQuery :: forall a. ParentQuery a -> H.HalogenM ParentState ParentAction _ Void Aff (Maybe a)
    handleQuery (SetState nextInt next) = do
      put nextInt
      pure $ Just next
