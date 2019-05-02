-- | A template file for a Halogen component designed to be
-- | duplicated and renamed.
-- | Everything is already set up. One just needs to configure the component
-- | to have the parts one needs before removing the rest.
module Scaffolding.ComponentTemplate
  -- (
  -- )
  where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect.Aff (Aff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State = Unit
data ActionType
  = DoStuff
  -- Uncomment these if they are needed
  -- | Initialize
  -- | Finalize

-- Leave only one of versions of Query uncommented
-- No query
type Query = Const Void
-- Query
-- data Query a
--   = Request (requestType -> a)
--   | Command a

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

type SlotIndex = Unit
type ComponentSlot = H.Slot Query Message SlotIndex

type ChildSlots =
  -- Leave only one of the following uncommented
    -- Component is a child: no slots
    ()
    -- Component is a parent: one or more slots
    -- ( child :: ChildSlot
    -- )

_child = SProxy :: SProxy "child"

component :: H.Component HH.HTML Query Input Message MonadType
component =
    H.mkComponent
      { initialState: initialState
      , render: render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , receive = receive
                                       -- , handleQuery = handleQuery
                                       -- , initialize = Just Initialize
                                       -- , finalize = Just Finalize
                                       }
      }
  where
    initialState :: Input -> State
    initialState _ = unit

    receive :: Input -> Maybe ActionType
    receive _ = Just DoStuff

    render :: State -> H.ComponentHTML ActionType ChildSlots MonadType
    render _ =
      HH.div_
        [ HH.text "stuff " ]

    handleAction :: ActionType
                 -> H.HalogenM State ActionType ChildSlots Message MonadType Unit
    handleAction = case _ of
      DoStuff -> do
        pure unit

    -- handleQuery :: forall a.
    --                Query a
    --             -> H.HalogenM State ActionType ChildSlots Message MonadType (Maybe a)
    -- handleQuery = case _ of
    --   Request reply -> do
    --     -- value <- computeTheValue
    --     pure (Just $ reply value)
    --   Command next -> do
    --     -- run code
    --     pure next
