# Revealing Child Slots

Thus far, we haven't actually shown the full code needed to render and query a child component in a parent component. In this example, we'll reveal that code.

## Rendering a Child using Slots

When we wish to render a child, we use `HH.slot`, which takes 5 arguments:
- the label that refers to the child's `H.Slot` type (i.e. the `childQuery`-`childMessage`-`index` combination)
- a child's corresponding value of the slot index type
- the child component
- a value of the `input` type to pass into the child
- a function that maps the child's message to a value of the parent's `action` type

In short:
```purescript
HH.slot
  _childLabel
  childIndex
  childComponent
  inputValue
  (\childMessage -> Just ParentActionValue {- or 'Nothing' to ignore it -})
```

## Quering a Child using slots

When we wish to send a request or tell a command via a `query`, we use `H.query`, which takes three arguments:
- the label that refers to the child's `H.Slot` type (i.e. the `childQuery`-`childMessage`-`index` combination)
- a child's corresponding value of the slot index type
- a `request` or `tell` query

For example:
```purescript
-- A 'request' query
H.query _childLabel childIndex $ H.request $ GetInfo 4 "help"

-- A 'tell' query
H.query _childLabel childIndex $ H.tell $ DoSomething 2.0 false
```

Now look at the next file for the full example.

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m ParentChildRelationships.ParentlikeComponents.MultipleChildren.RevealingChildSlots -t assets/parent-child-relationships/parentlike-components/multiple-children/revealing-child-slots.js
parcel serve assets/parent-child-relationships/parentlike-components/multiple-children/revealing-child-slots.html -o revealing-child-slots--parcelified.html --open
```
