logstash-benchmark
==================

I was wondering how logstash performs and how much impact certain plugins, that I intend to use, have on performance.

My test machine was 4x2,5GHz CPU and 8GB RAM.

All tests 3 generator input filters, 3 filter workers and 1 output (graphite and stdout(metrics only).


Test scenarios
-----------

- Base measurement: default generator plugins and no filters. Every generator was running at 30%, workers also at 30% and output at 70% CPU. I was getting around 66000events/s.

- Logs examples in generator plugin and no filters. Every generator was running at 33%, workers also at 30% and output at 70% CPU. I was getting around 70000events/s.

- Logs examples in generator and partial grok filters (one line for every type). Every generator was running at 16%, workers were at 90% and output at 28% CPU. I was getting around 22000events/s.

- Same as above, but droping logs (inside if statements for every type), that are not successfully parsed  ### ne vem kako ###

- Logs examples in generator and full grok filters inside config file. Every generator was running at 12%, workers were at 95% and output at 26% CPU. I was getting around 16000events/s.

- Logs examples in generator and full grok filters from patterns file. Every generator was running at 5%, workers were at 95% and output at 7% CPU. I was getting around 4000events/s.

- Logs examples in generator, full grok parse and some other modifications (date, mutate, rename)
	- grok filters inside config file
	- grok filters from patterns file