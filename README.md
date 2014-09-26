logstash-benchmark
==================

I was wondering how logstash performs and how much impact certain plugins, that I intend to use, have on performance.

My test machine was 4x2,5GHz CPU and 8GB RAM.

All tests had 3 generator input filters, 3 filter workers and 1 output (graphite and stdout(metrics only).


Test scenarios
-----------

- Base measurement - default generator plugin and no filters. - bench01


```Result: 
Every generator running at 30% CPU.
Every worker running at 30% CPU.
Output running at 70% CPU.

Speed: 66000 events/s
```
![Bench01](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-1-average-log.png "Benchmark 01")
- Log examples in generator plugin and no filters  - bench02
```Result: 
Every generator running at 33% CPU.
Every worker running at 30% CPU.
Output running at 70% CPU.

Speed: 70000 events/s
```
![Bench02](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-2-average-log.png "Benchmark 02")
- Logs examples in generator and partial grok filters (one line for every type)  - bench03
```Result: 
Every generator running at 16% CPU.
Every worker running at 90% CPU.
Output running at 28% CPU.

Speed: 22000 events/s
```
![Bench03](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-3-average-log.png "Benchmark 03")
- Same as above, but droping logs (inside if statements for every type), that are not successfully parsed - bench04

- Logs examples in generator and full grok filters inside config file - bench05
```Result: 
Every generator running at 12% CPU.
Every worker running at 95% CPU.
Output running at 26% CPU.

Speed: 16000 events/s
```
![Bench05](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-5-average-log.png "Benchmark 05")
- Logs examples in generator and full grok filters from patterns file - bench06
```Result: 
Every generator running at 5% CPU.
Every worker running at 95% CPU.
Output running at 7% CPU.

Speed: 4000 events/s
```
![Bench06](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-6-average-log.png "Benchmark 06")
- Logs examples in generator, full grok parse and some other modifications (date, mutate, rename)
	- grok filters inside config file
	- grok filters from patterns file
