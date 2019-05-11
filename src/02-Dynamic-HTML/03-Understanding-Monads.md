# Understanding Monads

The upcoming files start to use Monads to compute. If you do not understand how monads work, it will be difficult for you to understand what the code is doing and why it works.

So, here we'll present two things:
1. a brief concise overview of Monads and how they work without going into the deeper stuff
2. links to a much longer overview of Monads that covers more things

The first one is a high-level 'preface' to the second one.

## Brief Overview

### `Box`-like Types

Think of a Monad as a box:
```purescript
data Box a = Box a
```

We can "put values into the Box" using the function, `pure`
```purescript
pure :: forall value. value -> Box Value
pure value = Box value
```

We can also take values out of the Box. However, we don't want to do this _whenever we want_.
```purescript
-- fake function that shows what I mean by 'taking values out of the box'
extractVal :: forall value. Box value -> value
extractVal (Box value) = value
```

Why not take the values out whenever we want? Because these `Box`es represent side-effectful functions. These functions are computations that causes something to occur or change in the "real world." For example:
- state manipulation
- network requests
- printing
- etc.

One goal of functional programming is to distinguish "impure side-effectful computations" from "pure total computations" (e.g. `1 + 1` always returns `2`, always; `reverse "apple"` always returns `"elppa"`, always).

Thus, when we want to "take the value out of the box," we do it in a special way:
1. Take the value out of the `Box`
2. Do something with the value
3. Return a new `Box` with a new value

We call this function `bind`:
```purescript
bind :: forall value1 value2. Box value1 -> (value1 -> Box value2) -> Box value2
bind (Box value1) function = function value1
```

Via "monadic" `Box`-like types, we can write a "description" of the computation we want to run without ever running it. Via `bind`, we can chain/compose these 'descriptions' together into a new "description" of the program we want to run without ever running it. Finally, we can run that computation by finally taking the value out of the box.

Sometimes, running that "monadic" computation is 'side-effectful.' Other times it is not. It all depends on the underlying "monadic" type we use. We'll cover this more after covering `do` notation.

### `Do` Syntax

#### Basic

Let's take a look at `bind` again, which allows us to compose/sequentially-chain descriptions of our computation together into a new description of a computation:
```purescript
bind :: forall value1 value2. Box value1 -> (value1 -> Box value2) -> Box value2
bind (Box value1) function = function value1
```

If we were to write out a chain of `bind` functions, it might look like this:
```purescript
program :: Box Int
program =
  bind (Box 4) (\four ->
    bind (Box (four + 2)) (\six ->
      bind (Box (six / 3)) (\two ->
        pure (two - 1)
      )
    )
  )
```

This isn't very easy to read and looks very similar to the Pyramid of Doom. Thus, PureScript uses `do` notation, which is syntax sugar. Here's how it works

Step 1: Remove `bind` calls

```purescript
program :: Box Int
program =
  (Box 4) (\four ->
    (Box (four + 2)) (\six ->
      (Box (six / 3)) (\two ->
        pure (two - 1)
      )
    )
  )
```

Step 2: Swap the `Box number` and `\argName` positions, change the direction of the arrows/`->`, and remove the unneeded paranthesis:

```purescript
program :: Box Int
program =
  four <- Box 4
  six <- Box (four + 2)
  two <- Box (six / 3)
  pure (two - 1)
```

Step 3: Add a `do` keyword

```purescript
program :: Box Int
program = do
  four <- Box 4
  six <- Box (four + 2)
  two <- Box (six / 3)
  pure (two - 1)
```

See how much easier it is to read the version with `do` notation as compared to the original? See how it looks very similar to imperative programming?

```purescript
-- original
program :: Box Int
program =
  bind (Box 4) (\four ->
    bind (Box (four + 2)) (\six ->
      bind (Box (six / 3)) (\two ->
        pure (two - 1)
      )
    )
  )

-- using do notation
program :: Box Int
program = do
  four <- Box 4
  six <- Box (four + 2)
  two <- Box (six / 3)
  pure (two - 1)
```

#### Requirements for the Last Monadic Computation in Do Notation

Now let's cover that last `pure` statement. Since `do` is just syntax sugar for nested `bind` calls and since `bind` requires the return type to be a value with a `Box value`-like type, the last computation can never have a `argName <-` part before it. That part indicates there is another `bind` call, so we'll get a compiler error.

```purescript
-- This...
program :: Box Int
program = do
  four <- Box 4

-- ...desugars to this
program :: Box Int
program = do
  bind (Box 4) (\four ->
    -- Compiler: Ahh! I was expecting something here but it's not there!
  )
```

#### Adding `Let` and `Discard`

We can also store a temporary variable that does not require a monadic computation to produce via `let`. Note that we can have multiple `let`s.
```purescript
-- using do notation
program :: Box Int
program = do
  four <- Box 4
  let six = four + 2
  let two = six / 3
  pure (two - 1)
```

