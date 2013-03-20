%%%------------------------------
%%%@Module :name_server
%%%@Author :fengzhenlin
%%%@Email  :535826356@qq.com
%%%@Created :2013.3.19
%%%@Description :use gen_server to build a name_server
%%%------------------------------
-module(name_server).
-behaviour(gen_server).
-export([start/0]).

%%gen_server callbacks
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-compile(export_all).

%%================================================================
%%接口函数
%%================================================================
start() -> gen_server:start_link({local,?MODULE},?MODULE,[],[]).
stop() -> gen_server:call(?MODULE,stop).

get(Name) -> gen_server:call(?MODULE,{find,Name}).
set(Name,Place) -> gen_server:call(?MODULE,{add,Name,Place}).

getTimes() -> gen_server:call(?MODULE,{gettimes}).
setTimes() -> gen_server:call(?MODULE,{settimes}).

%%===============================================================
%%回调函数
%%===============================================================
init([]) -> {ok,{dict:new(),0,0}}.

%查找
%GetTimes : 记录get次数
%SetTimes : 记录set次数
handle_call({find,Name},_From,{Dict,GetTimes,SetTimes}) ->
	Reply = dict:find(Name,Dict),
    GetTimesAdd = GetTimes + 1,
    {reply,Reply,{Dict,GetTimesAdd,SetTimes}};

%添加
handle_call({add,Name,Place},_From,{Dict,GetTimes,SetTimes}) ->
    Dict1=dict:store(Name,Place,Dict),
    SetTimesAdd = SetTimes + 1,
    Reply = ok,
	{reply,Reply,{Dict1,GetTimes,SetTimesAdd}};

%获取get次数
handle_call({gettimes},_From,{Dict,GetTimes,SetTimes}) ->
    Reply = GetTimes,
    {reply,Reply,{Dict,GetTimes,SetTimes}};

%获取set次数
handle_call({settimes},_From,{Dict,GetTimes,SetTimes}) ->
    Reply = SetTimes,
    {reply,Reply,{Dict,GetTimes,SetTimes}}.

handle_cast(_Msg,State) -> {noreply,State}.
handle_info(_Info,State) -> {noreply,State}.
terminate(_Reason,_State) -> ok.
code_change(_OldVsn,State,Extra) -> {ok,State}.
