module Scaffolding.StaticRenderer (runStaticComponent, StaticRenderer) where

import Prelude

import Data.Const (Const)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

type StaticRenderer = H.ComponentHTML Unit () Aff

-- | Renders the static HTML once the body element becomes available.
runStaticComponent :: StaticRenderer -> Effect Unit
runStaticComponent rendererFunction = do
  launchAff_ do
    body <- awaitBody
    runUI (staticComponent rendererFunction) unit body

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
staticComponent :: StaticRenderer
                -> H.Component HH.HTML (Const Unit) Unit Void Aff
staticComponent staticHtml =
  H.mkComponent
    { initialState: const unit
    , render: \_ -> staticHtml
    , eval: H.mkEval H.defaultEval
    }
