module ParentChildRelationships.ParentlikeComponents.BasicContainer where

import Prelude

import Halogen.HTML as HH
import CSS (backgroundColor, fontSize, orange, padding, px)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML.CSS as CSS
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  launchAff_ do
    body <- awaitBody
    runUI parentComponent unit body

-- | A static parent that only acts like a container and renders a static child.
-- | No other interaction occurs between parent and child (e.g. input, messages, queries).
parentComponent :: StaticHtmlComponent
parentComponent =
    H.mkComponent
      { initialState: \_ -> unit     -- ignore initial state
      , render: const render
      , eval: H.mkEval H.defaultEval -- ignore actions and queries
      }
  where
    render :: StaticHtmlWithSingleChildComponent
    render =
      HH.div_
        [ HH.div_ [ HH.text "This is the parent component " ]
        , HH.slot -- slot for child component
            _child          -- the slot address label
            unit            -- (unused) the slot address index
            childComponent  -- the child component for the slot
            unit            -- (unused) the input value to pass to the component
            (const Nothing) -- (unused) a function mapping outputs from the component to a query in the parent
        ]

-- | A simple child component that only renders content to the screen
childComponent :: StaticHtmlComponent
childComponent =
    H.mkComponent
      { initialState: \_ -> unit     -- ignore initial state
      , render: const render
      , eval: H.mkEval H.defaultEval -- ignore actions and queries
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

-- | A component that only renders static html. It does not have state,
-- | respond to input, raise messages, or respond to queries.
type StaticHtmlComponent = H.Component HH.HTML (Const Unit) Unit Void Aff

-- | A static html value that can also render a component
type StaticHtmlWithSingleChildComponent =
  H.ComponentHTML
    Void -- Parent actions
    ChildSlots
    Aff

type ChildSlots =
  (child :: H.Slot
              (Const Unit) -- no query type
              Void         -- no message type
              Unit         -- single child, so only unit for slot index
  )

-- | HTML written in Purescript via Halogen's HTML DSL
-- | that is always rendered the same and does not include any event handling.
type StaticHTML = H.ComponentHTML Unit () Aff

-- Create a unique "child" label
_child :: SProxy "child"
_child = SProxy