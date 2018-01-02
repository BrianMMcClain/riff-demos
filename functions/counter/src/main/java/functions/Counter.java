package functions;

import java.util.function.Function;
import redis.clients.jedis.Jedis;

public class Counter implements Function<String, String> {

	public String apply(String arg) {
		Jedis jedis = new Jedis("riff-redis.default.svc.cluster.local");
		Long counter = jedis.incr("riffcounter");
		jedis.close();
		return counter.toString();
	}
}