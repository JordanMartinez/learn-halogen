# Lifecycle

Currently, there are two hooks for a component's lifecycle:
- initialization
- finalization

## Compiling Instructions

To compile the next file and view its results in the browser, use these instructions.

### Child Lifecycle Component

```bash
spago bundle -m Lifecycle.Child -t assets/lifecycle/lifecycle-child.js
parcel serve assets/lifecycle/lifecycle-child.html -o lifecycle-child--parcelified.html --open
```

### Parent Lifecycle Component

```bash
spago bundle -m Lifecycle.Parent -t assets/lifecycle/lifecycle-parent.js
parcel serve assets/lifecycle/lifecycle-parent.html -o lifecycle-parent--parcelified.html --open
```
