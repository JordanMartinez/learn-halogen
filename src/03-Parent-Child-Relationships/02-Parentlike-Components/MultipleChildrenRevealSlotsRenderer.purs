module Scaffolding.ParentChildRenderer.ParentlikeComponents.MultipleChildrenRevealSlotsRenderer
  (runRevealSlotComponent)
  where

import Prelude

import Data.Const (Const)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

runRevealSlotComponent :: H.Component HH.HTML (Const Void) Unit Void Aff -> Effect Unit
runRevealSlotComponent component = do
  launchAff_ do
    body <- awaitBody
    runUI component unit body
