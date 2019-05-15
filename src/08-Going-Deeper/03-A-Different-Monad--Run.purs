module GoingDeeper.ADifferentMonad.Run where

import Prelude

import CSS (backgroundColor, em, lightgreen, padding)
import Data.Const (Const)
import Data.Functor.Variant (on)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen (liftEffect)
import Halogen as H
import Halogen as MonadTrans
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)
import Run (FProxy, Run, SProxy(..), case_, interpret)
import Run as Run
import Type.Row (type (+))
import Web.HTML (window)
import Web.HTML.Window (alert)

-- Our Run monadic type

data PrintAlertEffectsF a = PrintAlertEffect String a

derive instance functorPrintAlertEffectsF :: Functor PrintAlertEffectsF

_printAlertEffect :: SProxy "printAlertEffect"
_printAlertEffect = SProxy

type PRINT_ALERT_EFFECTS r = (printAlertEffect :: FProxy PrintAlertEffectsF | r)

printAlert :: forall r. String -> Run (PRINT_ALERT_EFFECTS + r) Unit
printAlert msg = Run.lift _printAlertEffect $ PrintAlertEffect msg unit

type MonadType = Run (PRINT_ALERT_EFFECTS + ())

-- our algebras
runToAff :: Run (PRINT_ALERT_EFFECTS + ()) ~> Aff
runToAff =
  interpret (
    case_
      # on _printAlertEffect printAlertAlgebra
  )

  where
    printAlertAlgebra :: PrintAlertEffectsF ~> Aff
    printAlertAlgebra = case _ of
      PrintAlertEffect msg next -> do
        liftEffect do
          window >>= alert msg
        pure next

-- Converting the Run type to Aff by hoisting our component

main :: Effect Unit
main =
    launchAff_ do
      body <- awaitBody
      let topLevelComponent = H.hoist (\app -> runToAff app) specialMonadComponent
      runUI topLevelComponent unit body

-- Below is a button component that, when clicked,
-- prints an alert to the screen

type State = Unit
type Input = Unit
type Message = Int
data Action = PrintAlert
type Query = Const Void
type NoChildSlots = ()

specialMonadComponent :: H.Component HH.HTML Query Input Message MonadType
specialMonadComponent =
    H.mkComponent
      { initialState: identity
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    render :: State -> H.ComponentHTML Action NoChildSlots MonadType
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

    handleAction :: Action -> H.HalogenM State Action NoChildSlots Message MonadType Unit
    handleAction = case _ of
      -- Here, we see that we must use MonadTrans.lift to lift Run into HalogenM 
      PrintAlert -> MonadTrans.lift do
        printAlert "We're using a non-Aff monad here"
