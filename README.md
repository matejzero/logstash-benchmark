Logstash benchmark
===================

I was wondering how different filters and ways of calling them affect performance of logstash, so I decided to do a simple benchmark. I tested logstash 1.4.2 (stable) and current devel version from github(from 5.10.2014).

How I tested
-------------
All test were done in VMware VMs and each had 6vCPUs (6x2,55GHz). None of the CPUs were occupied by any other VM, so logstash had the whole power just for him. When I was testing with 6 cores, 2 cores were on a different NUMA node, since I had 2x4core CPUs in my server.

Every test was done with 3 generator input plugin, generating 3 different log types (dovecot, postfix, roundcube).
Every test had metric plugin loaded
Every test was sending metrics to graphite using graphite output plugin

Every test was run for 30min:

 - 10 minutes with 1 worker and 3 CPUs
 - 10 minutes with 2 workers and 4 CPUs
 - 10 minutes with 4 workers and 6 CPUs


#### **logstash-bench.sh**
I used logstash-bench.sh script to run all my tests.

Script does the following:
 - Set starting point ( enable 3 cpus only and set 1 worker) and run
   logstash
 - Run for 10 minutes then add 1 cpu and 1 worker
 - Run for 10 minutes then add 2 cpus and 2 workers
 - After 30 minutes, shutdown logstash

**Usage**: logstash-bench.sh test-number version ( logstash-bench.sh 1 stable )

Test scenarios
-------------
I tested a couple of different scenarios, to see how logstash performed. 

Scenarios:

- No filter
- Partial grok filters (only one match for every type) 
- Full grok filters inside config file
- Full grok filters from patterns file
- Full grok filters inside config file and some other modifications (date, mutate, rename)
- Full grok filters from patterns file and some other modifications (date, mutate, rename)

Per test results and graph:
-------------
#### 1. No filter
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 84176     |  61714    |
| 2                 | 83825     |  67051    |
| 4                 | 89235     |  68272    |

![Rate graph](https://github.com/matejzero/logstash-benchmark/blob/master/graphs/1-rate.png)

#### 2. Partial grok filters (only one match for every type) 
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 7099      |  10072    |
| 2                 | 14593     |  20464    |
| 4                 | 27796     |  39950    |

![Rate graph](https://github.com/matejzero/logstash-benchmark/blob/master/graphs/2-rate.png)

#### 3. Full grok filters inside config file
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 5870      |  7813     |
| 2                 | 11346     |  15724    |
| 4                 | 22654     |  30283    |

![Rate graph](https://github.com/matejzero/logstash-benchmark/blob/master/graphs/3-rate.png)

#### 4. Full grok filters from patterns file
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 1997      |  5381     |
| 2                 | 3105      |  10364    |
| 4                 | 5022      |  19249    |

![Rate graph](https://github.com/matejzero/logstash-benchmark/blob/master/graphs/4-rate.png)

#### 5. Full grok filters inside config file and some other modifications (date, mutate, rename)
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 1945      |  2123     |
| 2                 | 3380      |  2896     |
| 4                 | 5952      |  5189     |

![Rate graph](https://github.com/matejzero/logstash-benchmark/blob/master/graphs/5-rate.png)

#### 6. Full grok filters from patterns file and some other modifications (date, mutate, rename)
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 831       |  1177     |
| 2                 | 1526      |  2303     |
| 4                 | 2865      |  4107     |

![Rate graph](https://github.com/matejzero/logstash-benchmark/blob/master/graphs/6-rate.png)

Results
----------
| Test `#`  | 1 worker  | 2 workers   | 3 workers  |
|:-:|:-:|:-:|:-:|
| Test #1 - stable   | 84176  | 83825 | 89235 |
| Test #1 - devel    | 61714  | 67051 | 68272 |
| Test #2 - stable   |  7099  | 14593 | 27796 |
| Test #2 - devel    | 10072  | 20464 | 39950 |
| Test #3 - stable   |  5870  | 11346 | 22654 |
| Test #3 - devel    |  7813  | 15724 | 30283 |
| Test #4 - stable   |  1997  |  3105 |  5022 |
| Test #4 - devel    |  5381  | 10364 | 19249 |
| Test #5 - stable   |  1945  |  3380 |  5952 |
| Test #5 - devel    |  2123  |  2896 |  5189 |
| Test #6 - stable   |   831  |  1526 |  2865 |
| Test #6 - devel    |  1177  |  2303 |  4107 |
