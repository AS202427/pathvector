dummy-iface:
	# Allow UDP ping. For more information, see https://github.com/go-ping/ping#linux
	sudo sysctl -w net.ipv4.ping_group_range="0 2147483647"

	sudo ip link del dev dummy0 2>/dev/null
	sudo ip link add dev dummy0 type dummy
	sudo ip addr add dev dummy0 192.0.2.1/24
	sudo ip link set dev dummy0 up

peeringdb-test-harness:
	nohup python3 tests/peeringdb/peeringdb-test-api.py &

test-setup: dummy-iface peeringdb-test-harness

test:
	go test -race -coverprofile=coverage.txt -covermode=atomic ./pkg/... ./cmd/...

test-teardown:
	pkill -f tests/peeringdb/peeringdb-test-api.py
	sudo ip link del dev dummy0 2>/dev/null
