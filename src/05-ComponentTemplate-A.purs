-- | A template file for a correctly-configured Halogen component.
-- | It is designed to be duplicated and have all of its types configured
-- | by changing the definition of the type aliases (e.g. StateType
-- | becomes Int instead of Unit).
-- |
-- | Moreover, each type has a short summary as to what goes there and why
-- | to help you know how to configure it for your purposes.
module ComponentTemplate.A
  ( templateComponent
  , StateType
  , QueryType(..) -- if using the `Query a` version
  -- , QueryType -- if using the 'Void' version
  , Input
  , Message
  , MonadType

  -- `SelfSlot` exists so you can use this syntax in a parent component
  --    import MyModule.MyComponent as MyComponent
  --    type ChildSlots = ( child :: MyComponet.SelfSlot indexType)
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

-- This is the 'private API' of the component
data ActionType
  = DoStuff
  -- Delete these if they are not needed
  | Initialize
  | Receive Input
  | Finalize

-- This is the 'public API' of the component
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
  -- Leave only one of the following uncommented
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

-- The `index` type here is determined by the parent
type SelfSlot index = H.Slot QueryType Message index

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
      -- Delete the labels that follow `defaultEval` if they aren't be used
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , receive = receive
                                       , handleQuery = handleQuery
                                       , initialize = Just Initialize
                                       , finalize = Just Finalize
                                       }
      }
  where
    -- | Two things one can do here:
    -- | 1. Ignore the input value: `const initialState`/`\_ -> initialState`
    -- | 2. Use the input value: `\i -> makeStateUsingInput i`
    initialState :: Input -> StateType
    initialState _ = unit

    -- | Two things one can do here:
    -- | 1. Ignore the input value: `const Nothing`/`\_ -> Nothing`
    -- | 2. Do something with the input value: `\i -> Just $ Receive i`
    receive :: Input -> Maybe ActionType
    receive i = Just $ Receive i

    -- | Given the state value, render some HTML.
    -- |
    -- | Why these types are needed here:
    -- | - `ActionType`: in case component responds to events.
    -- | - `ChildSlots`: in case component renders child components
    -- | - `MonadType`: I don't know why, but Halogen requires it...
    render :: StateType -> H.ComponentHTML ActionType ChildSlots MonadType
    render _ =
      HH.div_
        [ HH.text "stuff " ]

    -- | Given the component's action type, run effects / monadic code
    -- |
    -- | Types explained:
    -- | - `StateType`: in case component's state is gotten/set/modified
    -- | - `ActionType`: in case one decides to run another action's code
    -- | - `ChildSlots`: in case one queries a child component
    -- | - `Message`: in case the component raises a message
    -- | - `MonadType`: defines the monadic context in which this code runs
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

    -- | Given the component's query type, run effects / monadic code
    -- |
    -- | Types explained:
    -- | - `StateType`: in case component's state is gotten/set/modified
    -- | - `ActionType`: in case one decides to run an action's code
    -- | - `ChildSlots`: in case one queries a child component
    -- | - `Message`: in case the component raises a message
    -- | - `MonadType`: defines the monadic context in which this code runs
    -- | - `Maybe a`: to indicate whether query evaluation was 'successful' or ont
    handleQuery :: forall a.
                   QueryType a
                -> H.HalogenM StateType ActionType ChildSlots Message MonadType (Maybe a)
    handleQuery = case _ of
      Request reply -> do
        -- value <- computeTheValue
        pure $ Just $ reply 4
      Command next -> do
        -- run code
        pure $ Just next
