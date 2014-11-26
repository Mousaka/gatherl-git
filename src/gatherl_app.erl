-module(gatherl_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Port = port(),
    Dispatch = cowboy_router:compile([
        {'_', [{"/", hello_handler, []}]}
    ]),	
    cowboy:start_http(my_http_listener, 100, [{port, Port}],
        [{env, [{dispatch, Dispatch}]}]
    ),
    gatherl_sup:start_link().

stop(_State) ->
    ok.

port() ->
	case os:getenv("PORT") of
		false ->
			{ok, Port} = application:get_env(http_port),
			Port;
		Other ->
			list_to_integer(Other)
	end.