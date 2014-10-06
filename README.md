Logstash benchmark
===================

I was wondering how different filters and ways of calling them affect performance of logstash, so I decided to do a simple benchmark. I tested logstash 1.4.2 (stable) and current devel version from github(from 5.10.2014).

----------
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

![Rate graph](https://github.com/matejzero/logstash-benchmark/graphs/1-rate.png)

#### 2. Partial grok filters (only one match for every type) 
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 7099     |  10072    |
| 2                 | 14593     |  20464    |
| 4                 | 27796     |  39950    |

![Rate graph](https://github.com/matejzero/logstash-benchmark/graphs/2-rate.png)

#### 3. Full grok filters inside config file
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 5870     |  7813    |
| 2                 | 11346     |  15724    |
| 4                 | 22654     |  30283    |

![Rate graph](https://github.com/matejzero/logstash-benchmark/graphs/3-rate.png)

#### 4. Full grok filters from patterns file
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 1997     |  5381    |
| 2                 | 3105     |  10364    |
| 4                 | 5022     |  19249    |

![Rate graph](https://github.com/matejzero/logstash-benchmark/graphs/4-rate.png)

#### 5. Full grok filters inside config file and some other modifications (date, mutate, rename)
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 1945     |  2123    |
| 2                 | 3380     |  2896    |
| 4                 | 5952     |  5189    |

![Rate graph](https://github.com/matejzero/logstash-benchmark/graphs/5-rate.png)

#### 6. Full grok filters from patterns file and some other modifications (date, mutate, rename)
| `#` of workers    | Stable LS | Devel   LS|
| :-------:         | :----:    | :---:     |
| 1                 | 831     |  1177    |
| 2                 | 1526     |  2303    |
| 4                 | 2865     |  4107    |

![Rate graph](https://github.com/matejzero/logstash-benchmark/graphs/6-rate.png)

