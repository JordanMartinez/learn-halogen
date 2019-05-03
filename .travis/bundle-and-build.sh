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
parcel build assets/parent-child-relationships/childlike-components/input-only.html -o input-only--parcelified.html
INPUT_ONLY_BUILD=$?

# Message only
spago bundle -m ParentChildRelationships.ChildlikeComponents.MessageOnly -t assets/parent-child-relationships/childlike-components/message-only.js
MESSAGE_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/message-only.html -o message-only--parcelified.html
MESSAGE_ONLY_BUILD=$?

# Input and Message
spago bundle -m ParentChildRelationships.ChildlikeComponents.All -t assets/parent-child-relationships/childlike-components/all.js
ALL_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/all.html -o all--parcelified.html
All_BUILD=$?

# Basic Container
spago bundle -m ParentChildRelationships.ParentlikeComponents.BasicContainer -t assets/parent-child-relationships/parentlike-components/basic-container.js
BASIC_CONTAINER_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/basic-container.html -o basic-container--parcelified.html
BASIC_CONTAINER_BUILD=$?

spago bundle -m ParentChildRelationships.ParentlikeComponents.SimpleChild.InputOnly -t assets/parent-child-relationships/parentlike-components/simple-child/parent-input-only.js
PARENT_INPUT_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/simple-child/parent-input-only.html -o parent-input-only--parcelified.html
PARENT_INPUT_ONLY_BUILD=$?

spago bundle -m ParentChildRelationships.ParentlikeComponents.SimpleChild.MessageOnly -t assets/parent-child-relationships/parentlike-components/simple-child/parent-message-only.js
PARENT_MESSAGE_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/simple-child/parent-message-only.html -o parent-message-only--parcelified.html
PARENT_MESSAGE_ONLY_BUILD=$?

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
echo "$ALL_BUNDLE - Input Message - Bundle"
echo "$ALL_BUILD - Input Message - Build"
echo "$BASIC_CONTAINER_BUNDLE - Basic Container - Bundle"
echo "$BASIC_CONTAINER_BUILD - Basic Container - Build"
echo "$PARENT_INPUT_ONLY_BUNDLE - Parent Input Only - Bundle"
echo "$PARENT_INPUT_ONLY_BUILD - Parent Input Only - Build"
echo "$PARENT_MESSAGE_ONLY_BUNDLE - Parent Message Only - Bundle"
echo "$PARENT_MESSAGE_ONLY_BUILD - Parent Message Only - Build"

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
   [ $ALL_BUNDLE == 0 ] &&
   [ $ALL_BUILD == 0 ] &&
   [ $BASIC_CONTAINER_BUNDLE == 0 ] &&
   [ $BASIC_CONTAINER_BUILD == 0 ] &&
   [ $PARENT_INPUT_ONLY_BUNDLE == 0 ] &&
   [ $PARENT_INPUT_ONLY_BUILD == 0 ] &&
   [ $PARENT_MESSAGE_ONLY_BUNDLE == 0 ] &&
   [ $PARENT_MESSAGE_ONLY_BUILD == 0 ]
then
  echo "Build Succeeded"
  exit 0;
else
  echo "Build Failed"
  exit 1;
fi
