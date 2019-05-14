module Main where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), delay, launchAff_)
import Effect.Console (log)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  launchAff_ do
    body <- awaitBody
    io <- runUI childLifecycleComponent unit body
    delay $ Milliseconds 3000.0
    io.dispose

type State = Unit
type Input = Unit
type Message = Unit
data Action
  = ButtonClicked
  | Initialize
  | Finalize

type Query = Const Void
type NoChildSlots = ()
type MonadType = Aff

childLifecycleComponent :: H.Component HH.HTML Query Input Message MonadType
childLifecycleComponent =
    H.mkComponent
      { initialState: identity
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                       , initialize = Just Initialize
                                       , finalize = Just Finalize
                                       }
      }
  where
    render :: State -> H.ComponentHTML Action NoChildSlots Aff
    render _ =
        HH.button
            [ HE.onClick \_ -> Just ButtonClicked ]
            [ HH.text $ "Click me."
            ]

    handleAction :: Action
                 -> H.HalogenM State Action NoChildSlots Message Aff Unit
    handleAction = case _ of
      Initialize -> do
        liftEffect $ log "Component was initialized"
      ButtonClicked -> do
        liftEffect $ log "Button was clicked!"
      Finalize -> do
        liftEffect $ log "Component was removed"
