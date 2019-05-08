module Driver.RunningComponents where

import Prelude

import CSS (backgroundColor, em, lightgreen, padding)
import Control.Monad.State (modify_)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

-- | Here we wait for the `body` element and then run our component
-- | as a child of that element.
main :: Effect Unit
main =
  launchAff_ do
    body <- awaitBody
    let topLevelComponentInput = unit
    runUI topLevelcomponent topLevelComponentInput body

-- Below a simple button component

type ChildState = Boolean
type ChildInput = Unit
type ChildMessage = Void
data ChildAction = ToggleButton
type ChildQuery = Const Void
type NoChildSlots = ()
type MonadType = Aff

topLevelcomponent :: H.Component HH.HTML ChildQuery ChildInput ChildMessage MonadType
topLevelcomponent =
    H.mkComponent
      { initialState: const false
      , render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    render :: ChildState -> H.ComponentHTML ChildAction NoChildSlots Aff
    render state =
      HH.div
        [ CSS.style do
          padding (em 2.0) (em 2.0) (em 2.0) (em 2.0)
          backgroundColor lightgreen
        ]
        [ HH.div_ [ HH.text "A simple button component."]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just ToggleButton ]
            [ HH.text $ "Button state: " <> show state ]
          ]
        ]

    handleAction :: ChildAction
                 -> H.HalogenM ChildState ChildAction NoChildSlots ChildMessage Aff Unit
    handleAction = case _ of
      ToggleButton -> do
        modify_ (\oldState -> not oldState )
