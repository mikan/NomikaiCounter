/*
 * Copyright(C) 2014-2015 Yutaka Kato All rights reserved.
 */
import ceylon.io {
	SocketAddress
}
import ceylon.net.http.server {
	newServer,
	Endpoint,
	startsWith,
	Request,
	Response,
	Server,
	endsWith,
	AsynchronousEndpoint,
	isRoot
}
import ceylon.net.http.server.endpoints {
	serveStaticFile
}
import net.aoringo.nomikaicounter.controller {
	NewController,
	YesController,
	NoController,
	SessionController,
	ExploreController
}

"Launch the server and control requests.
 
 See reference:
 https://modules.ceylon-lang.org/repo/1/ceylon/net/1.1.0/module-doc/api/index.html"
by ("Yutaka Kato")
class CounterServer() {
	Configuration conf = Configuration();
	
	// Start the server
	shared void start() {
		Server server = newServer {
			Endpoint {
				path = isRoot();
				service(Request request, Response response)
						=> NewController().handle(request, response);
			},
			Endpoint {
				path = endsWith("/");
				service(Request request, Response response)
						=> SessionController().handle(request, response);
			},
			Endpoint {
				path = endsWith("/yes");
				service(Request request, Response response)
						=> YesController().handle(request, response);
			},
			Endpoint {
				path = endsWith("/no");
				service(Request request, Response response)
						=> NoController().handle(request, response);
			},
			Endpoint {
				path = startsWith("/explore");
				service(Request request, Response response)
						=> ExploreController().handle(request, response);
			},
			AsynchronousEndpoint {
				path = startsWith("");
				service = serveStaticFile(".");
			}
		};
		server.start(SocketAddress(conf.address, conf.port));
	}
}