In some situations, a monadic computation might not 'return' anything interesting. In such situations, it returns `Unit`. When that occurs, we can ignore the `argName <-` part

```purescript
program :: Box Int
program = do
  four <- Box 4

  -- This...
  doSomething
  -- ... desguars to
  unitValue <- doSomething
  -- so we omit the arrow part entirely

  let two = six / 3
  pure (two - 1)
```

### Different `Monadic` Box Types

There are a variety of types that are "monadic." Many are used for control flow (e.g. if-then-else statements). For example, `Maybe`, `Either`, and `List`. These allow us to reduce boilerplate and better express developer intent. These types do not "run" our program.

Only two monadic types are used for representing impure computations that actually "run" our program:
- `Effect` (synchronous side-effectful computations)
- `Aff` (asynchronous side-effectful computations)

Of the two, `Aff` is more powerful and removes the "callback hell" under which many JS developers have suffered. It enables one to simulate a multi-threaded environment.

### Monad Transformers

#### The Problem

If all of our code was written via `Effect` or `Aff`, we would be tightly coupling our high-level business logic with the low-level instructions that actually make it work. As a result, our code would be harder test and reason about.

`Effect`/`Aff` only exist so we can actually run our programs. However, we do not want to encode our business logic into them as well. Does our business logic care which database we're using? No, it should work either way. Does it care about which method we're using to communicate with our server? No, it should work either way.

Moreover, some computations require capabilities. For example, our business logic might require a computation that should have the capability of deleting something in the database. However, this same computation should not have the capability of logging a user into the system. These two capabilities should be kept separate from one another.

Thus, we need some form of abstraction to separate the high-level capability-focused business logic from the low-level implementation-specific instructions.

#### A Solution

One way of separating them is using "monad transformers." Think of these entities as something that "augment" a monadic type with additional capabilities. For example, `Effect` and `Aff` do not know how to do state manipulation. While one could make them do that, it couples the business logic to the implementation that runs it and is error prone. Instead, it would be better to use an abstraction that handles this correctly each time and that highlights developer intent.

While there are other transformers, we'll only cover one: `MonadState`.

| When we want a type of computation (effect) that... | ... we expect to use functions named something like ... | ... which are best abstracted together in a type class called...
| - | - | - |
| Modifies the state of a data structure<br>(e.g. changing the nth value in a list)| <ul><li>`pop stack`</li><li>`replaceAt index treeOfStrings "some value"`</li><li>`(\int -> int + 1)`</li></ul> | [`MonadState`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State.Class#t:MonadState)

### Replacing `Box` with Monad Transformers

We described `Box` earlier as a computation. Now, let's replace it with some of the functions described above in the monad transformers section:

```purescript
program :: TypeSignatureNotShownHere
program = do
  -- gets the current state value
  currentState <- get

  -- do something with currentState

  -- now store a new state value
  put newState
```

### The Problem of Composing Monadic Types

Let's look at `bind` again:
```purescript
bind :: forall value1 value2. Box value1 -> (value1 -> Box value2) -> Box value2
bind (Box value1) function = function value1
```

Notice in the type signature that the `Box` type never changes: the `Box`-like type you pass into `bind` is the same `Box`-like type it returns. That means if we're running monadic code via the `Aff` type, we cannot run code that uses the `Effect` type. However, we can get around this by using `liftEffect`:
```purescript
log :: String -> Effect Unit
log msg = -- implementation not shown, but logs the message to the console

program :: Aff Unit
program = do
  currentState <- get
  -- here we use `liftEffect` to run a `Effect`-typed computation
  -- in our `Aff`-typed computation
  liftEffect (log currentState)
  put (currentState + 1)
```
When we want to run multiple `Effect`-typed computations, we can use this syntax:

```purescript
log :: String -> Effect Unit
log msg = -- implementation not shown, but logs the message to the console

program :: Aff Unit
program = do
  currentState <- get
  -- here we use `liftEffect` followed by a `do` and
  -- the `Effect`-typed computations that are indented
  liftEffect do
    log "first"
    log "second"
    log "third"
  put (currentState + 1)
```

## Longer Overview

Read/Watch these resources. If they are folders, read through all of their content.
- [Composition Everywhere](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/01-FP-Philosophical-Foundations/01-Composition-Everywhere.md)
- [Pure vs Impure Functions](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/01-FP-Philosophical-Foundations/02-Pure-vs-Impure-Functions.md)
- [Type Classes](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/01-FP-Philosophical-Foundations/06-Type-Classes.md)
- [FP: the Big Picture](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/01-FP-Philosophical-Foundations/07-FP--The-Big-Picture.md)
- [Basic Syntax](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/11-Syntax/01-Basic-Syntax)
- [Prelud-ish](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/21-Hello-World/02-Prelude-ish)
- [Prelude Syntax](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/11-Syntax/05-Prelude-Syntax)
- [Hello World and Effects](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/21-Hello-World/03-Hello-World-and-Effects)
- [Application Structure](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/21-Hello-World/08-Application-Structure), but specifically the `MTL` folder.
