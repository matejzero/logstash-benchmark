logstash-benchmark
==================

I was wondering how logstash performs and how much impact certain plugins, that I intend to use, have on performance.

My test machine was 4x2,5GHz CPU and 8GB RAM.

All tests had 3 generator input filters, 3 filter workers and 1 output (graphite and stdout(metrics only).
Every test was lasting 30 minutes.


Test scenarios
-----------

* Base measurement - default generator plugin and no filters. - bench01
```
Result: 
Every generator running at 30% CPU.
Every worker running at 30% CPU.
Output running at 70% CPU.

Speed: 66000 events/s
```
![Bench01](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-1-average-log.png "Benchmark 01")

* Log examples in generator plugin and no filters  - bench02
```
Result: 
Every generator running at 33% CPU.
Every worker running at 30% CPU.
Output running at 70% CPU.

Speed: 70000 events/s
```
![Bench02](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-2-average-log.png "Benchmark 02")

* Log examples in generator and partial grok filters (one line for every type)  - bench03
```
Result: 
Every generator running at 16% CPU.
Every worker running at 90% CPU.
Output running at 28% CPU.

Speed: 22000 events/s
```
![Bench03](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-3-average-log.png "Benchmark 03")

* Same as above, but droping logs (inside if statements for every type), that are not successfully parsed - bench04

* Log examples in generator and full grok filters inside config file - bench05
```
Result: 
Every generator running at 12% CPU.
Every worker running at 95% CPU.
Output running at 26% CPU.

Speed: 16000 events/s
```
![Bench05](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-5-average-log.png "Benchmark 05")

* Log examples in generator and full grok filters from patterns file - bench06
```
Result: 
Every generator running at 5% CPU.
Every worker running at 95% CPU.
Output running at 7% CPU.

Speed: 4000 events/s
```
![Bench06](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-6-average-log.png "Benchmark 06")

* Log examples in generator, full grok parse and some other modifications (date, mutate, rename) and different numbers of filter worker
  * grok filters inside config file
```
Result - 3 workers: 
Every generator running at 6% CPU.
Every worker running at 90% CPU.
Output running at 9% CPU.

Speed: 4000 events/s
```

```
Result - 4 workers: 
Every generator running at 4% CPU.
Every worker running at 75% CPU.
Output running at 6% CPU.

Speed: 5000 events/s
```

```
Result - 6 workers: 
Every generator running at 3% CPU.
Every worker running at 45% CPU.
Output running at 7% CPU.

Speed: 4300 events/s
```

![Bench071](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-71-average-log.png "Benchmark 071")

  * grok filters from patterns file

```
Result - 3 workers: 
Every generator running at - CPU.
Every worker running at 90% CPU.
Output running at - CPU.

Speed: 2200 events/s
```

```
Result - 4 workers: 
Every generator running at 4% CPU.
Every worker running at 75% CPU.
Output running at 6% CPU.

Speed: 5000 events/s
```

```
Result - 6 workers: 
Every generator running at 3% CPU.
Every worker running at 45% CPU.
Output running at 7% CPU.

Speed: 4300 events/s
```

![Bench072](https://github.com/matejzero/logstash-benchmark/blob/master/graphite-graphs/bench-72-average-log.png "Benchmark 072")

Results
-----------

| Bench number  | Generator CPU  | Worker CPU | Output CPU | Events/s  |
| :--------------:|:-------------:| :-----:| :-----:| :-----:|
| 1  	 | 30% | 30% | 70% | **66000** |
| 2  	 | 33% | 30% | 70% | **70000** |
| 3 	 | 16% | 90% | 28% | **22000** |
| 4 	 | - | - | - | - |
| 5 	 | 12% | 95% |  26% |  **4000** |
| 6  	 |  5% | 95% |  7% |  **4000** |
| 7.1 w3 | 6% | 90% | 9% | **4000** |
| 7.1 w4 | 4% | 75% | 6% | **5000** |
| 7.1 w6 | 3% | 45% | 7% | **4300** |
| 7.2 w3 | - | 95% | - | **2300** |
| 7.2 w4 | - | 75% | - | **2600** |
| 7.2 w6 | 2%  | 50% | 3% | **4300** |


 
