#!/usr/bin/env bash

# Ensure all Spago bundle and parcel build commands actually work.
#
# This file assumes that `spago build` was called before running this script
# Otherwise, the `--no-build` flag in
# `spago bundle-app -m Main -t file.js --no-build` will cause problems
#
# Rather than using `parcel serve`, we'll use `parcel build`.

# Static HTML
spago bundle-app -m StaticHTML.StaticHTML -t assets/static-html/static-html.js --no-build
STATIC_HTML_BUNDLE=$?
parcel build assets/static-html/static-html.html -o static-html--parcelified.html
STATIC_HTML_BUILD=$?

# Adding properties
spago bundle-app -m StaticHTML.AddingProperties -t assets/static-html/adding-properties.js --no-build
ADDING_PROPERTIES_BUNDLE=$?
parcel build assets/static-html/adding-properties.html -o adding-properties--parcelified.html
ADDING_PROPERTIES_BUILD=$?

# Adding CSS
spago bundle-app -m StaticHTML.AddingCSS -t assets/static-html/adding-css.js --no-build
ADDING_CSS_BUNDLE=$?
parcel build assets/static-html/adding-css.html -o adding-css--parcelified.html
ADDING_CSS_BUILD=$?

# Adding state
spago bundle-app -m DynamicHtml.AddingState -t assets/dynamic-html/adding-state.js --no-build
ADDING_STATE_BUNDLE=$?
parcel build assets/dynamic-html/adding-state.html -o adding-state--parcelified.html
ADDING_STATE_BUILD=$?

# Adding event handling
spago bundle-app -m DynamicHtml.AddingEventHandling -t assets/dynamic-html/adding-event-handling.js --no-build
ADDING_EVENT_HANDLING_BUNDLE=$?
parcel build assets/dynamic-html/adding-event-handling.html -o adding-event-handling--parcelified.html
ADDING_EVENT_HANDLING_BUILD=$?

# Referring to Elements
spago bundle-app -m DynamicHtml.ReferringToElements -t assets/dynamic-html/referring-to-elements.js --no-build
REFERRING_TO_ELEMENTS_BUNDLE=$?
parcel build assets/dynamic-html/referring-to-elements.html -o referring-to-elements--parcelified.html
REFERRING_TO_ELEMENTS_BUILD=$?

# Input only
spago bundle-app -m ParentChildRelationships.ChildlikeComponents.InputOnly -t assets/parent-child-relationships/childlike-components/input-only.js --no-build
INPUT_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/input-only.html -o child-input-only--parcelified.html
INPUT_ONLY_BUILD=$?

# Message only
spago bundle-app -m ParentChildRelationships.ChildlikeComponents.MessageOnly -t assets/parent-child-relationships/childlike-components/message-only.js --no-build
MESSAGE_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/message-only.html -o child-message-only--parcelified.html
MESSAGE_ONLY_BUILD=$?

spago bundle-app -m ParentChildRelationships.ChildlikeComponents.QueryOnly -t assets/parent-child-relationships/childlike-components/query-only.js --no-build
QUERY_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/query-only.html -o child-query-only--parcelified.html
QUERY_ONLY_BUILD=$?

# All No Halogen Types
spago bundle-app -m ParentChildRelationships.ChildlikeComponents.All.NoHalogenTypes -t assets/parent-child-relationships/childlike-components/all--no-halogen-types.js --no-build
ALL_NO_HALOGEN_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/all--no-halogen-types.html -o child-all--no-halogen-types--parcelified.html
ALL_NO_HALOGEN_BUILD=$?

# All With Halogen Types
spago bundle-app -m ParentChildRelationships.ChildlikeComponents.All.WithHalogenTypes -t assets/parent-child-relationships/childlike-components/all--with-halogen-types.js --no-build
ALL_WITH_HALOGEN_BUNDLE=$?
parcel build assets/parent-child-relationships/childlike-components/all--with-halogen-types.html -o child-all--with-halogen-types--parcelified.html
ALL_WITH_HALOGEN_BUILD=$?

# Basic Container
spago bundle-app -m ParentChildRelationships.ParentlikeComponents.BasicContainer -t assets/parent-child-relationships/parentlike-components/basic-container.js --no-build
BASIC_CONTAINER_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/basic-container.html -o basic-container--parcelified.html
BASIC_CONTAINER_BUILD=$?

