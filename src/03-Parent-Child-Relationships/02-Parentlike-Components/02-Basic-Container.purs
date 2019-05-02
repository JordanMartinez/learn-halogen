module ParentChildRelationships.ParentlikeComponents.BasicContainer where

import Prelude

import Effect (Effect)
import Halogen.HTML as HH
import Scaffolding.ParentChildRenderer.ParentlikeComponents.BasicContainerRenderer (BasicParentContainer, runBasicContainerComponent, singleChild_noInputNoMessageNoQuery)

main :: Effect Unit
main = runBasicContainerComponent basicContainer

-- | A basic parent that only acts like a container.
-- | To keep things simpler, it is static and only renders a static child.
basicContainer :: BasicParentContainer
basicContainer childComponent =
  HH.div_
    [ HH.div_ [ HH.text "This is the parent component " ]
    , singleChild_noInputNoMessageNoQuery childComponent
    ]
