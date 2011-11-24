%% Copyright ProcessOne 2006-2010. All Rights Reserved.
%%
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.

%% @author Jean-Sébastien Pédron <js.pedron@meetic-corp.com>

%% @doc
%% The module <strong>{@module}</strong> implements the receiving entity
%% side of privacy lists management.

-module(exmpp_server_privacy).

-include("exmpp.hrl").

%% Creating stanza.
-export([
	 list_push/2
	]).

%% --------------------------------------------------------------------
%% Creating stanza.
%% --------------------------------------------------------------------

%% @spec (To, List_Name) -> Push_IQ
%%     To =  binary()
%%     List_Name = binary()
%%     Push_IQ = exml:xmlel()
%% @doc Create an `<iq/>' to notify `To' that the privacy list
%% `List_Name' has been created or has changed.

list_push(To, List_Name) ->
    Query = {xmlel, <<"query">>, [{<<"xmlns">>, ?NS_PRIVACY}], 
		[{xmlel, <<"list">>,  [{<<"name">>, List_Name}], []}]},
    IQ = exmpp_iq:set(Query, exmpp_utils:random_id(<<"push">>)),
    exmpp_stanza:set_recipient(IQ, To).
