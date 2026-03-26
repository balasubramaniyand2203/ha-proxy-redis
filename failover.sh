#!/bin/sh
# Give the system time to boot and sync
sleep 15

while true; do
  # Ping the master. If it fails...
  if ! redis-cli -h redis-master -a "prod_password" ping | grep -q PONG; then
    echo "MASTER DETECTED DOWN. Initiating self-promotion..."
    
    # Command to stop being a replica and become master
    redis-cli -a "prod_password" replicaof no one
    
    echo "I am now the Master node. Failover complete."
    break # Exit script as we are now the primary
  fi
  sleep 2
done
