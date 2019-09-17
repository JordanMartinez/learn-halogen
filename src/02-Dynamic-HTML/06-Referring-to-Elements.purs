module DynamicHtml.ReferringToElements where

import Prelude

-- Imports for Lesson
import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Effect.Console (log)
import Halogen (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Events as HE

-- Imports for scaffolded code
import Data.Const (Const)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen (ComponentHTML) -- compiler will say this should be merged
                               -- with above import. Ignore it
import Halogen.Aff (awaitBody)
import Halogen.VDom.Driver (runUI)

type State = Boolean
data Action = PrintExample

renderExample :: StateAndActionRenderer State Action
renderExample state =
  HH.div_
    [ HH.p_ [ HH.text $ "The state of the component is: " <> show state ]
    , HH.button
        [ HE.onClick \_ -> Just PrintExample
        -- here, we label this button as 'my-button', so we can refer to it later
        , HP.ref (H.RefLabel "my-button")
        ]
        [ HH.text $ "Click to print our example to the console." ]
    ]

handleAction :: HandleSimpleAction State Action
handleAction = case _ of
  PrintExample -> do
    -- Here, we use this reference to do something with the element
    H.getHTMLElementRef (H.RefLabel "my-button") >>= traverse_ \element -> do
      -- in this situation, we'll just state that the element exists
      -- and could be used here
      liftEffect $ log "We can now do something directly to the \
                         \button HTML element."

-- Now we can run the code

main :: Effect Unit
main =
  runStateAndActionComponent
    { initialState: false
    , render: renderExample
    , handleAction: handleAction
    }

-- Scaffolded Code --

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
