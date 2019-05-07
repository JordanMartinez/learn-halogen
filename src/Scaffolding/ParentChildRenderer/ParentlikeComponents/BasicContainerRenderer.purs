module Scaffolding.ParentChildRenderer.ParentlikeComponents.BasicContainerRenderer
  ( StaticHtmlWithSingleChildComponent
  , RenderOnlyChildComponent
  , BasicParentContainer
  , runBasicContainerComponent
  , singleChild_noInputNoMessageNoQuery
  )
  where

import Prelude

import CSS (backgroundColor, fontSize, orange, padding, px)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.CSS as CSS
import Halogen.VDom.Driver (runUI)
import Scaffolding.StaticRenderer (StaticHTML)

-- | A static html value that can also render a component
type StaticHtmlWithSingleChildComponent =
  H.ComponentHTML
    Void
    (child :: H.Slot
                (Const Unit) -- no query type
                Void         -- no message type
                Unit         -- single child, so only unit for slot index
    )
    Aff

_child :: SProxy "child"
_child = SProxy

-- | A child component that only renders static html. It does not have state,
-- | respond to input, raise messages, or respond to queries.
type RenderOnlyChildComponent = H.Component HH.HTML (Const Unit) Unit Void Aff

-- | A parent component that, when given the child component, will render
-- | itself and the child component. No other interaction occurs between them
-- | (e.g. input, messages, queries).
type BasicParentContainer =
  (RenderOnlyChildComponent -> StaticHtmlWithSingleChildComponent)

-- | Runs a `BasicParentContainer`, so that we can see our component in action.
runBasicContainerComponent :: BasicParentContainer
                           -> Effect Unit
runBasicContainerComponent renderParent = do
  launchAff_ do
    body <- awaitBody
    let parentHtml = renderParent simpleChildComponent
    runUI (basicContainerComponent parentHtml) unit body

type RenderOnlyParentComponent = H.Component HH.HTML (Const Unit) Unit Void Aff

-- | Wraps Halogen types cleanly, so that one gets very clear compiler errors
basicContainerComponent :: StaticHtmlWithSingleChildComponent
                        -> RenderOnlyParentComponent
basicContainerComponent staticHtml =
  H.mkComponent
    { initialState: \_ -> unit
    , render: const staticHtml
    , eval: H.mkEval H.defaultEval
    }

-- | Renders a child that does not respond to input, raise messages, or respond
-- | to queries inside of a parent component
singleChild_noInputNoMessageNoQuery :: RenderOnlyChildComponent -> StaticHtmlWithSingleChildComponent
singleChild_noInputNoMessageNoQuery childComp =
  HH.slot _child unit childComp unit (const Nothing)

-- | A simple child component that only renders content to the screen
simpleChildComponent :: RenderOnlyChildComponent
simpleChildComponent =
    H.mkComponent
      { initialState: \_ -> unit
      , render: const render
      , eval: H.mkEval H.defaultEval
      }
  where
    render :: StaticHTML
    render =
      HH.div
        [ CSS.style do
            fontSize $ px 20.0
            backgroundColor orange
            padding (px 20.0) (px 20.0) (px 20.0) (px 20.0)
        ]
        [ HH.text "This is the child component" ]
