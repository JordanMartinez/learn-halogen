module DynamicHtml.AddingState where

import Prelude

import Effect (Effect)
import Halogen.HTML as HH
import Scaffolding.DynamicRenderer.StateOnly (runStateOnlyDynamicRenderer)
import Scaffolding.StaticRenderer (StaticHTML)

main :: Effect Unit
main =
  -- We're going to run the same function below 3 times using
  -- the 3 values provided here.
  runStateOnlyDynamicRenderer 1 2 3 simpleIntState

-- | Shows how to use Halogen VDOM DSL to render dynamic HTML
-- | (no event handling) based on the state value received.
simpleIntState :: Int -> StaticHTML
simpleIntState state =
  HH.div_ [ HH.text $ "The state was: " <> show state ]
