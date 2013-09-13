zabbix-postgresql
=================

Monitoring script for postgresql

The collection of statistics PostgreSQL received new features, we now have the following:
=================
- total_size                             -- Check the total databases size.
- db_size <dbname>                       -- Check the size of a Database (in bytes).
        
- db_cache <dbname>                      -- Check the database cache hit ratio (percentage).
- db_temp_files <dbname>                 -- Return the number of temporary files generated.
- db_temp_bytes <dbname>                 -- Return the size (bytes) of temporary files generated.
- db_tup_dead <dbname>                   -- Return the number of tuples dead to all tables in specific database.

- db_success <dbname>                    -- Check the database success rate (percentage).
- db_commited <dbname>                   -- Check the number of commited back transactions for a specified database.
- db_rolled <dbname>                     -- Check the number of rolled back transactions for a specified database.
		
- db_returned <dbname>                   -- Check the number of tuples returned for a specified database.
- db_fetched <dbname>                    -- Check the number of tuples fetched for a specified database.
- db_inserted <dbname>                   -- Check the number of tuples inserted for a specified database.
- db_updated <dbname>                    -- Check the number of tuples updated for a specified database.
- db_deleted <dbname>                    -- Check the number of tuples deleted for a specified database.
		
- tx_commited                            -- Check the total number of commited transactions.
- tx_rolledback                          -- Check the total number of rolled back transactions.
		
- db_connections <dbname>                -- Check the number of active connections for a specified database.
- master_replication_lag_bytes           -- Check the size in bytes of the lag between the master server and slave.
- slave_replication_lag_timestamp        -- Check the time lag between the replication master and slave.
- recovery_state                         -- Check the recovery state recovery for a host postgresql.
- replication_state <ip_slave>           -- Check the stats of replication.
- pg_settings <setting_name>             -- Returns the setting of a parameter postgresql.
- active_connections                     -- Check the number of active connection.
		
- version                                -- The PostgreSQL version.
