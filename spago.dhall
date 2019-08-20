{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "src/**/*.purs" ]
, name =
    "my-project"
, dependencies =
    [ "console"
    , "css"
    , "effect"
    , "halogen"
    , "halogen-css"
    , "psci-support"
    , "random"
    , "run"
    ]
, packages =
    ./packages.dhall
}
