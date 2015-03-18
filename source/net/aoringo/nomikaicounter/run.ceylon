/*
 * Copyright(C) 2014-2015 Yutaka Kato All rights reserved.
 */
import ceylon.logging {
	addLogWriter,
	Priority,
	Category,
	trace
}

"Run the module `net.aoringo.ds.server`."
by ("Yutaka Kato")
shared void run() {
	print("DrinkingSession run()");
	setupLogger(trace);
	CounterServer server = CounterServer();
	server.start();
}

void setupLogger(Priority level) {
	addLogWriter {
		void log(Priority p, Category c, String m, Exception? e) {
			value print = p <= level
					then process.writeLine
					else process.writeError;
			print("[``system.milliseconds``] ``p.string`` ``m``");
			if (exists e) {
				printStackTrace(e, print);
			}
		}
	};
}
