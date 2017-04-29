module Main exposing (..)

import Html exposing (Html, div, text)
import Http
import Jsonp
import Task exposing (Task)
import Json.Decode as Decode
import Types exposing (..)
import Ports exposing (..)


-- MODEL


type alias Model =
    { position : Position
    , error : Error
    , temperature : Float
    }


init : ( Model, Cmd Msg )
init =
    ( Model (Position 0.0 0.0) (Error 0 "") 0.0, Cmd.none )



-- HELPERS


decodeTemperature : Decode.Decoder Float
decodeTemperature =
    Decode.at [ "currently", "temperature" ] Decode.float


getTemperature : Position -> Task Http.Error Float
getTemperature position =
    let
        ( lat, lng ) =
            ( toString position.latitude, toString position.longitude )
    in
        Jsonp.get decodeTemperature ("https://api.darksky.net/forecast/YOUR_API_KEY/" ++ lat ++ "," ++ lng)



-- UPDATE


type Msg
    = NewPositionMsg Position
    | NewErrorMsg Error
    | NewTemperature (Result Http.Error Float)


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
            ( { model | position = position }, Task.attempt NewTemperature (getTemperature position) )

        NewErrorMsg error ->
            ( { model | error = error }, Cmd.none )

        NewTemperature (Ok temperature) ->
            ( { model | temperature = temperature }, Cmd.none )

        NewTemperature (Err _) ->
            model ! []



-- VIEW


view : Model -> Html a
view model =
    div []
        [ div [] [ text (toString model.position.latitude) ]
        , div [] [ text (toString model.position.longitude) ]
        , div [] [ text (toString model.temperature) ]
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
