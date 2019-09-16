module Scaffolding.DynamicRenderer.StateAndEval (runStateAndActionComponent, DynamicHtml, StateAndActionRenderer, HandleSimpleAction, SimpleChildComponent) where

import Prelude

import Data.Const (Const)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen (ComponentHTML)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

-- | Renders HTML that can respond to events by translating them
-- | into a value of the `action` that one uses to handle the event.
type DynamicHtml action = ComponentHTML action () Aff

-- | A function that uses the `state` type's value to render HTML
-- | with simple event-handling via the `action` type.
type StateAndActionRenderer state action = (state -> DynamicHtml action)

-- | When an `action` type's value is received, this function
-- | determines how to update the component (e.g. state updates).
type HandleSimpleAction state action =
  (action -> H.HalogenM state action () Void Aff Unit)

-- | Combines all the code we need to define a simple componenet that supports
-- | state and simple event handling
type SimpleChildComponent state action =
  { initialState :: state
  , render :: StateAndActionRenderer state action
  , handleAction :: HandleSimpleAction state action
  }

-- | Uses the `state` type's value to render dynamic HTML
-- | with event handling via the `action` type.
runStateAndActionComponent :: forall state action.
                               SimpleChildComponent state action
                            -> Effect Unit
runStateAndActionComponent childSpec = do
  launchAff_ do
    body <- awaitBody
    runUI (stateAndActionCompontent childSpec) unit body

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
stateAndActionCompontent :: forall state action.
                            SimpleChildComponent state action
                         -> H.Component HH.HTML (Const Unit) Unit Void Aff
stateAndActionCompontent spec =
  H.mkComponent
    { initialState: const spec.initialState
    , render: spec.render
    , eval: H.mkEval $ H.defaultEval { handleAction = spec.handleAction }
    }
