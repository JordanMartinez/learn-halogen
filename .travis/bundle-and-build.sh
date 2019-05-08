#!/usr/bin/env bash

# Ensure all Spago bundle and parcel build commands actually work.
# Rather than using `parcel serve`, we'll use `parcel build`.

# Static HTML
spago bundle -m StaticHTML.StaticHTML -t assets/static-html/static-html.js
STATIC_HTML_BUNDLE=$?
parcel build assets/static-html/static-html.html -o static-html--parcelified.html
STATIC_HTML_BUILD=$?

# Adding properties
spago bundle -m StaticHTML.AddingProperties -t assets/static-html/adding-properties.js
ADDING_PROPERTIES_BUNDLE=$?
parcel build assets/static-html/adding-properties.html -o adding-properties--parcelified.html
ADDING_PROPERTIES_BUILD=$?

# Adding CSS
spago bundle -m StaticHTML.AddingCSS -t assets/static-html/adding-css.js
ADDING_CSS_BUNDLE=$?
parcel build assets/static-html/adding-css.html -o adding-css--parcelified.html
ADDING_CSS_BUILD=$?

# Adding state
spago bundle -m DynamicHtml.AddingState -t assets/dynamic-html/adding-state.js
ADDING_STATE_BUNDLE=$?
parcel build assets/dynamic-html/adding-state.html -o adding-state--parcelified.html
ADDING_STATE_BUILD=$?

# Adding event handling
spago bundle -m DynamicHtml.AddingEventHandling -t assets/dynamic-html/adding-event-handling.js
ADDING_EVENT_HANDLING_BUNDLE=$?
parcel build assets/dynamic-html/adding-event-handling.html -o adding-event-handling--parcelified.html
ADDING_EVENT_HANDLING_BUILD=$?

# Input only
spago bundle -m ParentChildRelationships.ChildlikeComponents.InputOnly -t assets/parent-child-relationships/childlike-components/input-only.js
INPUT_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/input-only.html -o child-input-only--parcelified.html
INPUT_ONLY_BUILD=$?

# Message only
spago bundle -m ParentChildRelationships.ChildlikeComponents.MessageOnly -t assets/parent-child-relationships/childlike-components/message-only.js
MESSAGE_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/message-only.html -o child-message-only--parcelified.html
MESSAGE_ONLY_BUILD=$?

spago bundle -m ParentChildRelationships.ChildlikeComponents.QueryOnly -t assets/parent-child-relationships/childlike-components/query-only.js
QUERY_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/query-only.html -o child-query-only--parcelified.html
QUERY_ONLY_BUILD=$?

# All No Halogen Types
spago bundle -m ParentChildRelationships.ChildlikeComponents.All.NoHalogenTypes -t assets/parent-child-relationships/childlike-components/all--no-halogen-types.js
ALL_NO_HALOGEN_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/all--no-halogen-types.html -o child-all--no-halogen-types--parcelified.html
ALL_NO_HALOGEN_BUILD=$?

# All With Halogen Types
spago bundle -m ParentChildRelationships.ChildlikeComponents.All.WithHalogenTypes -t assets/parent-child-relationships/childlike-components/all--with-halogen-types.js
ALL_WITH_HALOGEN_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/all--with-halogen-types.html -o child-all--with-halogen-types--parcelified.html
ALL_WITH_HALOGEN_BUILD=$?

# Basic Container
spago bundle -m ParentChildRelationships.ParentlikeComponents.BasicContainer -t assets/parent-child-relationships/parentlike-components/basic-container.js
BASIC_CONTAINER_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/basic-container.html -o basic-container--parcelified.html
BASIC_CONTAINER_BUILD=$?

# Input Only
spago bundle -m ParentChildRelationships.ParentlikeComponents.SingleChild.InputOnly -t assets/parent-child-relationships/parentlike-components/single-child/parent-input-only.js
PARENT_INPUT_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/single-child/parent-input-only.html -o parent-input-only--parcelified.html
PARENT_INPUT_ONLY_BUILD=$?

# Message Only
spago bundle -m ParentChildRelationships.ParentlikeComponents.SingleChild.MessageOnly -t assets/parent-child-relationships/parentlike-components/single-child/parent-message-only.js
PARENT_MESSAGE_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/single-child/parent-message-only.html -o parent-message-only--parcelified.html
PARENT_MESSAGE_ONLY_BUILD=$?

