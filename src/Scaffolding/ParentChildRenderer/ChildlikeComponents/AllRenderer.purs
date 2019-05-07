module Scaffolding.ParentChildRenderer.ChildlikeComponents.AllRenderer
  ( QueryState
  , ChildState
  , ChildInput
  , ChildMessage
  , ChildAction(..)
  , ChildQuery(..)
  , ChildHtml
  , RunChildAction
  , RunChildQuery
  , StateActionQueryInputMessageChildComponentSpec
  , runChildComponentSpec
  , runChildComponent
  ) where

import Prelude

import CSS (backgroundColor, em, lightblue, lightgreen, padding, paddingLeft, paddingTop)
import Control.Monad.Rec.Class (forever)
import Control.Monad.State (modify_)
import Data.Array ((:))
import Data.Maybe (Maybe(..), maybe)
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), delay, forkAff, launchAff_)
import Effect.Random (randomInt)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

type QueryState = Int
type ChildState = { intValue :: Int
                  , toggleState :: Boolean
                  , counter :: Int
                  , queryState :: QueryState
                  }
type ChildInput = Int
type ChildMessage = String

data ChildAction
  -- From Input-Only
  = ToggleButton
  | ReceiveParentInput ChildInput
  -- From Message-Only
  | IncrementCounter
  | DecrementCounter
  | NotifyParentAboutCounterState
  | NotifyParentTextMessage ChildMessage

data ChildQuery a
  = GetQueryState (QueryState -> a)
  | SetQueryState QueryState a
  | SetAndGetDoubledQueryState QueryState (QueryState -> a)

type ChildHtml = H.ComponentHTML ChildAction () Aff
type RunChildAction = H.HalogenM ChildState ChildAction () ChildMessage Aff Unit
type RunChildQuery a = H.HalogenM ChildState ChildAction () ChildMessage Aff (Maybe a)

type StateActionQueryInputMessageChildComponentSpec =
  { initialState :: ChildInput -> ChildState
  , receive :: ChildInput -> Maybe ChildAction
  , render :: ChildState -> ChildHtml
  , handleAction :: ChildAction -> RunChildAction
  , handleQuery :: forall a. ChildQuery a -> RunChildQuery a
  }

runChildComponentSpec :: StateActionQueryInputMessageChildComponentSpec
                      -> Effect Unit
runChildComponentSpec spec =
  runChildComponent $
    H.mkComponent
      { initialState: spec.initialState
      , render: spec.render
      , eval: H.mkEval $ H.defaultEval { handleAction = spec.handleAction
                                       , handleQuery = spec.handleQuery
                                       , receive = spec.receive
                                       }

    }

-- | Runs a component that converts the value of the `input` type provided
-- | by the parent (an `Int`) to a value of the `state` type as the
-- | child's initial state value, which is used render dynamic HTML
-- | with event handling via the `action` type.
runChildComponent :: H.Component HH.HTML ChildQuery Int String Aff
                  -> Effect Unit
runChildComponent childComp = do
  launchAff_ do
    body <- awaitBody
    firstIntVal <- liftEffect $ randomInt 1 200
    io <- runUI (parentComponent childComp) firstIntVal body

    forkAff do
      forever do
        delay $ Milliseconds 2000.0
        nextIntVal <- liftEffect $ randomInt 1 200
        io.query $ H.tell $ SetParentState nextIntVal

data ParentAction
  = AddMessage String
  | GetChildState
  | SetChildState
  | SetGetChildState

type ParentState = { latestInt :: Int
                   , logArray :: Array String
                   , queryState :: Maybe Int
                   }
data ParentQuery a = SetParentState Int a

type ParentComponent = H.Component HH.HTML ParentQuery Int Void Aff

_child :: SProxy "child"
_child = SProxy

