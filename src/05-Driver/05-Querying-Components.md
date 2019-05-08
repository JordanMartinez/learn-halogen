# Querying Components

One might wonder why I explained the parent-child relationships before explaining the Driver part of Halogen. The answer is simple: While we can create a Single-Page Application (SPA), sometimes, we are still migrating from some framework to Halogen and we only want Halogen to work on a part of our page.

This typically looks like this:
```purescript
main :: Effect Unit
main =
    launchAff_ do
      body <- awaitBody
      io <- runUI topLevelComponent input body

      -- and now we can send queries into the
      -- top-level component as though this code
      -- is a parent component querying a child component

      -- run a request-style query
      requestResult <- io.query $ H.request $ GetInfoFromChild

      tellResult <- io.query $ H.tell $ TellChildSomething 4
```

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m Driver.QueryingComponents -t assets/driver/querying-components.js
parcel serve assets/driver/querying-components.html -o querying-components--parcelified.html --open
# After the page opens, check your browser's console to see the messages
```
