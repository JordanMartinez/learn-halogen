module Scaffolding.Lifecycle.LifecycleRenderer (runChildLifecycleComponent) where

import Prelude

import Data.Const (Const)
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), delay, launchAff_)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

runChildLifecycleComponent :: H.Component HH.HTML (Const Void) Unit Void Aff
                           -> Effect Unit
runChildLifecycleComponent comp = do
  launchAff_ do
    body <- awaitBody
    io <- runUI comp unit body
    delay $ Milliseconds 3000.0
    io.dispose
