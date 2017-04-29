module Main exposing (..)

import Html exposing (Html, div, text, button)
import Types exposing (..)
import Ports exposing (..)


-- MODEL


type alias Model =
    { position : Position
    , error : Error
    }


init : ( Model, Cmd Msg )
init =
    ( Model (Position 0.0 0.0) (Error 0 ""), Cmd.none )



-- UPATE


type Msg
    = NewPositionMsg Position
    | NewErrorMsg Error


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ position NewPositionMsg
        , error NewErrorMsg
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewPositionMsg position ->
            ( { model | position = position }, Cmd.none )

        NewErrorMsg error ->
            ( { model | error = error }, Cmd.none )



-- VIEW


view : Model -> Html a
view model =
    div []
        [ div [] [ text (toString model.position.latitude) ]
        , div [] [ text (toString model.position.longitude) ]
        ]



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
