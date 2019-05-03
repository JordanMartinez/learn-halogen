module ParentChildRelationships.ChildlikeComponents.QueryOnly where

import Prelude

import Control.Monad.State (get, put)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.HTML as HH
import Scaffolding.ParentChildRenderer.ChildlikeComponents.QueryOnlyRenderer (HandleSimpleQuery, Query(..), runStateQueryComponent)
import Scaffolding.StaticRenderer (StaticHTML)

main :: Effect Unit
main = runStateQueryComponent stateQueryComponentSpec

type State = Int

-- Normally, we would define the `Query` type here. However,
-- our corresponding Scaffolding module needs to know what
-- that type is in order for us to define the parent component.
--
-- PureScript does not allow us to define cyclical modules,
-- so we cannot do that. Rather, we've defined
-- the `Query` type in our corresponding Scaffolding module.
-- It is defined exactly as you see below.
{-
data Query a
  = GetState (State -> a)
  | SetState State a
  | SetAndGetDoubledState State (State -> a)
-}

-- | Combines all the code we need to define a simple componenet that supports
-- | state and simple query handlinGg
type StateQueryComponentSpec =
  { initialState :: Int
  , render :: Int -> StaticHTML
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
