# Tips for Event Handling

At various times, we need to call `preventDefault` and/or `stopPropagation` on an event. So, how do we do that?

These functions, and others related to events in general, are found in [Web.Event.Event](https://pursuit.purescript.org/packages/purescript-web-events/2.0.1/docs/Web.Event.Event).

When looking at [`preventDefault`](https://pursuit.purescript.org/packages/purescript-web-events/2.0.1/docs/Web.Event.Event#v:preventDefault) and [`stopPropagation`](https://pursuit.purescript.org/packages/purescript-web-events/2.0.1/docs/Web.Event.Event#v:stopPropagation), notice two things:
- The monadic type these functions return is `Effect`.
- The functions take an argument of type `Event`.

We'll address these parts one at a time.

First, we handle events by mapping them to our component's `action` type, which is then converted into a `HalogenM` monadic computation. Since one monadic computation of one type (i.e. `Effect`) cannot be run in monadic computation of another type (i.e. `HalogenM`) due to `bind`'s type signature, how do we run these computations in our component's handler?

The answer is to use `liftEffect`. Thus, in our code, we might write:
```purescript
data Action = Clicked MouseEvent

handleAction :: Action -> HalogenM ...
handleAction = case _ of
  Clicked mouseEvent -> do
    liftEffect $ preventDefault mouseEvent
```

Second, `preventDefault` expected an argument of type `Event`. In our above example, `mouseEvent` has the type `MouseEvent`, not `Event`. Thus, our above example will result in a compiler error. So, how do we convert `MouseEvent` to the `Event` type? We must use the module's `toEvent` function:
- [`MouseEvent.toEvent`](https://pursuit.purescript.org/packages/purescript-web-uievents/2.0.0/docs/Web.UIEvent.MouseEvent#v:toEvent)
- [`KeyboardEvent.toEvent`](https://pursuit.purescript.org/packages/purescript-web-uievents/2.0.0/docs/Web.UIEvent.KeyboardEvent#v:toEvent)
- etc.

Since these events all use the same name for this function (namely, `toEvent`), we need to import each module using a qualified name and prefix their `toEvent` with that name.

## Full Solution

Thus, we might write this:
```purescript
import Web.UIEvent.KeyboardEvent (KeyboardEvent)
import Web.UIEvent.MouseEvent (MouseEvent)
import Web.UIEvent.KeyboardEvent as KE
import Web.UIEvent.MouseEvent as ME

data Action
  = Clicked MouseEvent
  | Keyed KeyboardEvent

handleAction :: Action -> HalogenM ...
handleAction = case _ of
  Clicked mouseEvent -> do
    liftEffect $ preventDefault $ ME.toEvent mouseEvent
  Keyed keyEvent -> do
    liftEffect $ preventDefault $ KE.toEvent keyEvent
```
