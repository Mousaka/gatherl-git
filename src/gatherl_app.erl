-module(gatherl_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Port = port(),
    Routes = routes(),
    Dispatch = cowboy_router:compile([{'_', Routes}]),	
        {ok, _} = cowboy:start_http(http, 100, [{port, Port}],
        [{env, [{dispatch, Dispatch}]}]
    ),
    gatherl_sup:start_link().

stop(_State) ->
    ok.

routes() ->
    [
            {"/hello", hello_handler, []},
            {"/websocket", ws_handler, []},
            {"/", cowboy_static, {priv_file, gatherl, "index.html"}},
            {"/static/[...]", cowboy_static, {priv_dir, gatherl, "static"}}   
    ].

port() ->
	case os:getenv("PORT") of
		false ->
			{ok, Port} = application:get_env(http_port),
			Port;
		Other ->
			list_to_integer(Other)
	end.