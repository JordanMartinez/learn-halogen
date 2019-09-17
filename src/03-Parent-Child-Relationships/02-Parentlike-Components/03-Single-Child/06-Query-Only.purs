module ParentChildRelationships.ParentlikeComponents.SingleChild.QueryOnly where

import Prelude

-- Imports for lesson
import Control.Monad.State (put)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Random (randomInt)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

-- Imports for scaffolded code
import Data.Const (Const)
import Data.Symbol (SProxy(..))
import Effect.Aff (Aff, launchAff_)
import Control.Monad.State (get)
import Halogen.Aff (awaitBody)
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = runStateActionChildQueryParentSpec stateActionChildQueryParentSpec

-- We'll store the child's state. Since the parent component might not
-- know what that is when it initially renders, we'll wrap it in a Maybe.
type State = Maybe Int

data ParentAction
  = GetChildState
  | SetChildState
  | SetGetDoubledChildState

-- Below is the child's query type
data ChildQuery a
  = GetState (Int -> a)
  | SetState Int a
  | SetAndGetDoubledState Int (Int -> a)

stateActionChildQueryParentSpec :: StateActionChildQueryParentSpec
stateActionChildQueryParentSpec =
    { initialState: Nothing
    , render
    , handleAction
    }
  where
    render :: State -> ParentHtmlWithQueryOnlyChild
    render state =
      HH.div_
        [ HH.div_ [ HH.text $ "The child's state is: " <> (maybe "<unknown>" show state) ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just GetChildState ]
            [ HH.text "Get child state" ]
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just SetChildState ]
            [ HH.text "Set child state to  random integer and \
                      \clear parent's memory of child state"
            ]
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just SetGetDoubledChildState ]
            [ HH.text "Set child state to a random integer and \
                      \store (newState * 2) as parent's memory \
                      \of child state"
            ]
          ]
        , HH.div_
          [ singleChild_query_noInputNoMessage childComp ]
        ]

    handleAction :: ParentAction -> RunParentActionWithQueryOnlyChild
    handleAction = case _ of
      GetChildState -> do
        state <- requestInfo $ H.request GetState
        case state of
          Nothing -> pure unit
          justChildState -> put justChildState
      SetChildState -> do
        randomInt <- liftEffect $ randomInt 1 200
        successOrNot <- tellChildCommand $ H.tell $ SetState randomInt
        -- we don't care whether it was successful or not
        -- so just ignore it

        -- now clear out parent component's memory of child's state
        put Nothing
      SetGetDoubledChildState -> do
        randomInt <- liftEffect $ randomInt 1 200
        maybeDoubledState <- requestInfo $ H.request $ SetAndGetDoubledState randomInt
        case maybeDoubledState of
          Nothing -> pure unit
          justDoubledState -> put justDoubledState

-- Scaffolded Code

type ChildSlots = (child :: H.Slot ChildQuery Void Unit)

_child :: SProxy "child"
_child = SProxy

type ParentHtmlWithQueryOnlyChild =
  H.ComponentHTML ParentAction ChildSlots Aff

type RunParentActionWithQueryOnlyChild =
  H.HalogenM (Maybe Int) ParentAction ChildSlots Void Aff Unit

type StateActionChildQueryParentSpec =
  { initialState :: Maybe Int
  , render :: Maybe Int -> ParentHtmlWithQueryOnlyChild
  , handleAction :: ParentAction -> RunParentActionWithQueryOnlyChild
  }

runStateActionChildQueryParentSpec :: StateActionChildQueryParentSpec
                                   -> Effect Unit
runStateActionChildQueryParentSpec spec = do
  launchAff_ do
    body <- awaitBody
    runUI (parentComponent spec) unit body

-- Parent stuff

singleChild_query_noInputNoMessage :: QueryOnlyChildComponent -> ParentHtmlWithQueryOnlyChild
singleChild_query_noInputNoMessage childComponent =
  HH.slot _child unit childComponent unit (const Nothing)

type RunChildQuery a = H.HalogenM (Maybe Int) ParentAction ChildSlots Void Aff (Maybe a)

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
    , render: spec.render
    , eval: H.mkEval $ H.defaultEval { handleAction = spec.handleAction }
    }

-- Child component

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
