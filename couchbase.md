# Couchbase jepsen tests

## Cluster setup

- Install couchbase server on all nodes

```
	salticid couchbase.setup
```

- Cluster nodes and create bucket

```
	salticid couchbase.cluster
```

## Run tests

```
	lein run couchbase -n 4000
```

- Partition n1, n2 from n3, n4, n5

```
	salticid jepsen.partition
```

- Heal the server partition

```
	salticid jepsen.heal
```

- Partition clients from n1, n2 and heal after 30 seconds

```
	salticid/couchbase/partition_client.sh
```
	
- Rebalance node n3, n4, n5 after partitioning servers

```
	salticid couchbase.recluster
```
