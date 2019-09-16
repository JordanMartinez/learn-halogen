module Scaffolding.StaticRenderer (runStaticHtml, StaticHTML) where

import Prelude

import Data.Const (Const)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

-- | HTML written in Purescript via Halogen's HTML DSL
-- | that is always rendered the same and does not include any event handling.
type StaticHTML = H.ComponentHTML Unit () Aff

-- | Renders the static HTML once the body element becomes available.
runStaticHtml :: StaticHTML -> Effect Unit
runStaticHtml staticHTML = do
  launchAff_ do
    body <- awaitBody
    runUI (staticComponent staticHTML) unit body

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
staticComponent :: StaticHTML
                -> H.Component HH.HTML (Const Unit) Unit Void Aff
staticComponent staticHtml =
  H.mkComponent
    { initialState: const unit
    , render: \_ -> staticHtml
    , eval: H.mkEval H.defaultEval
    }
