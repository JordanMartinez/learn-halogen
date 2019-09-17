module ParentChildRelationships.ChildlikeComponents.All.NoHalogenTypes where

import Prelude

-- Imports for lesson
import CSS (em, paddingTop)
import Control.Monad.State (get, modify_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE

-- Imports for scaffolded code
import CSS (backgroundColor, lightblue, lightgreen, padding, paddingLeft)
import Control.Monad.Rec.Class (forever)
import Data.Array ((:))
import Data.Maybe (maybe)
import Data.Symbol (SProxy(..))
import Effect.Aff (Milliseconds(..), delay, forkAff, launchAff_)
import Effect.Random (randomInt)
import Halogen (liftEffect)
import Halogen.Aff (awaitBody)
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = runChildComponentSpec childComponentSpec

type ChildInput = Int
type ChildState = { intValue :: Int
                  , toggleState :: Boolean
                  , counter :: Int
                  , queryState :: QueryState
                  }
type QueryState = Int
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

-- | We'll cover this part later. Whatever you do, do not change this.
type MonadType = Aff

childComponentSpec :: StateActionQueryInputMessageChildComponentSpec
childComponentSpec =
      { initialState
      , receive
      , render
      , handleAction
      , handleQuery
      }
  where
    initialState :: ChildInput -> ChildState
    initialState input =
      { intValue: input
      , toggleState: false
      , counter: 0
      , queryState: 42
      }

    receive :: ChildInput -> Maybe ChildAction
    receive nextInputIntVal = Just $ ReceiveParentInput nextInputIntVal

    -- | Reduce some of the duplicate code
    renderSectionHeader :: String -> ChildHtml
    renderSectionHeader header =
      HH.div
        [ CSS.style do
          paddingTop $ em 1.0
        ]
        [ HH.text $ "The " <> header <> " part" ]

    render :: ChildState -> ChildHtml
    render state =
      HH.div_
        [ HH.div_
          [ HH.text $ "The input part" ]
        , HH.div_
          [ HH.text $ "The next integer is: " <> show state.intValue
          , HH.div_
            [ HH.button
              [ HE.onClick \_ -> Just ToggleButton ]
              [ HH.text $ "Button state: " <> show state.toggleState ]
            ]
          ]

        , HH.div
          [ CSS.style do
            paddingTop $ em 1.0
          ]
          [ HH.text $ "The query part" ]
        , HH.div_
          [ HH.text $ "The query state is: " <> show state.queryState ]

        , HH.div
          [ CSS.style do
            paddingTop $ em 1.0
          ]
          [ HH.text $ "The message part" ]
        , HH.div_
            [ HH.div_
              [ HH.button
                [ HE.onClick \_ -> Just $ NotifyParentTextMessage yourMessage ]
                [ HH.text $ "Log '" <> yourMessage <> "' to the page."]]
            , HH.div
              [ CSS.style do
                paddingTop $ em 1.0
              ]
              [ HH.text $ "Counter state is: " <> show state.counter ]
            , HH.div_
              [ HH.button
                [ HE.onClick \_ -> Just NotifyParentAboutCounterState ]
                [ HH.text "Log current counter value" ]
              ]
            , HH.div_
              [ HH.button
                [ HE.onClick \_ -> Just DecrementCounter ]
                [ HH.text $ "-"]
              , HH.button
                [ HE.onClick \_ -> Just IncrementCounter ]
                [ HH.text $ "+"]
              ]
            ]
        ]
      where
        yourMessage = "Insert your message here"

    handleAction :: ChildAction
                 -> RunChildAction
    handleAction = case _ of
      ToggleButton -> do
        modify_ (\oldState -> oldState { toggleState = not oldState.toggleState })
      ReceiveParentInput input -> do
        modify_ (\oldState -> oldState { intValue = input })

      IncrementCounter -> do
        modify_ (\oldState -> oldState { counter = oldState.counter + 1 })
      DecrementCounter -> do
        modify_ (\oldState -> oldState { counter = oldState.counter - 1 })
      NotifyParentAboutCounterState -> do
        currentState <- get
        H.raise $ show currentState.counter
      NotifyParentTextMessage message -> do
        H.raise $ message

    handleQuery :: forall a. ChildQuery a
                -> RunChildQuery a
    handleQuery = case _ of
      GetQueryState reply -> do
        state <- get
        pure (Just $ reply state.queryState)
      SetQueryState nextState next -> do
        modify_ (\state -> state { queryState = nextState })
        pure (Just next)
      SetAndGetDoubledQueryState nextState reply -> do
        modify_ (\state -> state { queryState = nextState })
        let doubled = nextState * 2
        pure (Just $ reply doubled)

-- Scaffolded Code --

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

type ChildSlots = ( child :: H.Slot ChildQuery String Unit)

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
    parentHtml :: ParentState -> H.ComponentHTML ParentAction ChildSlots Aff
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

    blankBlockLevelPadding :: H.ComponentHTML ParentAction ChildSlots Aff
    blankBlockLevelPadding =
      HH.div [ CSS.style $ paddingTop $ em 1.0 ] []

    inputHtml :: H.ComponentHTML ParentAction ChildSlots Aff
    inputHtml =
      HH.div_ [ HH.text "The input part will update the child's \
                          \`latestInt` value every 2 seconds."
              ]

    queryControlsHtml :: Maybe Int -> H.ComponentHTML ParentAction ChildSlots Aff
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

    handleAction :: ParentAction
                 -> H.HalogenM ParentState ParentAction ChildSlots Void Aff Unit
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
                -> H.HalogenM ParentState ParentAction ChildSlots Void Aff (Maybe a)
    handleQuery = case _ of
      SetParentState nextInt next -> do
        modify_ (\stateRecord -> stateRecord { latestInt = nextInt })
        pure $ Just next
