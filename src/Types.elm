module Types exposing (..)


type alias Position =
    { latitude : Float
    , longitude : Float
    }


type alias Error =
    { status : Int
    , message : String
    }
