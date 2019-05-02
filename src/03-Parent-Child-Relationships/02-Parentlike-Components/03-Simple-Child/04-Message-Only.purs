module ParentChildRelationships.ParentlikeComponents.SimpleChild.MessageOnly where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.HTML as HH
import Scaffolding.ParentChildRenderer.ParentlikeComponents.SingleChildMessageOnlyRenderer (ParentAction(..), RenderParentWithMessageOnlyChild, runParentWithMessageOnlyChild, singleChild_message_NoInputNoQuery)

main :: Effect Unit
main = runParentWithMessageOnlyChild renderParentWithMessageOnlyChild

-- | A basic parent that only acts like a container.
-- | To keep things simpler, it is static and only renders a static child.
renderParentWithMessageOnlyChild :: RenderParentWithMessageOnlyChild
renderParentWithMessageOnlyChild childComponent parentState =
  HH.div_
    [ HH.div_ [ HH.text "This is the parent component " ]
    , HH.div_ [ HH.text $ "Received from child: " <> parentState ]
    , singleChild_message_NoInputNoQuery childComponent
        (\childMessage -> Just $ UpdateState childMessage)
    ]
