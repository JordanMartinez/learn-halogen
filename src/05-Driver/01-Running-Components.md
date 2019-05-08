# Running Components

Now that we have a better understanding of how Halogen's components work, let's see how to actually run them. This is the approach one would likely use when creating a Single-Page Application (SPA)

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

```bash
spago bundle -m Driver.RunningComponents -t assets/driver/running-components.js
parcel serve assets/driver/running-components.html -o running-components--parcelified.html --open
```
