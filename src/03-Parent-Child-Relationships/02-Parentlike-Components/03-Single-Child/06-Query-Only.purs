module ParentChildRelationships.ParentlikeComponents.SingleChild.QueryOnly where

import Prelude

import Control.Monad.State (put)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Random (randomInt)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Scaffolding.ParentChildRelationships.ParentlikeComponents.SingleChildQueryOnlyRenderer (ChildQuery(..), ParentAction(..), ParentHtmlWithQueryOnlyChild, QueryOnlyChildComponent, RunParentActionWithQueryOnlyChild, StateActionChildQueryParentSpec, requestInfo, runStateActionChildQueryParentSpec, singleChild_query_noInputNoMessage, tellChildCommand)

main :: Effect Unit
main = runStateActionChildQueryParentSpec stateActionChildQueryParentSpec

-- We'll store the child's state. Since the parent component might not
-- know what that is when it initially renders, we'll wrap it in a Maybe.
type State = Maybe Int

-- Again, due to scaffolding needs and cyclical modules being disallowed,
-- the parent's actions are defined in our scaffolding module.
-- The corresponding scaffolding module's ParentAction is defined like so:
{-
data ParentAction
  = GetChildState
  | SetChildState
  | SetGetDoubledChildState
-}

-- Below is the child's query type
{-
data ChildQuery a
  = GetState (State -> a)
  | SetState State a
  | SetAndGetDoubledState State (State -> a)
-}

stateActionChildQueryParentSpec :: StateActionChildQueryParentSpec
stateActionChildQueryParentSpec =
    { initialState: Nothing
    , render
    , handleAction
    }
  where
    render :: QueryOnlyChildComponent -> State -> ParentHtmlWithQueryOnlyChild
    render childComp state =
      HH.div_
        [ HH.div_ [ HH.text $ "The child's state is: " <> (maybe "<unknown>" show state) ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just GetChildState ]
            [ HH.text "Get child state" ]
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just SetChildState ]
            [ HH.text "Set child state to  random integer and \
                      \clear parent's memory of child state"
            ]
          ]
        , HH.div_
          [ HH.button
            [ HE.onClick \_ -> Just SetGetDoubledChildState ]
            [ HH.text "Set child state to a random integer and \
                      \store (newState * 2) as parent's memory \
                      \of child state"
            ]
          ]
        , HH.div_
          [ singleChild_query_noInputNoMessage childComp ]
        ]

    handleAction :: ParentAction -> RunParentActionWithQueryOnlyChild
    handleAction = case _ of
      GetChildState -> do
        state <- requestInfo $ H.request GetState
        case state of
          Nothing -> pure unit
          justChildState -> put justChildState
      SetChildState -> do
        randomInt <- liftEffect $ randomInt 1 200
        successOrNot <- tellChildCommand $ H.tell $ SetState randomInt
        -- we don't care whether it was successful or not
        -- so just ignore it

        -- now clear out parent component's memory of child's state
        put Nothing
      SetGetDoubledChildState -> do
        randomInt <- liftEffect $ randomInt 1 200
        maybeDoubledState <- requestInfo $ H.request $ SetAndGetDoubledState randomInt
        case maybeDoubledState of
          Nothing -> pure unit
          justDoubledState -> put justDoubledState
