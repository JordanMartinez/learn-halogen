module Driver.SubscribingToMessages where

import Prelude

import CSS (backgroundColor, em, lightgreen, padding)
import Control.Coroutine as CR
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Console (log)
import Effect.Random (randomInt)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
    launchAff_ do
      body <- awaitBody
      io <- runUI topLevelComponent unit body

      io.subscribe $ CR.consumer \raisedIntVal -> do
        liftEffect $ log $
          "Consumer 1: Button was clicked and produced a random integer \
          \value: " <> show raisedIntVal <> "\n\
          \\n\
          \Since this consumer uses `pure $ Just unit`, this consumer \
          \will respond only to the first message raised."
        pure $ Just unit

      io.subscribe $ CR.consumer \raisedIntVal -> do
        liftEffect $ log $
          "Consumer 2: Button was clicked and produced a random integer \
          \value: " <> show raisedIntVal <> "\n\
          \\n\
          \Since this consumer uses `pure Nothing`, this consumer \
          \will respond to every message raised."
        pure Nothing

-- Below is a button component that, when clicked, raises a message that
-- is a random integer value.

type State = Unit
type Input = Unit
type Message = Int
data Action = RaiseMessage
type Query = Const Void
type NoChildSlots = ()
type MonadType = Aff

topLevelComponent :: H.Component HH.HTML Query Input Message MonadType
topLevelComponent =
    H.mkComponent
      { initialState: identity
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    render :: State -> H.ComponentHTML Action NoChildSlots Aff
    render _ =
        HH.div
          [ CSS.style do
            padding (em 2.0) (em 2.0) (em 2.0) (em 2.0)
            backgroundColor lightgreen
          ]
          [ HH.button
            [ HE.onClick \_ -> Just RaiseMessage ]
            [ HH.text $ "Click this button multiple times to raise multiple \
                        \messages and see how messages are handled by \
                        \the Driver."
            ]
          ]

    handleAction :: Action -> H.HalogenM State Action NoChildSlots Message Aff Unit
    handleAction = case _ of
      RaiseMessage -> do
        intVal <- liftEffect $ randomInt 1 200
        H.raise intVal
