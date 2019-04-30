module Scaffolding.ParentChildRelationships.ChildlikeComponents.InputMessageRenderer
  ( StateActionIntInputStringMessageComponent
  , runStateActionIntInputStringMessageComponent
  ) where

import Prelude

import CSS (em, marginTop)
import Control.Monad.Rec.Class (forever)
import Control.Monad.State (modify_)
import Data.Array ((:))
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), delay, forkAff, launchAff_)
import Effect.Random (randomInt)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.VDom.Driver (runUI)
import Scaffolding.DynamicRenderer.StateAndEval (StateAndActionRenderer)
import Scaffolding.ParentChildRenderer.ChildlikeComponents.InputOnlyRenderer (ConvertParentInputToChildInitialState)
import Scaffolding.ParentChildRenderer.ChildlikeComponents.MessageOnlyRenderer (HandleAction_StateStringMessage)

-- | Combines all the code we need to define a simple componenet that supports
-- | state, simple event handling, the capability to use the parent's passed-in
-- | `Input` value (an `Int`) to determine what the initial state of the
-- | child will be and how to respond to the parent being re-rendered every
-- | time thereafter, and the capability to "raise" messages to its parent.
type StateActionIntInputStringMessageComponent state action =
  { initialState :: ConvertParentInputToChildInitialState state
  , render :: StateAndActionRenderer state action
  , handleAction :: HandleAction_StateStringMessage state action
  , receive :: Int -> Maybe action
  }

-- | Runs a component that converts the value of the `input` type provided
-- | by the parent (an `Int`) to a value of the `state` type as the
-- | child's initial state value, which is used render dynamic HTML
-- | with event handling via the `action` type.
runStateActionIntInputStringMessageComponent :: forall state action.
                               StateActionIntInputStringMessageComponent state action
                            -> Effect Unit
runStateActionIntInputStringMessageComponent childSpec = do
  launchAff_ do
    body <- awaitBody
    firstIntVal <- liftEffect $ randomInt 1 200
    let childComp = stateActionIntInputStringMessageComponent childSpec
    io <- runUI (parentComponent childComp) firstIntVal body

    forkAff do
      forever do
        delay $ Milliseconds 2000.0
        nextIntVal <- liftEffect $ randomInt 1 200
        io.query $ H.tell $ SetState nextIntVal

type ChildComponentWithIntInputStringMessage =
  H.Component HH.HTML (Const Unit) Int String Aff

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
stateActionIntInputStringMessageComponent :: forall state action.
                                             StateActionIntInputStringMessageComponent state action
                                          -> ChildComponentWithIntInputStringMessage
stateActionIntInputStringMessageComponent spec =
  H.mkComponent
    { initialState: spec.initialState
    , render: spec.render
    , eval: H.mkEval $ H.defaultEval { handleAction = spec.handleAction
                                     , receive = spec.receive
                                     }
    }

data ParentAction = AddMessage String
type ParentState = { latestInt :: Int
                   , logArray :: Array String
                   }
data ParentQuery a = SetState Int a
type ParentComponent = H.Component HH.HTML ParentQuery Int Void Aff

_child = SProxy :: SProxy "child"

type NoQueryStringMessage = H.Slot (Const Unit) String
type ChildSlots = ( child :: NoQueryStringMessage )

parentComponent :: ChildComponentWithIntInputStringMessage -> ParentComponent
parentComponent childComp =
    H.mkComponent
      { initialState: \initialInt -> { latestInt: initialInt, logArray: [] }
      , render: parentHtml
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , handleQuery = handleQuery
                                       }
      }
  where
    parentHtml :: ParentState -> H.ComponentHTML ParentAction _ Aff
    parentHtml state =
      HH.div_
        [ HH.div_
          [ HH.text "The input part will update its `latestInt` value every \
                    \2 seconds.\n\
                    \The message part will log messages to the screen."
          ]
        , HH.slot _child unit childComp state.latestInt (\msg -> Just $ AddMessage msg)
        , HH.div
          [ CSS.style do
            marginTop $ em 3.0
          ]
          (state.logArray <#> \log ->
            HH.div_ [ HH.text $ "Message received: " <> log]
          )
        ]

    handleAction :: ParentAction -> H.HalogenM ParentState ParentAction _ Void Aff Unit
    handleAction (AddMessage msg) = do
      modify_ (\stateRecord -> stateRecord { logArray = msg : stateRecord.logArray })

    handleQuery :: forall a. ParentQuery a -> H.HalogenM ParentState ParentAction _ Void Aff (Maybe a)
    handleQuery (SetState nextInt next) = do
      modify_ (\stateRecord -> stateRecord { latestInt = nextInt })
      pure $ Just next
