package functions;

import java.util.function.Function;

public class Echo implements Function<String, String> {

	public String apply(String name) {
		return "Echoing: " + name;
	}
}