# Query Only
spago bundle -m ParentChildRelationships.ParentlikeComponents.SingleChild.QueryOnly -t assets/parent-child-relationships/parentlike-components/single-child/parent-query-only.js
PARENT_QUERY_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/single-child/parent-query-only.html -o parent-query-only--parcelified.html
PARENT_QUERY_ONLY_BUILD=$?

spago bundle -m ParentChildRelationships.ParentlikeComponents.MultipleChildren.RevealingChildSlots -t assets/parent-child-relationships/parentlike-components/multiple-children/revealing-child-slots.js
REVEAL_CHILD_SLOTS_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/multiple-children/revealing-child-slots.html -o revealing-child-slots--parcelified.html
REVEAL_CHILD_SLOTS_BUILD=$?

spago bundle -m ParentChildRelationships.ParentlikeComponents.MultipleChildren.MultipleSlots -t assets/parent-child-relationships/parentlike-components/multiple-children/multi-child-slots.js
MULTI_CHILD_SLOTS_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/multiple-children/multi-child-slots.html -o multi-child-slots--parcelified.html
MULTI_CHILD_SLOTS_BUILD=$?

spago bundle -m Driver.RunningComponents -t assets/driver/running-components.js
DRIVER_RUN_COMPONENTS_BUNDLE=$?
parcel build assets/driver/running-components.html -o running-components--parcelified.html
DRIVER_RUN_COMPONENTS_BUILD=$?

spago bundle -m Driver.EmbeddingComponents -t assets/driver/embedding-components.js
DRIVER_EMBED_COMPONENTS_BUNDLE=$?
parcel build assets/driver/embedding-components.html -o embedding-components--parcelified.html
DRIVER_EMBED_COMPONENTS_BUILD=$?

spago bundle -m Driver.QueryingComponents -t assets/driver/querying-components.js
DRIVER_QUERYING_COMPONENTS_BUNDLE=$?
parcel build assets/driver/querying-components.html -o querying-components--parcelified.html
DRIVER_QUERYING_COMPONENTS_BUILD=$?

####
echo "$STATIC_HTML_BUNDLE - Static HTML - Bundle"
echo "$STATIC_HTML_BUILD - Static HTML - Build"
echo "$ADDING_PROPERTIES_BUNDLE - Adding Properties - Bundle"
echo "$ADDING_PROPERTIES_BUILD - Adding Properties - Build"
echo "$ADDING_CSS_BUNDLE - Adding CSS - Bundle"
echo "$ADDING_CSS_BUILD - Adding CSS - Build"
echo "$ADDING_STATE_BUNDLE - Adding State - Bundle"
echo "$ADDING_STATE_BUILD - Adding State - Build"
echo "$ADDING_EVENT_HANDLING_BUNDLE - Adding Event Handling - Bundle"
echo "$ADDING_EVENT_HANDLING_BUILD - Adding Event Handling - Build"
echo "$INPUT_ONLY_BUNDLE - Input only - Bundle"
echo "$INPUT_ONLY_BUILD - Input only - Build"
echo "$MESSAGE_ONLY_BUNDLE - Message only - Bundle"
echo "$MESSAGE_ONLY_BUILD - Message only - Build"
echo "$QUERY_ONLY_BUNDLE - Query only - Bundle"
echo "$QUERY_ONLY_BUILD -  Query only - Build"
echo "$ALL_NO_HALOGEN_BUNDLE - All (No Halogen Types) - Bundle"
echo "$ALL_NO_HALOGEN_BUILD - All (No Halogen Types) - Build"
echo "$ALL_WITH_HALOGEN_BUNDLE - All (With Halogen Types) - Bundle"
echo "$ALL_WITH_HALOGEN_BUILD - All (With Halogen Types) - Build"
echo "$BASIC_CONTAINER_BUNDLE - Basic Container - Bundle"
echo "$BASIC_CONTAINER_BUILD - Basic Container - Build"
echo "$PARENT_INPUT_ONLY_BUNDLE - Parent Input Only - Bundle"
echo "$PARENT_INPUT_ONLY_BUILD - Parent Input Only - Build"
echo "$PARENT_MESSAGE_ONLY_BUNDLE - Parent Message Only - Bundle"
echo "$PARENT_MESSAGE_ONLY_BUILD - Parent Message Only - Build"
echo "$PARENT_QUERY_ONLY_BUNDLE - Parent Query only - Bundle"
echo "$PARENT_QUERY_ONLY_BUILD - Parent Query only - Build"
echo "$REVEAL_CHILD_SLOTS_BUNDLE - Reveal child slots - Bundle"
echo "$REVEAL_CHILD_SLOTS_BUILD - Reveal child slots - Build"
echo "$MULTI_CHILD_SLOTS_BUNDLE - Multi child slots - Bundle"
echo "$MULTI_CHILD_SLOTS_BUILD - Multi child slots - Build"
echo "$DRIVER_RUN_COMPONENTS_BUNDLE - Driver - Run components - Bundle"
echo "$DRIVER_RUN_COMPONENTS_BUILD - Driver - Run components - Build"
echo "$DRIVER_EMBED_COMPONENTS_BUNDLE - Driver - Embed components - Bundle"
echo "$DRIVER_EMBED_COMPONENTS_BUILD - Driver - Embed components - Bundle"
echo "$DRIVER_QUERYING_COMPONENTS_BUNDLE - Driver - Querying Components - Bundle"
echo "$DRIVER_QUERYING_COMPONENTS_BUILD - Driver - Querying Components - Build"

