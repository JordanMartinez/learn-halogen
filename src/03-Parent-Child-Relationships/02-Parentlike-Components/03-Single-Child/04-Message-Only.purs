module ParentChildRelationships.ParentlikeComponents.SingleChild.MessageOnly where

import Prelude

-- Imports for lesson
import Data.Maybe (Maybe(..))
import Halogen.HTML as HH

-- Imports for scaffolding
import Data.Const (Const)
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen (get, put)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = runParentWithMessageOnlyChild renderParentWithMessageOnlyChild

type ParentState = String
data ParentAction = UpdateState ParentState

renderParentWithMessageOnlyChild :: RenderParentWithMessageOnlyChild
renderParentWithMessageOnlyChild parentState =
  HH.div_
    [ HH.div_ [ HH.text "This is the parent component " ]
    , HH.div_ [ HH.text $ "Received from child: " <> parentState ]
    , singleChild_message_NoInputNoQuery childComponent
        (\childMessage -> Just $ UpdateState childMessage)
    ]

-- Scaffolded Code --

-- | A parent component that, when given the child component, will render
-- | itself and the child component. No other interaction occurs between them
-- | (e.g. input, messages, queries).
type RenderParentWithMessageOnlyChild =
  String -> H.ComponentHTML ParentAction ChildSlots Aff

type ChildSlots = (child :: H.Slot (Const Void) String Unit)

-- | Runs a `ParentWithInputOnlyChild`, so that we can see our component in action.
runParentWithMessageOnlyChild :: RenderParentWithMessageOnlyChild
                              -> Effect Unit
runParentWithMessageOnlyChild renderParent = do
  runHalogenAff do
    body <- awaitBody
    runUI (parentComponent renderParent) unit body

type ParentQuery = Const Void
type ParentInput = Unit
type ParentMessage = Void

_child :: SProxy "child"
_child = SProxy

parentComponent :: RenderParentWithMessageOnlyChild
                -> H.Component HH.HTML ParentQuery ParentInput ParentMessage Aff
parentComponent parentRender =
    H.mkComponent
      { initialState: const "empty"
      , render: parentRender
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    handleAction :: ParentAction
                 -> H.HalogenM String ParentAction ChildSlots ParentMessage Aff Unit
    handleAction = case _ of
      UpdateState str -> do
        put str

-- | A child component that renders dynamic html. It has state and
-- | can raise messages, but it does not respond to input or to queries.
type MessageOnlyChildComponent = H.Component HH.HTML (Const Void) Unit String Aff

-- | Renders a child that does not respond to input, raise messages, or respond
-- | to queries inside of a parent component
singleChild_message_NoInputNoQuery :: MessageOnlyChildComponent
                                   -> (String -> Maybe ParentAction)
                                   -> H.ComponentHTML ParentAction ChildSlots Aff
singleChild_message_NoInputNoQuery childComp handleMessage =
  HH.slot _child unit childComp unit handleMessage

data ChildAction = NotifyParent

childComponent :: MessageOnlyChildComponent
childComponent =
    H.mkComponent
      { initialState: initialChildState
      , render: render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    initialChildState :: Unit -> Int
    initialChildState _ = 0

    render :: Int -> H.ComponentHTML ChildAction () Aff
    render _ =
      HH.div_
        [ HH.button
          [ HE.onClick \_ -> Just NotifyParent ]
          [ HH.text "Click me to raise a message to my parent. " ]
        ]

    handleAction :: ChildAction
                 -> H.HalogenM Int ChildAction () String Aff Unit
    handleAction = case _ of
      NotifyParent -> do
        state <- get
        H.raise $ show state
        put (state + 1)
