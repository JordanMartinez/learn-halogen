-- | Same as 'ComponentTemplate.A' but without all of comments.
module ComponentTemplate.B
  ( templateComponent
  , StateType
  , QueryType(..)
  -- , QueryType
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
  | Initialize
  | Receive Input
  | Finalize

-- type QueryType = Const Void
data QueryType a
  = Request (Int -> a)
  | Command a

type Input = Unit
type Message = Void
type MonadType = Aff
type SelfSlot index = H.Slot QueryType Message index
type ChildSlots = ()

-- _child :: SProxy "child"
-- _child = SProxy

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
    receive i = Just $ Receive i

    render :: StateType -> H.ComponentHTML ActionType ChildSlots MonadType
    render _ =
      HH.div_
        [ HH.text "stuff" ]

    handleAction :: ActionType
                 -> H.HalogenM StateType ActionType ChildSlots Message MonadType Unit
    handleAction = case _ of
      Initialize -> do
        pure unit
      Receive input -> do
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
        pure $ Just $ reply 4
      Command next -> do
        pure $ Just next
