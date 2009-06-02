%% @author Jean-Sébastien Pédron <js.pedron@meetic-corp.com>

%% @doc
%% The module <strong>{@module}</strong> implements the initiating
%% entity side of Stream Compression (XEP-0138).
%%
%% @reference <a href="http://www.xmpp.org/extensions/xep-0138.html">XEP-0138: Stream Compression</a>
%% @reference <a href="http://www.xmpp.org/extensions/xep-0229.html">XEP-0229: Stream Compression with LZW</a>

-module(exmpp_client_compression).
-vsn('$Revision$').

-include("exmpp.hrl").

%% Feature announcement.
-export([
	 announced_methods/1
	]).

%% Compression negotiation.
-export([
	 selected_method/1
	]).

%% --------------------------------------------------------------------
%% Feature announcement.
%% --------------------------------------------------------------------

%% @spec (Features_Announcement) -> Methods
%%     Features_Announcement = exmpp_xml:xmlel()
%%     Methods = [string()]
%% @throws {stream_compression, announced_methods, invalid_feature, Feature} |
%%         {stream_compression, announced_methods, invalid_method, El}
%% @doc Return the list of supported compression methods.

announced_methods(#xmlel{ns = ?NS_XMPP, name = 'features'} = El) ->
    case exmpp_xml:get_element(El, ?NS_COMPRESS_FEAT, 'compression') of
        undefined -> [];
        Methods   -> announced_methods2(Methods)
    end.

announced_methods2(#xmlel{children = []} = Feature) ->
    throw({stream_compression, announced_methods, invalid_feature, Feature});
announced_methods2(#xmlel{children = Children}) ->
    announced_methods3(Children, []).

announced_methods3(
  [#xmlel{ns = ?NS_COMPRESS_FEAT, name = 'method'} = El | Rest], Result) ->
    case exmpp_xml:get_cdata_as_list(El) of
        "" ->
            throw({stream_compression, announced_methods, invalid_method, El});
        Method ->
            announced_methods3(Rest, [Method | Result])
    end;
announced_methods3([El | _Rest], _Result) ->
    throw({stream_compression, announced_methods, invalid_method, El});
announced_methods3([], Result) ->
    lists:reverse(Result).

%% --------------------------------------------------------------------
%% Compression negotiation.
%% --------------------------------------------------------------------

%% @spec (Method) -> Compress
%%     Method = string()
%%     Compress = exmpp_xml:xmlel()
%% @doc Prepare an request to select prefered compression method.

selected_method(Method) ->
    El = #xmlel{ns = ?NS_COMPRESS,
		name = 'method'
	       },
    #xmlel{ns = ?NS_COMPRESS,
	   name = 'compress',
	   children = [exmpp_xml:set_cdata(El, Method)]
	  }.
