module Scaffolding.ParentChildRenderer.ChildlikeComponents.QueryOnlyRenderer
  ( Query(..)
  , HandleSimpleQuery
  , StateQueryComponentSpec
  , runStateQueryComponent
  )
  where

import Prelude

import Control.Monad.State (put)
import Data.Const (Const)
import Data.Maybe (Maybe(..), maybe)
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Random (randomInt)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)
import Scaffolding.StaticRenderer (StaticHTML)


data Query a
  = GetState (Int -> a)
  | SetState Int a
  | SetAndGetDoubledState Int (Int -> a)

type HandleSimpleQuery = forall a. Query a -> H.HalogenM Int Unit () Void Aff (Maybe a)

-- | Combines all the code we need to define a simple componenet that supports
-- | state and simple query handlinGg
type StateQueryComponentSpec =
  { initialState :: Int
  , render :: Int -> StaticHTML
  , handleQuery :: HandleSimpleQuery
  }

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
type ParentState = Maybe Int
type ParentQuery = Const Void
type ParentComponent = H.Component HH.HTML ParentQuery Unit Void Aff

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
    parentHtml :: ParentState -> H.ComponentHTML ParentAction (child :: H.Slot Query Void Unit) Aff
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

    handleAction :: ParentAction -> H.HalogenM ParentState ParentAction (child :: H.Slot Query Void Unit) Void Aff Unit
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
