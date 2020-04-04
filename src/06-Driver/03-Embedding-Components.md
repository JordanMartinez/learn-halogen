# Embedding Components

While we can create a Single-Page Application (SPA), sometimes, we are still migrating from some framework to Halogen and we only want Halogen to work on a part of our page.

In such situations, we can "embed" the component by running it in a specific element

We'll follow similar steps as before but instead wait for the desired element, a `div` element with the id, "targetContainer":
1. Wait for the page to load
2. Find the desired element via `querySelector`
3. Run our component as a child in that element

This typically looks like this:
```purescript
main :: Effect Unit
main =
    runHalogenAff do
      awaitLoad
      targetElem <- selectElement' "could not find 'div#targetContainer'" $ QuerySelector "#targetContainer"
      runUI childComponent input targetElem
  where
    selectElement' :: String -> QuerySelector -> Aff HTMLElement
    selectElement' errorMessage query = do
      maybeElem <- selectElement query
      maybe (throwError (error errorMessage)) pure maybeElem
```

View both the next file and the corresponding HTML file (defined in the build command below).

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle-app -m Driver.EmbeddingComponents -t assets/driver/embedding-components.js
parcel serve assets/driver/embedding-components.html -o embedding-components--parcelified.html --open
```
