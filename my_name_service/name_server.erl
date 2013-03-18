-module(name_server).

-behaviour(gen_server).
-export([start/0]).
%%gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-compile(export_all).

start() -> gen_server:start_link({local,?MODULE},?MODULE,[],[]).
stop() -> gen_server:call(?MODULE,stop).

get(Name) -> gen_server:call(?MODULE,{find,Name}).
set(Name,Place) -> gen_server:call(?MODULE,{add,Name,Place}).

init([]) -> {ok,dict:new()}.

handle_call({find,Name},_From,Dict) ->
	Reply = {dict:find(Name,Dict),Dict},
	{reply,Reply,Dict};
handle_call({add,Name,Place},_From,Dict) ->
	Reply = {ok,dict:store(Name,Place,Dict)},
	{reply,Reply,Dict}.
handle_cast(_Msg,State) -> {noreply,State}.
handle_info(_Info,State) -> {noreply,State}.
terminate(_Reason,_State) -> ok.
code_change(_OldVsn,State,Extra) -> {ok,State}.
