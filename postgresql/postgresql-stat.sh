#! /bin/bash

source /etc/profile

rval=0
sql=""

case $1 in
    'total_size')
        sql="select sum(pg_database_size(datid)) as total_size from pg_stat_database"
        ;;

    'db_size')
        if [ ! -z $2 ]; then
            shift
            sql="select pg_database_size('$1')"
        fi
        ;;
		
    'db_cache')
        if [ ! -z $2 ]; then
            shift
            sql="select cast(blks_hit/(blks_read+blks_hit+0.000001)*100.0 as numeric(5,2)) as cache from pg_stat_database where datname = '$1'"
        fi
        ;;

    'db_temp_files')
        if [ ! -z $2 ]; then
            shift
            sql="select temp_files from pg_stat_database where datname = '$1'"
        fi
        ;;
		
    'db_temp_bytes')
        if [ ! -z $2 ]; then
            shift
            sql="select temp_bytes from pg_stat_database where datname = '$1'"
        fi
        ;;

    'db_tup_dead')
        if [ ! -z $2 ]; then
            shift
            DB=$1
            sql="select cast(sum(n_dead_tup) as integer) as n_dead_tup from pg_stat_user_tables"
        fi
        ;;
		
    'db_success')
        if [ ! -z $2 ]; then
            shift
            sql="select cast(xact_commit/(xact_rollback+xact_commit+0.000001)*100.0 as numeric(5,2)) as success from pg_stat_database where datname = '$1'"
        fi
        ;;

    'db_commited')
        if [ ! -z $2 ]; then
            shift
            sql="select xact_commit from pg_stat_database where datname = '$1'"
        fi
        ;;

    'db_rolled')
        if [ ! -z $2 ]; then
            shift
            sql="select xact_rollback from pg_stat_database where datname = '$1'"
        fi
        ;;

    'db_returned')
        if [ ! -z $2 ]; then
            shift
            sql="select tup_returned from pg_stat_database where datname = '$1'"
        fi
        ;;

    'db_fetched')
        if [ ! -z $2 ]; then
            shift
            sql="select tup_fetched from pg_stat_database where datname = '$1'"
        fi
        ;;

    'db_inserted')
        if [ ! -z $2 ]; then
            shift
            sql="select tup_inserted from pg_stat_database where datname = '$1'"
        fi
        ;;

    'db_updated')
        if [ ! -z $2 ]; then
            shift
            sql="select tup_updated from pg_stat_database where datname = '$1'"
        fi
        ;;

    'db_deleted')
        if [ ! -z $2 ]; then
            shift
            sql="select tup_deleted from pg_stat_database where datname = '$1'"
        fi
        ;;

    'tx_commited')
        sql="select sum(xact_commit) from pg_stat_database"
        ;;

    'tx_rolledback')
        sql="select sum(xact_rollback) from pg_stat_database"
        ;;
		
    'db_connections')
        if [ ! -z $2 ]; then
            shift
            sql="select numbackends from pg_stat_database where datname = '$1'"
        fi
        ;;
		
    'master_replication_lag_bytes')
        sql="SELECT sent_offset - ( replay_offset - (sent_xlog - replay_xlog) * 255 * 16 ^ 6 ) AS byte_lag FROM (SELECT ('x' || lpad(split_part(sent_location,   '/', 1), 8, '0'))::bit(32)::bigint AS sent_xlog, ('x' || lpad(split_part(replay_location, '/', 1), 8, '0'))::bit(32)::bigint AS replay_xlog, ('x' || lpad(split_part(sent_location,   '/', 2), 8, '0'))::bit(32)::bigint AS sent_offset, ('x' || lpad(split_part(replay_location, '/', 2), 8, '0'))::bit(32)::bigint AS replay_offset FROM pg_stat_replication ) AS s"
        ;;

    'slave_replication_lag_timestamp')
        sql="SELECT now()-pg_last_xact_replay_timestamp() AS lag"
        ;;
		
    'recovery_state')
        sql="select pg_is_in_recovery()"
        ;;

    'replication_state')
        if [ ! -z $2 ]; then
            shift
            sql="select COALESCE((select true from pg_stat_replication where client_addr='$1'), false)"
        fi
        ;;

    'pg_settings')
        if [ ! -z $2 ]; then
            shift
            sql="select setting from pg_settings where name = '$1'"
        fi
        ;;
		
    'active_connections')
        sql="select count(*) from pg_stat_activity"
        ;;

    'version')
        sql="version"
        ;;
    *)
        echo "usage:"
        echo "    $0 total_size                             -- Check the total databases size."
        echo "    $0 db_size <dbname>                       -- Check the size of a Database (in bytes)."
        
	echo "    $0 db_cache <dbname>                      -- Check the database cache hit ratio (percentage)."
        echo "    $0 db_temp_files <dbname>                 -- Return the number of temporary files generated."
        echo "    $0 db_temp_bytes <dbname>                 -- Return the size (bytes) of temporary files generated."
	echo "    $0 db_tup_dead <dbname>                   -- Return the number of tuples dead to all tables in specific database."

        echo "    $0 db_success <dbname>                    -- Check the database success rate (percentage)."
        echo "    $0 db_commited <dbname>                   -- Check the number of commited back transactions for a specified database."
        echo "    $0 db_rolled <dbname>                     -- Check the number of rolled back transactions for a specified database."
		
        echo "    $0 db_returned <dbname>                   -- Check the number of tuples returned for a specified database."
        echo "    $0 db_fetched <dbname>                    -- Check the number of tuples fetched for a specified database."
        echo "    $0 db_inserted <dbname>                   -- Check the number of tuples inserted for a specified database."
        echo "    $0 db_updated <dbname>                    -- Check the number of tuples updated for a specified database."
        echo "    $0 db_deleted <dbname>                    -- Check the number of tuples deleted for a specified database."
		
        echo "    $0 tx_commited                            -- Check the total number of commited transactions."
        echo "    $0 tx_rolledback                          -- Check the total number of rolled back transactions."
		
        echo "    $0 db_connections <dbname>                -- Check the number of active connections for a specified database."
        echo "    $0 master_replication_lag_bytes           -- Check the size in bytes of the lag between the master server and slave."
        echo "    $0 slave_replication_lag_timestamp        -- Check the time lag between the replication master and slave."
        echo "    $0 recovery_state                         -- Check the recovery state recovery for a host postgresql."
        echo "    $0 replication_state <ip_slave>           -- Check the stats of replication."
        echo "    $0 pg_settings <setting_name>             -- Returns the setting of a parameter postgresql."
        echo "    $0 active_connections                     -- Check the number of active connection."
		
        echo "    $0 version                                -- The PostgreSQL version."
        exit $rval
        ;;
esac

if [ "$sql" != "" ]; then
    if [ "$sql" == "version" ]; then
        psql --version|head -n1
        rval=$?
    else
        if [ "$DB" == "" ]; then
            DB=postgres
        fi
        psql -t -c "$sql" $DB
        rval=$?
    fi
fi

if [ "$rval" -ne 0 ]; then
    echo "ZBX_NOTSUPPORTED"
fi

exit $rval
