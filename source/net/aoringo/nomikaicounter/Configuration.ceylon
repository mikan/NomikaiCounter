by ("Yutaka Kato")
shared class Configuration() {
	
	String _address = "0.0.0.0";
	Integer _port = 10000;
	
	shared String address => _address;
	shared Integer port => _port;
}
