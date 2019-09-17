module Lifecycle.Parent where

import Prelude

-- Imports for lesson
import Control.Monad.State (get, put)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Console (log)
import Halogen (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

-- Imports for scaffolding
import Effect.Aff (launchAff_)
import Halogen.Aff (awaitBody)
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = runParentLifecycleComponent parentLifecycleComponent

type StateType = Boolean

data ActionType
  = RemoveChildren
  | ParentInitialize
  | ParentFinalize

type Input = Unit
type ChildSlots = ( child :: ChildSelfSlot Int )

-- shared types
type QueryType = Const Void
type MonadType = Aff
type Message = Void

_child :: SProxy "child"
_child = SProxy

parentLifecycleComponent :: H.Component HH.HTML QueryType Input Message MonadType
parentLifecycleComponent =
    H.mkComponent
      { initialState
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , initialize = Just ParentInitialize
                                       , finalize = Just ParentFinalize
                                       }
      }
  where
    initialState :: Input -> StateType
    initialState _ = false

    render :: StateType -> H.ComponentHTML ActionType ChildSlots MonadType
    render shouldRemoveChildren =
      HH.div_
        [ HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just RemoveChildren ]
            [ HH.text "Click to remove the children, causing their finalizers \
                      \to run."
            ]
          ]
        , renderChildren shouldRemoveChildren
        ]

    renderChildren :: StateType -> H.ComponentHTML ActionType ChildSlots MonadType
    renderChildren false =
      HH.div_
        [ renderChild 1
        , renderChild 2
        , renderChild 3
        , renderChild 4
        , renderChild 5
        , renderChild 6
        , renderChild 7
        , renderChild 8
        , renderChild 9
        , renderChild 10
        ]
    renderChildren true =
      HH.text "Children were removed..."


    renderChild :: Int -> H.ComponentHTML ActionType ChildSlots MonadType
    renderChild idx =
      HH.slot _child idx childComponent idx (const Nothing)

    handleAction :: ActionType
                 -> H.HalogenM StateType ActionType ChildSlots Message MonadType Unit
    handleAction = case _ of
      RemoveChildren -> do
        put true
      ParentInitialize -> do
        liftEffect $ log "Parent initialization code"
      ParentFinalize -> do
        liftEffect $ log "Parent finalization code"

---------------------------
-- child component below --
---------------------------

type ChildState = Int
type ChildInput = Int
data ChildAction
  = Initialize
  | Finalize

type ChildSelfSlot index = H.Slot QueryType Message index
type NoChildSlots = ()

childComponent  :: H.Component HH.HTML QueryType ChildInput Message MonadType
childComponent  =
    H.mkComponent
      { initialState: identity
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , initialize = initialize
                                       , finalize = finalize
                                       }
      }
  where
    initialize :: Maybe ChildAction
    initialize = Just Initialize

    finalize :: Maybe ChildAction
    finalize = Just Finalize

    render :: ChildState -> H.ComponentHTML ChildAction NoChildSlots Aff
    render childInteger =
      HH.div_ [ HH.text $ "This is child #" <> show childInteger ]

    handleAction :: ChildAction
                 -> H.HalogenM ChildState ChildAction NoChildSlots Message Aff Unit
    handleAction = case _ of
      Initialize -> do
        state <- get
        liftEffect $ log $ "Child component #" <> show state <> " was initialized"
      Finalize -> do
        state <- get
        liftEffect $ log $ "Child component #" <> show state <> " was finalized"

-- Scaffolded Code --

runParentLifecycleComponent :: H.Component HH.HTML (Const Void) Unit Void Aff
                           -> Effect Unit
runParentLifecycleComponent comp = do
  launchAff_ do
    body <- awaitBody
    runUI comp unit body
