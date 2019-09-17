module Lifecycle.Child where

import Prelude

import CSS (backgroundColor, em, lightgreen, padding)
import Control.Monad.State (get)
import Data.Const (Const)
import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Console (log)
import Halogen (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

-- Imports for scaffolding
import Effect.Aff (Milliseconds(..), delay, launchAff_)
import Halogen.Aff (awaitBody)
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = runChildLifecycleComponent childLifecycleComponent

type State = Unit
type Input = Unit
type Message = Void
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
                                       , initialize = initialize
                                       , finalize = finalize
                                       }
      }
  where
    initialize :: Maybe Action
    initialize = Just Initialize

    finalize :: Maybe Action
    finalize = Just Finalize

    render :: State -> H.ComponentHTML Action NoChildSlots Aff
    render _ =
        HH.div
          [ CSS.style do
            padding (em 2.0) (em 2.0) (em 2.0) (em 2.0)
            backgroundColor lightgreen
          ]
          [ HH.button
            [ HE.onClick \_ -> Just ButtonClicked
            , HP.ref (H.RefLabel "button-label")
            ]
            [ HH.text $ "Click me. After 3 seconds, this component will disappear."
            ]
          ]

    handleAction :: Action
                 -> H.HalogenM State Action NoChildSlots Message Aff Unit
    handleAction = case _ of
      Initialize -> do
        liftEffect $ log "Component was initialized"
        state <- get
        liftEffect $ log $ "State is available: " <> show state
        H.getHTMLElementRef (H.RefLabel "button-label") >>= traverse_ \element ->
          liftEffect $ log $ "Element 'button-label' exists."
      ButtonClicked -> do
        liftEffect $ log "Button was clicked!"
      Finalize -> do
        liftEffect $ log "Component was removed"
        state <- get
        liftEffect $ log $ "State is still available: " <> show state
        H.getHTMLElementRef (H.RefLabel "button-label") >>= traverse_ \element ->
          liftEffect $ log $ "Element 'button-label' still exists."

-- Scaffolded Code

runChildLifecycleComponent :: H.Component HH.HTML (Const Void) Unit Void Aff
                           -> Effect Unit
runChildLifecycleComponent comp = do
  launchAff_ do
    body <- awaitBody
    io <- runUI comp unit body
    delay $ Milliseconds 3000.0
    io.dispose
