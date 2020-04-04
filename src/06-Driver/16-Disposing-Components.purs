module Driver.DisposingComponents where

import Prelude

import CSS (backgroundColor, em, lightgreen, padding)
import Control.Monad.State (put)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), delay, forkAff)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main =
    runHalogenAff do
      body <- awaitBody
      let totalMilliseconds = 5000.0
      let increment = 100.0
      io <- runUI topLevelComponent totalMilliseconds body

      forkAff do
        countdown io totalMilliseconds increment
  where
    countdown io secondsRemaining increment = do
      delay (Milliseconds increment)
      let remaining = secondsRemaining - increment
      if remaining <= 0.0
        then do
          io.dispose
        else do
          void $ io.query $ H.tell $ SetCountDownState remaining
          countdown io remaining increment

-- Below is a component that doesn't render anything interesting
-- but can respond to queries.

type State = Number
type Input = Number
type Message = Void
type Action = Void
data Query a = SetCountDownState State a
type NoChildSlots = ()
type MonadType = Aff

topLevelComponent :: H.Component HH.HTML Query Input Message MonadType
topLevelComponent =
    H.mkComponent
      { initialState: identity
      , render
      , eval: H.mkEval $ H.defaultEval { handleQuery = handleQuery }
      }
  where
    render :: State -> H.ComponentHTML Action NoChildSlots Aff
    render remainingMilliseconds =
        HH.div
          [ CSS.style do
            padding (em 2.0) (em 2.0) (em 2.0) (em 2.0)
            backgroundColor lightgreen
          ]
          [ HH.div_
            [ HH.text $ "This component will disappear in " <>
                         remaining <> " seconds."
            ]
          ]
      where
        remaining = show $ remainingMilliseconds / 1000.0

    handleQuery :: forall a. Query a
                -> H.HalogenM State Action NoChildSlots Message Aff (Maybe a)
    handleQuery = case _ of
      SetCountDownState newState next -> do
        put newState
        pure $ Just next
