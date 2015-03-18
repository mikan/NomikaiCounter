"Define default configuration."
by ("Yutaka Kato")
class Configuration() {
	String _host = "localhost";
	Integer _port = 27017;
	String _db = "ds";
	String _colls = "sessions";
	shared String host => _host;
	shared Integer port => _port;
	shared String db => _db;
	shared String colls => _colls;
}