# Input Only
spago bundle-app -m ParentChildRelationships.ParentlikeComponents.SingleChild.InputOnly -t assets/parent-child-relationships/parentlike-components/single-child/parent-input-only.js --no-build
PARENT_INPUT_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/single-child/parent-input-only.html -o parent-input-only--parcelified.html
PARENT_INPUT_ONLY_BUILD=$?

# Message Only
spago bundle-app -m ParentChildRelationships.ParentlikeComponents.SingleChild.MessageOnly -t assets/parent-child-relationships/parentlike-components/single-child/parent-message-only.js --no-build
PARENT_MESSAGE_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/single-child/parent-message-only.html -o parent-message-only--parcelified.html
PARENT_MESSAGE_ONLY_BUILD=$?

# Query Only
spago bundle-app -m ParentChildRelationships.ParentlikeComponents.SingleChild.QueryOnly -t assets/parent-child-relationships/parentlike-components/single-child/parent-query-only.js --no-build
PARENT_QUERY_ONLY_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/single-child/parent-query-only.html -o parent-query-only--parcelified.html
PARENT_QUERY_ONLY_BUILD=$?

spago bundle-app -m ParentChildRelationships.ParentlikeComponents.MultipleChildren.RevealingChildSlots -t assets/parent-child-relationships/parentlike-components/multiple-children/revealing-child-slots.js --no-build
REVEAL_CHILD_SLOTS_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/multiple-children/revealing-child-slots.html -o revealing-child-slots--parcelified.html
REVEAL_CHILD_SLOTS_BUILD=$?

spago bundle-app -m ParentChildRelationships.ParentlikeComponents.MultipleChildren.MultipleSlots -t assets/parent-child-relationships/parentlike-components/multiple-children/multi-child-slots.js --no-build
MULTI_CHILD_SLOTS_BUNDLE=$?
parcel build assets/parent-child-relationships/parentlike-components/multiple-children/multi-child-slots.html -o multi-child-slots--parcelified.html
MULTI_CHILD_SLOTS_BUILD=$?

spago bundle-app -m Driver.RunningComponents -t assets/driver/running-components.js --no-build
DRIVER_RUN_COMPONENTS_BUNDLE=$?
parcel build assets/driver/running-components.html -o running-components--parcelified.html
DRIVER_RUN_COMPONENTS_BUILD=$?

spago bundle-app -m Driver.EmbeddingComponents -t assets/driver/embedding-components.js --no-build
DRIVER_EMBED_COMPONENTS_BUNDLE=$?
parcel build assets/driver/embedding-components.html -o embedding-components--parcelified.html
DRIVER_EMBED_COMPONENTS_BUILD=$?

spago bundle-app -m Driver.QueryingComponents -t assets/driver/querying-components.js --no-build
DRIVER_QUERYING_COMPONENTS_BUNDLE=$?
parcel build assets/driver/querying-components.html -o querying-components--parcelified.html
DRIVER_QUERYING_COMPONENTS_BUILD=$?

spago bundle-app -m Driver.DisposingComponents -t assets/driver/disposing-components.js --no-build
DRIVER_DISPOSING_COMPONENTS_BUNDLE=$?
parcel build assets/driver/disposing-components.html -o disposing-components--parcelified.html
DRIVER_DISPOSING_COMPONENTS_BUILD=$?

spago bundle-app -m Driver.SubscribingToMessages -t assets/driver/subscribing-to-messages.js --no-build
DRIVER_MESSAGE_SUBSCRIPTION_BUNDLE=$?
parcel build assets/driver/subscribing-to-messages.html -o subscribing-to-messages--parcelified.html
DRIVER_MESSAGE_SUBSCRIPTION_BUILD=$?

spago bundle-app -m GoingDeeper.ADifferentMonad.ReaderT -t assets/going-deeper/a-different-monad--readert.js --no-build
GOING_DEEPER_READERT_BUNDLE=$?
parcel build assets/going-deeper/a-different-monad--readert.html -o a-different-monad--readert--parcelified.html
GOING_DEEPER_READERT_BUILD=$?

spago bundle-app -m GoingDeeper.ADifferentMonad.Run -t assets/going-deeper/a-different-monad--run.js --no-build
GOING_DEEPER_RUN_BUNDLE=$?
parcel build assets/going-deeper/a-different-monad--run.html -o a-different-monad--run--parcelified.html
GOING_DEEPER_RUN_BUILD=$?

