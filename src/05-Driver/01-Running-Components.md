# Running Components

Now that we have a better understanding of how Halogen's components work, let's learn how to actually run them.

To run a component one must do two things:
1. Wait for the element (e.g. `body`) that will contain the top-level component to become available
2. Run the top-level Halogen component using that element

This typically looks like this:
```purescript
main :: Effect Unit
main =
  launchAff_ do
    body <- awaitBody
    runUI component inputValue body
```

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m Driver.RunningComponents -t assets/driver/running-components.js
parcel serve assets/driver/running-components.html -o running-components--parcelified.html --open
```