parentComponent :: H.Component HH.HTML ChildQuery Int String Aff -> ParentComponent
parentComponent childComp =
    H.mkComponent
      { initialState: \initialInt -> { latestInt: initialInt, logArray: [], queryState: Nothing }
      , render: parentHtml
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , handleQuery = handleQuery
                                       }
      }
  where
    blankBlockLevelPadding :: H.ComponentHTML ParentAction (child :: H.Slot ChildQuery String Unit) Aff
    blankBlockLevelPadding =
      HH.div [ CSS.style $ paddingTop $ em 1.0 ] []

    inputHtml :: H.ComponentHTML ParentAction (child :: H.Slot ChildQuery String Unit) Aff
    inputHtml =
      HH.div_ [ HH.text "The input part will update the child's \
                          \`latestInt` value every 2 seconds."
              ]

    queryControlsHtml :: Maybe Int -> H.ComponentHTML ParentAction (child :: H.Slot ChildQuery String Unit) Aff
    queryControlsHtml queryState =
      HH.div_
        [ HH.h3_
          [ HH.text "The query part" ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just GetChildState ]
            [ HH.text "Get child's query state" ]
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just SetChildState ]
            [ HH.text "Set child's query state to random integer and \
                      \clear parent's memory of child's query state"
            ]
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just SetGetChildState ]
            [ HH.text "Set child's query state to a random integer and \
                      \store (newState * 2) as parent's memory \
                      \of child's query state"
            ]
          ]
        , blankBlockLevelPadding
        , HH.div_ [ HH.text $ "Child state (query) is: " <>
                              (maybe "<unknown>" show queryState)
                  ]
        ]

    parentHtml :: ParentState -> H.ComponentHTML ParentAction (child :: H.Slot ChildQuery String Unit) Aff
    parentHtml state =
      HH.div_
        [ HH.h1_ [ HH.text "Parent controls" ]
        , HH.div
          [ CSS.style do
            padding (em 1.0) (em 1.0) (em 1.0) (em 1.0)
            backgroundColor lightblue
          ]
          [ inputHtml
          , blankBlockLevelPadding
          , queryControlsHtml state.queryState
          ]
        , HH.h1_ [ HH.text "Child controls" ]
        , HH.div
          [ CSS.style do
            padding (em 1.0) (em 1.0) (em 1.0) (em 1.0)
            backgroundColor lightgreen
          ]
          [ HH.slot _child unit childComp state.latestInt (\msg -> Just $ AddMessage msg)
          ]

        , HH.h3_
          [ HH.text "Messages received from child" ]
        , HH.div
          [ CSS.style do
            paddingLeft $ em 1.0
          ]
          (state.logArray <#> \log ->
            HH.div_ [ HH.text $ "Message received: " <> log]
          )
        ]

    handleAction :: ParentAction
                 -> H.HalogenM ParentState ParentAction (child :: H.Slot ChildQuery String Unit) Void Aff Unit
    handleAction = case _ of
      AddMessage msg -> do
        modify_ (\stateRecord -> stateRecord { logArray = msg : stateRecord.logArray })

      GetChildState -> do
        childState <- H.query _child unit $ H.request GetQueryState
        case childState of
          Nothing -> pure unit
          Just x -> modify_ (\stateRec -> stateRec { queryState = Just x })
      SetChildState -> do
        randomIntValue <- liftEffect $ randomInt 1 200
        void $ H.query _child unit $ H.tell $ SetQueryState randomIntValue

        -- clear parent's memory of what the child's state is
        modify_ (\stateRec -> stateRec { queryState = Nothing })
      SetGetChildState -> do
        randomIntValue <- liftEffect $ randomInt 1 200
        doubledState <- H.query _child unit $ H.request $ SetAndGetDoubledQueryState randomIntValue
        modify_ (\stateRec -> stateRec { queryState = doubledState })

    handleQuery :: forall a. ParentQuery a
                -> H.HalogenM ParentState ParentAction (child :: H.Slot ChildQuery String Unit) Void Aff (Maybe a)
    handleQuery = case _ of
      SetParentState nextInt next -> do
        modify_ (\stateRecord -> stateRecord { latestInt = nextInt })
        pure $ Just next
