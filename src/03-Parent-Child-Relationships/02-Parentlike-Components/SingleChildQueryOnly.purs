module Scaffolding.ParentChildRelationships.ParentlikeComponents.SingleChildQueryOnlyRenderer
  ( ParentAction(..)
  , ParentHtmlWithQueryOnlyChild
  , RunParentActionWithQueryOnlyChild
  , QueryOnlyChildComponent
  , singleChild_query_noInputNoMessage
  , runStateActionChildQueryParentSpec
  , RunChildQuery
  , requestInfo
  , tellChildCommand
  , ChildQuery(..)
  , StateActionChildQueryParentSpec
  )
  where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen (get, put)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

data ParentAction
  = GetChildState
  | SetChildState
  | SetGetDoubledChildState

type ParentHtmlWithQueryOnlyChild =
  H.ComponentHTML ParentAction (child :: H.Slot ChildQuery Void Unit) Aff

type RunParentActionWithQueryOnlyChild =
  H.HalogenM (Maybe Int) ParentAction (child :: H.Slot ChildQuery Void Unit) Void Aff Unit

type StateActionChildQueryParentSpec =
  { initialState :: Maybe Int
  , render :: QueryOnlyChildComponent -> Maybe Int -> ParentHtmlWithQueryOnlyChild
  , handleAction :: ParentAction -> RunParentActionWithQueryOnlyChild
  }

runStateActionChildQueryParentSpec :: StateActionChildQueryParentSpec
                                   -> Effect Unit
runStateActionChildQueryParentSpec spec = do
  launchAff_ do
    body <- awaitBody
    runUI (parentComponent spec) unit body

-- scaffolded parent stuff

_child :: SProxy "child"
_child = SProxy

singleChild_query_noInputNoMessage :: QueryOnlyChildComponent -> ParentHtmlWithQueryOnlyChild
singleChild_query_noInputNoMessage childComponent =
  HH.slot _child unit childComponent unit (const Nothing)

type RunChildQuery a = H.HalogenM (Maybe Int) ParentAction (child :: H.Slot ChildQuery Void Unit) Void Aff (Maybe a)

requestInfo :: forall a. ChildQuery a -> RunChildQuery a
requestInfo request =
  H.query _child unit request

tellChildCommand :: forall a. ChildQuery a -> RunChildQuery a
tellChildCommand tellCommand =
  H.query _child unit tellCommand

type ParentComponentWithQueryOnlyChild = H.Component HH.HTML (Const Void) Unit Void Aff

parentComponent :: StateActionChildQueryParentSpec
                -> ParentComponentWithQueryOnlyChild
parentComponent spec =
  H.mkComponent
    { initialState: \_ -> spec.initialState
    , render: \state -> spec.render childComp state
    , eval: H.mkEval $ H.defaultEval { handleAction = spec.handleAction }
    }

-- Child component

data ChildQuery a
  = GetState (Int -> a)
  | SetState Int a
  | SetAndGetDoubledState Int (Int -> a)

type QueryOnlyChildComponent = H.Component HH.HTML ChildQuery Unit Void Aff

childComp :: QueryOnlyChildComponent
childComp =
    H.mkComponent
      { initialState
      , render
      , eval: H.mkEval $ H.defaultEval { handleQuery = handleQuery }
      }
  where
    initialState :: Unit -> Int
    initialState _ = 42

    render :: Int -> H.ComponentHTML Void () Aff
    render state =
      HH.div_
        [ HH.text $ "Child state: " <> show state ]

    handleQuery :: forall a.
                   ChildQuery a
                -> H.HalogenM Int Void () Void Aff (Maybe a)
    handleQuery = case _ of
      GetState reply -> do
        state <- get
        pure $ Just $ reply state
      SetState state next -> do
        put state
        pure $ Just next
      SetAndGetDoubledState state reply -> do
        put state
        let doubledState = state * 2
        pure $ Just $ reply doubledState
