module ParentChildRelationships.ChildlikeComponents.QueryOnly where

import Prelude

import Control.Monad.State (get, put)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.HTML as HH

-- Imports for Scaffolding
import Data.Const (Const)
import Data.Maybe (maybe)
import Data.Symbol (SProxy(..))
import Effect.Aff (Aff, launchAff_)
import Effect.Random (randomInt)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = runStateQueryComponent stateQueryComponentSpec

type State = Int

-- | Defines this component's public API that other components can use
data Query a
  = GetState (State -> a)
  | SetState State a
  | SetAndGetDoubledState State (State -> a)

-- | Combines all the code we need to define a simple component that supports
-- | state and simple query handlinGg
type StateQueryComponentSpec =
  { initialState :: State
  , render :: State -> StaticHTML
  , handleQuery :: HandleSimpleQuery
  }

stateQueryComponentSpec :: StateQueryComponentSpec
stateQueryComponentSpec =
    { initialState: 42
    , render
    , handleQuery
    }
  where
    render :: State -> StaticHTML
    render state =
      HH.div_
        [ HH.text $ "The child's state is: " <> show state ]

    handleQuery :: HandleSimpleQuery
    handleQuery = case _ of
      GetState reply -> do
        state <- get
        pure (Just $ reply state)
      SetState nextState next -> do
        put nextState
        pure (Just next)
      SetAndGetDoubledState nextState reply -> do
        put nextState
        let doubled = nextState * 2
        pure (Just $ reply doubled)

-- Scaffolded Code --

-- | HTML written in Purescript via Halogen's HTML DSL
-- | that is always rendered the same and does not include any event handling.
type StaticHTML = H.ComponentHTML Unit () Aff

type HandleSimpleQuery = forall a. Query a -> H.HalogenM State Unit () Void Aff (Maybe a)

-- | Runs a component that converts the value of the `input` type provided
-- | by the parent (an `Int`) to a value of the `state` type as the
-- | child's initial state value, which is used render dynamic HTML
-- | with event handling via the `action` type.
runStateQueryComponent :: StateQueryComponentSpec
                       -> Effect Unit
runStateQueryComponent childSpec = do
  launchAff_ do
    body <- awaitBody
    runUI (parentComponent $ stateQueryComponent childSpec) unit body

type ChildComponentWithQuery = H.Component HH.HTML Query Unit Void Aff

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
stateQueryComponent :: StateQueryComponentSpec
                    -> ChildComponentWithQuery
stateQueryComponent spec =
  H.mkComponent
    { initialState: \_ -> spec.initialState
    , render: spec.render
    , eval: H.mkEval $ H.defaultEval { handleQuery = spec.handleQuery }
    }

data ParentAction = GetChildState | SetChildState | SetGetChildState
type ParentState = Maybe State
type ParentQuery = Const Void
type ParentComponent = H.Component HH.HTML ParentQuery Unit Void Aff

type QueryNoMessage {- index -} = H.Slot Query Void {- index -}
type ChildSlots = (child :: QueryNoMessage Unit)

_child :: SProxy "child"
_child = SProxy

parentComponent :: ChildComponentWithQuery -> ParentComponent
parentComponent childComp =
    H.mkComponent
      { initialState: const Nothing
      , render: parentHtml
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    parentHtml :: ParentState -> H.ComponentHTML ParentAction ChildSlots Aff
    parentHtml state =
      HH.div_
        [ HH.div_
          [ HH.div_
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
              [ HE.onClick \_ -> Just SetGetChildState ]
              [ HH.text "Set child state to a random integer and \
                        \store (newState * 2) as parent's memory \
                        \of child state"
              ]
            ]
          ]
        , HH.div_ [ HH.text $ "Child state is: " <> (maybe "<unknown>" show state) ]
        , HH.slot _child unit childComp unit (const Nothing)
        ]

    handleAction :: ParentAction
                 -> H.HalogenM ParentState ParentAction ChildSlots Void Aff Unit
    handleAction = case _ of
      GetChildState -> do
        childState <- H.query _child unit $ H.request GetState
        case childState of
          Nothing -> pure unit
          Just x -> put $ Just x

      SetChildState -> do
        randomIntValue <- liftEffect $ randomInt 1 200
        void $ H.query _child unit $ H.tell $ SetState randomIntValue

        -- clear parent's memory of what the child's state is
        put Nothing

      SetGetChildState -> do
        randomIntValue <- liftEffect $ randomInt 1 200
        doubledState <- H.query _child unit $ H.request $ SetAndGetDoubledState randomIntValue
        put doubledState
