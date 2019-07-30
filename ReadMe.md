# Learn Halogen

[![Build Status](https://travis-ci.com/JordanMartinez/learn-halogen.svg?branch=latestRelease)](https://travis-ci.com/JordanMartinez/learn-halogen)

Learn [`purescript-halogen`](https://github.com/slamdata/purescript-halogen), (`v5.0.0-rc.5`) from a bottom-up approach

## Requirements

Before learning Halogen via this project, you will need to install the following. (If you don't have them already installed, see my purescript learning repo's [Install Guide](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/00-Getting-Started/02-Install-Guide.md)
- purescript (v0.13.2)
- spago (v0.8.5.0)
- parcel (v1.12.3)

Or, to install them in one line
```bash
npm i -g purescript@0.13.2 spago@0.8.5 parcel
```

## Target Audience

**Required:** You are already familiar with...
- PureScript's "Basic" syntax. (If not, see my [Basic Syntax](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/11-Syntax/01-Basic-Syntax) overview)
- PureScript's "Module" syntax. (If not, see my [Module Syntax](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/11-Syntax/04-Module-Syntax) overview)
- the `purescript-prelude` library. (If not, see my [Prelude-ish](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/21-Hello-World/02-Prelude-ish) folder)
- "smart constructors." (If not, read my explanation on [Smart Constructors](https://github.com/JordanMartinez/purescript-jordans-reference/blob/latestRelease/31-Design-Patterns/01-Smart-Constructors.md))
- the `Effect` type and how it works. (If not, see my [Hello World and Effects](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/21-Hello-World/03-Hello-World-and-Effects) folder)

**Helpful, but not absolutely necessary**: You are already familiar with...
- the philosophical foundations of Functional Programming. (If not, see my [FP Philosophical Foundations Overview](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/01-FP-Philosophical-Foundations))
- PureScript's "Type-Level Programming" syntax. (If not, see my [Type-Level Programming Syntax](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/11-Syntax/03-Type-Level-Programming-Syntax) overview)
- "do notation." (If not, see my overview on [Do Notation](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/11-Syntax/05-Prelude-Syntax/src). Specifically, `Discard.md` to `Reading Do as Nested Binds.md`)
- monad transformers and how they work. (If not, see my [Application Structure](https://github.com/JordanMartinez/purescript-jordans-reference/tree/latestRelease/21-Hello-World/08-Application-Structure) folder. Specifically, the `MTL` folder.)
- the `Aff` type and how it works. (If not, watch [Async Programming in PureScript](https://www.youtube.com/watch?v=dbM72ap30TE))

## Instructions

1. Git clone this project
2. Run `spago build`
3. Run `spago docs` (and refer to the docs via the `./generated-docs/index.html` file)
4. Read through each folder using the same rules that I use in my learning repo (described [in the third bullet point here](https://github.com/JordanMartinez/purescript-jordans-reference#learning-purescript-using-this-project)).

Don't want to clone-and-play? Then read through this repo using [the Table of Contents](./table-of-contents.md) file.

## License

This project is licensed under the `Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license`: [(Human-readable version)](https://creativecommons.org/licenses/by-nc-sa/4.0/), [(Actual License)](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" />
