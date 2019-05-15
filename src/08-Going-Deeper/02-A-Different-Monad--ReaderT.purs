module GoingDeeper.ADifferentMonad.ReaderT where

import Prelude

import CSS (backgroundColor, em, lightgreen, padding)
import Control.Monad.Reader (runReaderT)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (class MonadEffect)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)
import Web.HTML (window)
import Web.HTML.Window (alert)

main :: Effect Unit
main =
    launchAff_ do
      body <- awaitBody
      let topLevelComponent = H.hoist (\app -> runReaderT app unit) specialMonadComponent
      runUI topLevelComponent unit body

-- Below is a button component that, when clicked,
-- prints an alert to the screen

type State = Unit
type Input = Unit
type Message = Int
data Action = PrintAlert
type Query = Const Void
type NoChildSlots = ()

specialMonadComponent :: forall m
                       . MonadEffect m
                      => H.Component HH.HTML Query Input Message m
specialMonadComponent =
    H.mkComponent
      { initialState: identity
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    render :: State -> H.ComponentHTML Action NoChildSlots m
    render _ =
        HH.div
          [ CSS.style do
            padding (em 2.0) (em 2.0) (em 2.0) (em 2.0)
            backgroundColor lightgreen
          ]
          [ HH.button
            [ HE.onClick \_ -> Just PrintAlert ]
            [ HH.text $ "Click this button to print an alert to the screen."
            ]
          ]

    handleAction :: Action -> H.HalogenM State Action NoChildSlots Message m Unit
    handleAction = case _ of
      PrintAlert -> do
        liftEffect do
          window >>= alert "We're using a non-Aff monad here"
