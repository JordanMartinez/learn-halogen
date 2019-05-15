module ParentChildRelationships.ParentlikeComponents.SingleChild.InputOnly where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Scaffolding.ParentChildRenderer.ParentlikeComponents.SingleChildInputOnlyRenderer (ParentAction(..), RenderParentWithInputOnlyChild, runParentWithInputOnlyChild, singleChild_input_NoMessageNoQuery)

main :: Effect Unit
main = runParentWithInputOnlyChild renderParentWithInputOnlyChild

renderParentWithInputOnlyChild :: RenderParentWithInputOnlyChild
renderParentWithInputOnlyChild childComponent inputValue =
  HH.div_
    [ HH.div_ [ HH.text "This is the parent component " ]
    , HH.button
      [ HE.onClick \_ -> Just RandomState]
      [ HH.text "Click to send a random integer (the `input` value) \
                \to the child"
      ]
    , singleChild_input_NoMessageNoQuery childComponent inputValue
    ]
