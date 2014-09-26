logstash-benchmark
==================

I was wondering how logstash performs and how much impact certain plugins, that I intend to use, have on performance.

My test machine was 4x2,5GHz CPU and 8GB RAM.

All tests 3 generator input filters, 3 filter workers and 1 output (graphite and stdout(metrics only).


Test scenarios
-----------

- Base measurement:
Default generator plugin and no filters.

Result: 
Every generator running at 30% CPU.
Every worker running at 30% CPU.
Output running at 70% CPU.

Speed: 66000 events/s

- Log examples in generator plugin and no filters
Result: 
Every generator running at 33% CPU.
Every worker running at 30% CPU.
Output running at 70% CPU.

Speed: 70000 events/s

- Logs examples in generator and partial grok filters (one line for every type)
Result: 
Every generator running at 16% CPU.
Every worker running at 90% CPU.
Output running at 28% CPU.

Speed: 22000 events/s

- Same as above, but droping logs (inside if statements for every type), that are not successfully parsed  ### ne vem kako ###

- Logs examples in generator and full grok filters inside config file
Result: 
Every generator running at 12% CPU.
Every worker running at 95% CPU.
Output running at 26% CPU.

Speed: 16000 events/s

- Logs examples in generator and full grok filters from patterns file.
Result: 
Every generator running at 5% CPU.
Every worker running at 95% CPU.
Output running at 7% CPU.

Speed: 4000 events/s

- Logs examples in generator, full grok parse and some other modifications (date, mutate, rename)
	- grok filters inside config file
	- grok filters from patterns file