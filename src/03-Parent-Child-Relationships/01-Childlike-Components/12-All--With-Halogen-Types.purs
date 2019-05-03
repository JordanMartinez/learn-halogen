module ParentChildRelationships.ChildlikeComponents.All.WithHalogenTypes where

import Prelude

import CSS (em, paddingTop)
import Control.Monad.State (get, modify_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE
import Scaffolding.ParentChildRenderer.ChildlikeComponents.AllRenderer (ChildAction(..), ChildInput, ChildMessage, ChildQuery(..), ChildState, runChildComponent)

main :: Effect Unit
main = runChildComponent childComponent

-- | ChildSlots don't come into play until one creates a parent-like
-- | component. For right now, understand that this means our
-- | child-like component has no children.
-- | Whatever you do, do not modify this.
type NoChildSlots = ()

-- | We'll cover this part later. Whatever you do, do not modify this.
type MonadType = Aff

-- | This is how we define a component in Halogen. Not all of its values
-- | have been explained yet, but this covers 70% of them.
childComponent :: H.Component HH.HTML ChildQuery ChildInput ChildMessage MonadType
childComponent =
    H.mkComponent
      { initialState
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , receive = receive
                                       , handleQuery = handleQuery
                                       }
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
    renderSectionHeader :: String -> H.ComponentHTML ChildAction NoChildSlots Aff
    renderSectionHeader header =
      HH.div
        [ CSS.style do
          paddingTop $ em 1.0
        ]
        [ HH.text $ "The " <> header <> " part" ]

    render :: ChildState -> H.ComponentHTML ChildAction NoChildSlots Aff
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
                 -> H.HalogenM ChildState ChildAction NoChildSlots ChildMessage Aff Unit
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
                -> H.HalogenM ChildState ChildAction NoChildSlots ChildMessage Aff (Maybe a)
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
