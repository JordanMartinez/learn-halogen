module GoingDeeper.ADifferentMonad.ReaderT where

import Prelude

import CSS (backgroundColor, em, lightgreen, padding)
import Control.Monad.Reader (class MonadAsk, ask, asks, runReaderT)
import Control.Monad.Reader.Trans (ReaderT)
import Control.Monad.Trans.Class as MonadTrans
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)
import Type.Equality (class TypeEquals)
import Type.Equality as TypeEquals
import Web.HTML (window)
import Web.HTML.Window (alert)

type Env = { name :: String }
newtype AppM a = AppM (ReaderT Env Aff a)

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

-- workaround for allowing type synonyms inside type class instances
instance monadAsk :: (TypeEquals e Env) => MonadAsk e AppM where
  ask = AppM (asks $ TypeEquals.from)

runAppM :: Env -> AppM ~> Aff
runAppM env (AppM program) = runReaderT program env

main :: Effect Unit
main =
    launchAff_ do
      body <- awaitBody
      let env = { name: "PureScript" }
      let topLevelComponent = H.hoist (\app -> runAppM env app) specialMonadComponent
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
                      => MonadAsk Env m
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
        rec <- MonadTrans.lift $ ask
        liftEffect do
          window >>= alert ("We're using a non-Aff monad here. Name: " <>
                            rec.name)
