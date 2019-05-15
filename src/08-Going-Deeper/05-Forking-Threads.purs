module GoingDeeper.ForkingThreads where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Newtype (over)
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), delay, launchAff_)
import Effect.Console (log)
import Halogen (liftAff, liftEffect)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = launchAff_ do
  body <- awaitBody
  runUI componentWithForking unit body

type StateType = Unit
data ActionType
  = RunSynchronousComputation
  | RunAsynchronousComputation
  | RunAndKillAsyncComputation

type Query = Const Void
type Input = Unit
type Message = Void
type MonadType = Aff
type ChildSlots = ()

componentWithForking :: H.Component HH.HTML Query Input Message MonadType
componentWithForking =
    H.mkComponent
      { initialState: const unit
      , render
      -- Delete the labels that follow `defaultEval` if they aren't be used
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    render :: StateType -> H.ComponentHTML ActionType ChildSlots MonadType
    render _ =
      HH.div_
        [ HH.div_
          [ HH.text "Open your browser's console, then click on the buttons \
                    \below to see how they work."
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just RunSynchronousComputation ]
            [ HH.text "Run computation synchronously" ]
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just RunAsynchronousComputation ]
            [ HH.text "Run computation asynchronously" ]
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just RunAndKillAsyncComputation ]
            [ HH.text "Run a computation asynchronously but kill it before it finishes" ]
          ]
        ]

    computationTimeAmount :: Milliseconds
    computationTimeAmount = Milliseconds 2000.0

    longComputation :: Int -> H.HalogenM StateType ActionType ChildSlots Message MonadType Unit
    longComputation idx = do
      liftEffect $ log $ "Computation " <> show idx <> ": Now starting"
      liftAff $ delay computationTimeAmount
      liftEffect $ log $ "Computation " <> show idx <> ": Finished"

    handleAction :: ActionType
                 -> H.HalogenM StateType ActionType ChildSlots Message MonadType Unit
    handleAction = case _ of
      RunSynchronousComputation -> do
        let idx = 1
        liftEffect $ log $ "Now starting computation " <> show idx
        longComputation idx
        liftEffect $ log $ "Now running other computations " <> show idx
      RunAsynchronousComputation -> do
        let idx = 2
        liftEffect $ log $ "Now starting computation " <> show idx
        forkId <- H.fork $ longComputation idx
        liftEffect $ log $ "Now running other computations " <> show idx
      RunAndKillAsyncComputation -> do
        let idx = 2
        liftEffect $ log $ "Now starting computation " <> show idx
        forkId <- H.fork $ longComputation idx
        liftEffect $ log $ "Now running other computations " <> show idx
        let beforeComputationFinishes =
              over Milliseconds (_ - 1000.0) computationTimeAmount
        liftAff $ delay beforeComputationFinishes
        liftEffect $ log $ "Now killing forked computation " <> show idx
        H.kill forkId
