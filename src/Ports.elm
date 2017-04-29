port module Ports exposing (..)

import Types exposing (Position, Error)


port position : (Position -> msg) -> Sub msg


port error : (Error -> msg) -> Sub msg