spago bundle-app -m GoingDeeper.ForkingThreads -t assets/going-deeper/forking-threads.js --no-build
GOING_DEEPER_FORKING_BUNDLE=$?
parcel build assets/going-deeper/forking-threads.html -o going-deeper/forking-threads--parcelified.html
GOING_DEEPER_FORKING_BUILD=$?

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
echo "$REFERRING_TO_ELEMENTS_BUNDLE - Referring to Elements- Bundle"
echo "$REFERRING_TO_ELEMENTS_BUILD - Referring to Elements - Build"
echo "$INPUT_ONLY_BUNDLE - Input only - Bundle"
echo "$INPUT_ONLY_BUILD - Input only - Build"
echo "$MESSAGE_ONLY_BUNDLE - Message only - Bundle"
echo "$MESSAGE_ONLY_BUILD - Message only - Build"
echo "$QUERY_ONLY_BUNDLE - Query only - Bundle"
echo "$QUERY_ONLY_BUILD - Query only - Build"
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
echo "$DRIVER_EMBED_COMPONENTS_BUILD - Driver - Embed components - Build"
echo "$DRIVER_QUERYING_COMPONENTS_BUNDLE - Driver - Querying Components - Bundle"
echo "$DRIVER_QUERYING_COMPONENTS_BUILD - Driver - Querying Components - Build"
echo "$DRIVER_DISPOSING_COMPONENTS_BUNDLE - Driver - Disposing Components - Bundle"
echo "$DRIVER_DISPOSING_COMPONENTS_BUILD - Driver - Disposing Components - Build"
echo "$DRIVER_MESSAGE_SUBSCRIPTION_BUNDLE - Driver - Subscribe to Messages - Bundle"
echo "$DRIVER_MESSAGE_SUBSCRIPTION_BUILD - Driver - Subscribe to Messages - Build"
echo "$GOING_DEEPER_READERT_BUNDLE - Going Deeper - ReaderT - Bundle"
echo "$GOING_DEEPER_READERT_BUILD - Going Deeper - ReaderT - Build"
echo "$GOING_DEEPER_RUN_BUNDLE - Going Deeper - Run - Bundle"
echo "$GOING_DEEPER_RUN_BUILD - Going Deeper - Run - Build"
echo "$GOING_DEEPER_FORKING_BUNDLE - Goind Deeper - Forking - Bundle"
echo "$GOING_DEEPER_FORKING_BUILD - Goind Deeper - Forking - Bundle"

if [ $STATIC_HTML_BUNDLE == 0 ] &&
   [ $STATIC_HTML_BUILD == 0 ] &&
   [ $ADDING_PROPERTIES_BUNDLE == 0 ] &&
   [ $ADDING_PROPERTIES_BUILD == 0 ] &&
   [ $ADDING_CSS_BUNDLE == 0 ] &&
   [ $ADDING_CSS_BUILD == 0 ] &&
   [ $ADDING_STATE_BUNDLE == 0 ] &&
   [ $ADDING_STATE_BUILD == 0 ] &&
   [ $ADDING_EVENT_HANDLING_BUNDLE == 0 ] &&
   [ $ADDING_EVENT_HANDLING_BUILD == 0 ] &&
   [ $REFERRING_TO_ELEMENTS_BUNDLE == 0 ] &&
   [ $REFERRING_TO_ELEMENTS_BUILD == 0 ] &&
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
   [ $DRIVER_QUERYING_COMPONENTS_BUILD == 0 ] &&
   [ $DRIVER_DISPOSING_COMPONENTS_BUNDLE == 0 ] &&
   [ $DRIVER_DISPOSING_COMPONENTS_BUILD == 0 ] &&
   [ $DRIVER_MESSAGE_SUBSCRIPTION_BUNDLE == 0 ] &&
   [ $DRIVER_MESSAGE_SUBSCRIPTION_BUILD == 0 ] &&
   [ $GOING_DEEPER_READERT_BUNDLE == 0 ] &&
   [ $GOING_DEEPER_READERT_BUILD == 0 ] &&
   [ $GOING_DEEPER_RUN_BUNDLE == 0 ] &&
   [ $GOING_DEEPER_RUN_BUILD == 0 ] &&
   [ $GOING_DEEPER_FORKING_BUNDLE == 0 ] &&
   [ $GOING_DEEPER_FORKING_BUILD == 0 ]
then
  echo "Build Succeeded"
  exit 0;
else
  echo "Build Failed"
  exit 1;
fi
