-- | A template file for a Halogen component designed to be
-- | duplicated and renamed.
-- | Everything is already set up. One just needs to configure the component
-- | to have the parts one needs before removing the rest.
module Scaffolding.ComponentTemplate
  ( templateComponent
  , StateType
  , QueryType(..)
  -- , QueryType -- if using the 'Void' version
  , Input
  , Message
  , MonadType
  , SelfSlot
  )
  where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect.Aff (Aff)
import Halogen as H
import Halogen.HTML as HH

type StateType = Unit
data ActionType
  = DoStuff
  -- Delete these if they are not needed
  | Initialize
  | Finalize

-- Leave only one of versions of QueryType uncommented
-- No query
-- type QueryType = Const Void
-- QueryType
data QueryType a
  = Request (Int {- info other components need -} -> a)
  | Command a

type Input =
  -- Leave only one of the following uncommented
    -- "Empty" input
    Unit
    -- Actual input type
    -- Int -- or your own type

type Message =
  -- Leave only one of th efollowing uncommented
    -- "Empty" message type
    Void
    -- Actual input type
    -- Int -- or your own type

type MonadType =
  -- Leave only one of the following uncommented
    -- "Normal" monad type
    Aff
    -- Custom monad type (e.g. ReaderT design pattern, mtl, or Free/Run)
    -- AppM -- or your own type

type SelfSlot = H.Slot QueryType Message Unit

type ChildSlots =
  -- Leave only one of the following uncommented
    -- Component is a child: no slots
    ()
    -- Component is a parent: one or more slots
    -- ( child :: ChildSlot
    -- )

_child :: SProxy "child"
_child = SProxy

templateComponent :: H.Component HH.HTML QueryType Input Message MonadType
templateComponent =
    H.mkComponent
      { initialState
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , receive = receive
                                       , handleQuery = handleQuery
                                       , initialize = Just Initialize
                                       , finalize = Just Finalize
                                       }
      }
  where
    initialState :: Input -> StateType
    initialState _ = unit

    receive :: Input -> Maybe ActionType
    receive _ = Just DoStuff

    render :: StateType -> H.ComponentHTML ActionType ChildSlots MonadType
    render _ =
      HH.div_
        [ HH.text "stuff " ]

    handleAction :: ActionType
                 -> H.HalogenM StateType ActionType ChildSlots Message MonadType Unit
    handleAction = case _ of
      Initialize -> do
        pure unit
      Finalize -> do
        pure unit
      DoStuff -> do
        pure unit

    handleQuery :: forall a.
                   QueryType a
                -> H.HalogenM StateType ActionType ChildSlots Message MonadType (Maybe a)
    handleQuery = case _ of
      Request reply -> do
        -- value <- computeTheValue
        pure (Just $ reply 4)
      Command next -> do
        -- run code
        pure (Just next)
