module Scaffolding.ParentChildRenderer.ParentlikeComponents.SingleChildMessageOnlyRenderer
  ( MessageOnlyChildComponent
  , RenderParentWithMessageOnlyChild
  , ParentAction(..)
  , runParentWithMessageOnlyChild
  , singleChild_message_NoInputNoQuery
  )
  where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Halogen (get, put)
import Halogen as H
import Halogen.Aff (awaitBody)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

-- | A child component that renders dynamic html. It has state and
-- | can raise messages, but it does not respond to input or to queries.
type MessageOnlyChildComponent = H.Component HH.HTML (Const Void) Unit String Aff

-- | A parent component that, when given the child component, will render
-- | itself and the child component. No other interaction occurs between them
-- | (e.g. input, messages, queries).
type RenderParentWithMessageOnlyChild =
  MessageOnlyChildComponent -> String -> H.ComponentHTML ParentAction ( child :: H.Slot (Const Void) String Unit ) Aff

-- | Runs a `ParentWithInputOnlyChild`, so that we can see our component in action.
runParentWithMessageOnlyChild :: RenderParentWithMessageOnlyChild
                            -> Effect Unit
runParentWithMessageOnlyChild renderParent = do
  launchAff_ do
    body <- awaitBody
    runUI (parentComponent renderParent) unit body

data ParentAction = UpdateState String
type ParentQuery = Const Void
type ParentInput = Unit
type ParentMessage = Void

_child = SProxy :: SProxy "child"

parentComponent :: RenderParentWithMessageOnlyChild
                -> H.Component HH.HTML ParentQuery ParentInput ParentMessage Aff
parentComponent parentRender =
    H.mkComponent
      { initialState: const "empty"
      , render: parentRender childComponent
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    handleAction :: ParentAction
                 -> H.HalogenM String ParentAction ( child :: H.Slot (Const Void) String Unit ) ParentMessage Aff Unit
    handleAction = case _ of
      UpdateState str -> do
        put str

-- | Renders a child that does not respond to input, raise messages, or respond
-- | to queries inside of a parent component
singleChild_message_NoInputNoQuery :: MessageOnlyChildComponent
                                   -> (String -> Maybe ParentAction)
                                   -> H.ComponentHTML ParentAction ( child :: H.Slot (Const Void) String Unit ) Aff
singleChild_message_NoInputNoQuery childComp handleMessage =
  HH.slot _child unit childComp unit handleMessage

data ChildAction = NotifyParent
type ChildSlots = ()

childComponent :: H.Component HH.HTML (Const Void) Unit String Aff
childComponent =
    H.mkComponent
      { initialState: initialChildState
      , render: render
      , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
      }
  where
    initialChildState :: Unit -> Int
    initialChildState _ = 0

    render :: Int -> H.ComponentHTML ChildAction ChildSlots Aff
    render _ =
      HH.div_
        [ HH.button
          [ HE.onClick \_ -> Just NotifyParent ]
          [ HH.text "Click me to raise a message to my parent. " ]
        ]

    handleAction :: ChildAction
                 -> H.HalogenM Int ChildAction ChildSlots String Aff Unit
    handleAction = case _ of
      NotifyParent -> do
        state <- get
        H.raise $ show state
        put (state + 1)
