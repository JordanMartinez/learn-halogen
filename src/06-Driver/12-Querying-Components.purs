module Driver.QueryingComponents where

import Prelude

import CSS (backgroundColor, em, lightgreen, padding)
import Control.Monad.State (get, put)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Console (log)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.VDom.Driver (runUI)

-- | Here we get the 'return value' of the monadic `runUI` function,
-- | which is a record with the type, `HalogenIO`.
-- | We use this record to communicate with our component.
main :: Effect Unit
main =
    runHalogenAff do
      body <- awaitBody
      io <- runUI topLevelComponent unit body

      getAndPrintState io
      setState io 4
      getAndPrintState io
  where
    getAndPrintState io = do
      requestResult <- io.query $ H.request $ GetComponentState
      let requestMessage = maybe "<unknown>" show requestResult
      liftEffect $ log $ "The component's state was: " <> requestMessage

    setState io newState = do
      tellResult <- io.query $ H.tell $ SetComponentState newState
      let tellMessage = maybe "unsuccessful" (const "successful") tellResult
      liftEffect $ log $ "The tell result was: " <> tellMessage

-- Below is a component that doesn't render anything interesting
-- but can respond to queries.

type State = Int
type Input = Unit
type Message = Void
type Action = Void
data Query a
  = GetComponentState (State -> a)
  | SetComponentState State a
type NoChildSlots = ()
type MonadType = Aff

topLevelComponent :: H.Component HH.HTML Query Input Message MonadType
topLevelComponent =
    H.mkComponent
      { initialState: const 42
      , render
      , eval: H.mkEval $ H.defaultEval { handleQuery = handleQuery }
      }
  where
    render :: State -> H.ComponentHTML Action NoChildSlots Aff
    render _ =
      HH.div
        [ CSS.style do
          padding (em 2.0) (em 2.0) (em 2.0) (em 2.0)
          backgroundColor lightgreen
        ]
        [ HH.div_
          [ HH.text "A simple component that only stores some state. \
                    \One can send queries into it."
          ]
        ]

    handleQuery :: forall a. Query a
                -> H.HalogenM State Action NoChildSlots Message Aff (Maybe a)
    handleQuery = case _ of
      GetComponentState reply -> do
        state <- get
        pure $ Just $ reply state
      SetComponentState newState next -> do
        put newState
        pure $ Just next
