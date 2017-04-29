module Types exposing (..)


type alias Position =
    { latitude : Float
    , longitude : Float
    }


type alias Error =
    { code : Int
    , message : String
    }