if [ $STATIC_HTML_BUNDLE == 0 ] &&
   [ $STATIC_HTML_BUILD == 0 ] &&
   [ $ADDING_PROPERTIES_BUNDLE == 0 ] &&
   [ $ADDING_PROPERTIES_BUILD == 0 ] &&
   [ $ADDING_CSS_BUNDLE == 0 ] &&
   [ $ADDING_CSS_BUILD == 0 ] &&
   [ $ADDING_STATE_BUNDLE == 0 ] &&
   [ $ADDING_STATE_BUILD == 0 ] &&
   [ $ADDING_EVENT_HANDLING_BUNDLE == 0 ] &&
   [ $ADDING_EVENT_HANDLING_BUNDLE == 0 ] &&
   [ $INPUT_ONLY_BUNDLE == 0 ] &&
   [ $INPUT_ONLY_BUILD == 0 ] &&
   [ $MESSAGE_ONLY_BUNDLE == 0 ] &&
   [ $MESSAGE_ONLY_BUILD == 0 ] &&
   [ $QUERY_ONLY_BUNDLE == 0 ] &&
   [ $QUERY_ONLY_BUILD == 0 ] &&
   [ $ALL_NO_HALOGEN_BUNDLE == 0 ] &&
   [ $ALL_NO_HALOGEN_BUILD == 0 ] &&
   [ $ALL_WITH_HALOGEN_BUNDLE == 0 ] &&
   [ $ALL_WITH_HALOGEN_BUILD == 0 ] &&
   [ $BASIC_CONTAINER_BUNDLE == 0 ] &&
   [ $BASIC_CONTAINER_BUILD == 0 ] &&
   [ $PARENT_INPUT_ONLY_BUNDLE == 0 ] &&
   [ $PARENT_INPUT_ONLY_BUILD == 0 ] &&
   [ $PARENT_MESSAGE_ONLY_BUNDLE == 0 ] &&
   [ $PARENT_MESSAGE_ONLY_BUILD == 0 ] &&
   [ $PARENT_QUERY_ONLY_BUNDLE == 0 ] &&
   [ $PARENT_QUERY_ONLY_BUILD == 0 ] &&
   [ $REVEAL_CHILD_SLOTS_BUNDLE == 0 ] &&
   [ $REVEAL_CHILD_SLOTS_BUILD == 0 ] &&
   [ $MULTI_CHILD_SLOTS_BUNDLE == 0 ] &&
   [ $MULTI_CHILD_SLOTS_BUILD == 0 ] &&
   [ $DRIVER_RUN_COMPONENTS_BUNDLE == 0 ] &&
   [ $DRIVER_RUN_COMPONENTS_BUILD == 0 ] &&
   [ $DRIVER_EMBED_COMPONENTS_BUNDLE == 0 ] &&
   [ $DRIVER_EMBED_COMPONENTS_BUILD == 0 ] &&
   [ $DRIVER_QUERYING_COMPONENTS_BUNDLE == 0 ] &&
   [ $DRIVER_QUERYING_COMPONENTS_BUILD == 0 ]
then
  echo "Build Succeeded"
  exit 0;
else
  echo "Build Failed"
  exit 1;
fi
