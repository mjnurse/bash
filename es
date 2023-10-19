#!/bin/bash

debug_yn=n
if [[ "$1" == "-d" ]]; then
  debug_yn=y
  shift
fi

l80="--------------------------------------------------------------------------------"

c_bla="\\\e[30m"
c_blu="\\\e[34m"
c_cya="\\\e[36m"
c_def="\\\e[39m"
c_gra="\\\e[90m"
c_gre="\\\e[32m"
c_mag="\\\e[35m"
c_red="\\\e[31m"
c_whi="\\\e[97m"
c_yel="\\\e[33m"

c_lblu="\\\e[94m"
c_lcya="\\\e[96m"
c_lgra="\\\e[37m"
c_lgre="\\\e[92m"
c_lmag="\\\e[95m"
c_lred="\\\e[91m"
c_lyel="\\\e[93m"


function check_params() {
  # param 1 - actual number of parameters
  # param 2 - required number of parameters
  # param 3 - incorrect parameters message

  if [[ "$1" < "$2" ]]; then
    echo "$3"
    exit
  fi
}

function print_command() {
  # param 1 - command

  if [[ $debug_yn == y ]]; then
    echo "COMMAND: $*" | sed s/./-/g
    echo "COMMAND: $*"
    echo "COMMAND: $*" | sed s/./-/g
  fi
}

section="CLUSTER"
if [[ "$1 $2" == "clear cache" || "$1" == "ecc" ]]; then
   if [[ "$1" == "ecc" ]]; then shift; else shift 2; fi
   usage="clear cache (ecc) [<index_name>]"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o POST -a "$1/_cache/clear"
   query-es -o POST -a "$1/_cache/clear"
   exit
fi
if [[ "$1 $2" == "cluster overview" || "$1" == "eco" ]]; then
   if [[ "$1" == "eco" ]]; then shift; else shift 2; fi
   usage="cluster overview (eco)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "/"
   query-es -o GET -a "/"
   exit
fi
if [[ "$1 $2" == "cluster health" || "$1" == "ech" ]]; then
   if [[ "$1" == "ech" ]]; then shift; else shift 2; fi
   usage="cluster health (ech)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cluster/health?human&pretty"
   query-es -o GET -a "_cluster/health?human&pretty"
   exit
fi
if [[ "$1 $2" == "cluster stats" || "$1" == "ecs" ]]; then
   if [[ "$1" == "ecs" ]]; then shift; else shift 2; fi
   usage="cluster stats (ecs)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cluster/stats?human&pretty"
   query-es -o GET -a "_cluster/stats?human&pretty"
   exit
fi
section="INDEX INTERROGATION"
if [[ "$1" == "count" || "$1" == "ec" ]]; then
   if [[ "$1" == "ec" ]]; then shift; else shift 1; fi
   usage="count (ec) <index_name>"
   check_params $# 1 "Usage: $usage"
   print_command query-es -o GET -a "/$1/_count?pretty"
   query-es -o GET -a "/$1/_count?pretty"
   exit
fi
if [[ "$1 $2" == "list aliases" || "$1" == "ela" ]]; then
   if [[ "$1" == "ela" ]]; then shift; else shift 2; fi
   usage="list aliases (ela) [<filter>] [<order_by_field_name>]"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cat/aliases?v&s=$2" -r 1 -f '1p;t; s/\(.*'$1'.*$\)/\1/;t;d'
   query-es -o GET -a "_cat/aliases?v&s=$2" -r 1 -f '1p;t; s/\(.*'$1'.*$\)/\1/;t;d'
   exit
fi
if [[ "$1 $2" == "list indices" || "$1" == "eli" ]]; then
   if [[ "$1" == "eli" ]]; then shift; else shift 2; fi
   usage="list indices (eli) [<index_name>]"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cat/indices/$1?v&h=health,status,index,pri,rep,sc,docs.count,docs.deleted,store.size,pri.store.size&s=index" -r 1
   query-es -o GET -a "_cat/indices/$1?v&h=health,status,index,pri,rep,sc,docs.count,docs.deleted,store.size,pri.store.size&s=index" -r 1
   exit
fi
if [[ "$1 $2" == "list shards" || "$1" == "els" ]]; then
   if [[ "$1" == "els" ]]; then shift; else shift 2; fi
   usage="list shards (els) [<index_name>] [<order_by_field_name>]"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cat/shards/$1?v&h=index,shard,prirep,sc,state,docs,store,node&s=index,shard,prirep&s=$2" -r 1
   query-es -o GET -a "_cat/shards/$1?v&h=index,shard,prirep,sc,state,docs,store,node&s=index,shard,prirep&s=$2" -r 1
   exit
fi
if [[ "$1 $2 $3" == "list shard details" || "$1" == "elsd" ]]; then
   if [[ "$1" == "elsd" ]]; then shift; else shift 3; fi
   usage="list shard details (elsd) [<index_name>] [<order_by_field_name>]"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cat/shards/$1?v&h=index,shard,prirep,state,docs,store,ip,segments.count,unassigned.reason,unassigned.for,node&s=$2"
   query-es -o GET -a "_cat/shards/$1?v&h=index,shard,prirep,state,docs,store,ip,segments.count,unassigned.reason,unassigned.for,node&s=$2"
   exit
fi
if [[ "$1 $2" == "list segments" || "$1" == "ele" ]]; then
   if [[ "$1" == "ele" ]]; then shift; else shift 2; fi
   usage="list segments (ele) [<index_name>]"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cat/segments/$1?v&s=index,shard,prirep"
   query-es -o GET -a "_cat/segments/$1?v&s=index,shard,prirep"
   exit
fi
if [[ "$1 $2 $3" == "list segmented shards" || "$1" == "elss" ]]; then
   if [[ "$1" == "elss" ]]; then shift; else shift 3; fi
   usage="list segmented shards (elss) [<index_name>]"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cat/shards/$1?v&h=index,shard,prirep,state,docs,node,segments.count&s=index,shard,prirep,node" -f '/ 1$/d'
   query-es -o GET -a "_cat/shards/$1?v&h=index,shard,prirep,state,docs,node,segments.count&s=index,shard,prirep,node" -f '/ 1$/d'
   exit
fi
if [[ "$1 $2 $3" == "get index mapping" || "$1" == "egim" ]]; then
   if [[ "$1" == "egim" ]]; then shift; else shift 3; fi
   usage="get index mapping (egim) <index_name>"
   check_params $# 1 "Usage: $usage"
   print_command query-es -o GET -a "/$1/_mapping?pretty"
   query-es -o GET -a "/$1/_mapping?pretty"
   exit
fi
if [[ "$1 $2 $3" == "list unassigned shards" || "$1" == "elus" ]]; then
   if [[ "$1" == "elus" ]]; then shift; else shift 3; fi
   usage="list unassigned shards (elus)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cat/shards?v&h=index,shard,prirep,state,docs,segments.count&s=index,shard,prirep"    -f 's/\(.* \(INITIALIZING\|UNASSIGNED\) .*\)/\1/;t;d'
   query-es -o GET -a "_cat/shards?v&h=index,shard,prirep,state,docs,segments.count&s=index,shard,prirep"    -f 's/\(.* \(INITIALIZING\|UNASSIGNED\) .*\)/\1/;t;d'
   exit
fi
if [[ "$1 $2" == "forcemerge progress" || "$1" == "efmp" ]]; then
   if [[ "$1" == "efmp" ]]; then shift; else shift 2; fi
   usage="forcemerge progress (efmp)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "/_cat/nodes?v&h=name,cpu,load_1m,merges.current,merges.current_docs,merges.total,merges.total_docs&s=name"
   query-es -o GET -a "/_cat/nodes?v&h=name,cpu,load_1m,merges.current,merges.current_docs,merges.total,merges.total_docs&s=name"
   exit
fi
section="INDEX MANIPULATION"
if [[ "$1 $2 $3 $4" == "add index to alias" || "$1" == "eaita" ]]; then
   if [[ "$1" == "eaita" ]]; then shift; else shift 4; fi
   usage="add index to alias (eaita) <index_name> <alias_name>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o POST -a "_aliases" -j '{"actions":[{"add":{"index":"'$1'","alias":"'$2'"}}]}'
   query-es -o POST -a "_aliases" -j '{"actions":[{"add":{"index":"'$1'","alias":"'$2'"}}]}'
   exit
fi
if [[ "$1 $2 $3 $4" == "remove index from alias" || "$1" == "erifa" ]]; then
   if [[ "$1" == "erifa" ]]; then shift; else shift 4; fi
   usage="remove index from alias (erifa) <index_name> <alias_name>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o DELETE -a "$1/_aliases/$2"
   query-es -o DELETE -a "$1/_aliases/$2"
   exit
fi
if [[ "$1 $2" == "create index" || "$1" == "eci" ]]; then
   if [[ "$1" == "eci" ]]; then shift; else shift 2; fi
   usage="create index (eci) <index_name> <number_of_shards> <number_of_replicas>"
   check_params $# 3 "Usage: $usage"
   print_command query-es -o PUT -a "$1" -j '{"settings":{"index":{"number_of_shards":'$2',"number_of_replicas":'$3'}}}'
   query-es -o PUT -a "$1" -j '{"settings":{"index":{"number_of_shards":'$2',"number_of_replicas":'$3'}}}'
   exit
fi
if [[ "$1 $2 $3 $4" == "create index from mapping" || "$1" == "ecifm" ]]; then
   if [[ "$1" == "ecifm" ]]; then shift; else shift 4; fi
   usage="create index from mapping (ecifm) <index_name> <number_of_shards> <number_of_replicas> <mapping-json>"
   check_params $# 4 "Usage: $usage"
   print_command query-es -o PUT -a "$1" -j '{"settings":{"index":{"number_of_shards":'$2',"number_of_replicas":'$3'}},"mappings":'$4'}'
   query-es -o PUT -a "$1" -j '{"settings":{"index":{"number_of_shards":'$2',"number_of_replicas":'$3'}},"mappings":'$4'}'
   exit
fi
if [[ "$1 $2" == "clone index" || "$1" == "eclni" ]]; then
   if [[ "$1" == "eclni" ]]; then shift; else shift 2; fi
   usage="clone index (eclni) <index_name> <new_index_name>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o POST -a "$1/_clone/$2"
   query-es -o POST -a "$1/_clone/$2"
   exit
fi
if [[ "$1 $2" == "delete index" || "$1" == "edi" ]]; then
   if [[ "$1" == "edi" ]]; then shift; else shift 2; fi
   usage="delete index (edi) <index_name>"
   check_params $# 1 "Usage: $usage"
   print_command query-es -o DELETE -a "$1"
   query-es -o DELETE -a "$1"
   exit
fi
if [[ "$1 $2" == "open index" || "$1" == "eopi" ]]; then
   if [[ "$1" == "eopi" ]]; then shift; else shift 2; fi
   usage="open index (eopi) <index_name>"
   check_params $# 1 "Usage: $usage"
   print_command query-es -o POST -a "$1/_open"
   query-es -o POST -a "$1/_open"
   exit
fi
if [[ "$1 $2" == "close index" || "$1" == "ecli" ]]; then
   if [[ "$1" == "ecli" ]]; then shift; else shift 2; fi
   usage="close index (ecli) <index_name>"
   check_params $# 1 "Usage: $usage"
   print_command query-es -o POST -a "$1/_close"
   query-es -o POST -a "$1/_close"
   exit
fi
if [[ "$1 $2 $3" == "enable read only" || "$1" == "eero" ]]; then
   if [[ "$1" == "eero" ]]; then shift; else shift 3; fi
   usage="enable read only (eero) <index_name>"
   check_params $# 1 "Usage: $usage"
   print_command query-es -o PUT -a "$1/_settings" -j '{"index.blocks.write": true}'
   query-es -o PUT -a "$1/_settings" -j '{"index.blocks.write": true}'
   exit
fi
if [[ "$1 $2 $3" == "enable read write" || "$1" == "eerw" ]]; then
   if [[ "$1" == "eerw" ]]; then shift; else shift 3; fi
   usage="enable read write (eerw) <index_name>"
   check_params $# 1 "Usage: $usage"
   print_command query-es -o PUT -a "$1/_settings" -j '{"index.blocks.write": false}'
   query-es -o PUT -a "$1/_settings" -j '{"index.blocks.write": false}'
   exit
fi
if [[ "$1 $2" == "reindex index" || "$1" == "eri" ]]; then
   if [[ "$1" == "eri" ]]; then shift; else shift 2; fi
   usage="reindex index (eri) <source_index_name> <dest_index_name>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o POST -a "_reindex" -j '{"source":{"index":"'$1'"},"dest":{"index":"'$2'"}}'
   query-es -o POST -a "_reindex" -j '{"source":{"index":"'$1'"},"dest":{"index":"'$2'"}}'
   exit
fi
if [[ "$1 $2" == "move shard" || "$1" == "ems" ]]; then
   if [[ "$1" == "ems" ]]; then shift; else shift 2; fi
   usage="move shard (ems) <index_name> <shard_num> <from_node_name> <to_node_name>"
   check_params $# 4 "Usage: $usage"
   print_command query-es -o POST -a "_cluster/reroute" -j '{"commands":[{"move":{"index":"'$1'","shard":'$2',"from_node":"'$3'","to_node":"'$4'"}}]}'
   query-es -o POST -a "_cluster/reroute" -j '{"commands":[{"move":{"index":"'$1'","shard":'$2',"from_node":"'$3'","to_node":"'$4'"}}]}'
   exit
fi
if [[ "$1 $2 $3" == "alter number replicas" || "$1" == "eanr" ]]; then
   if [[ "$1" == "eanr" ]]; then shift; else shift 3; fi
   usage="alter number replicas (eanr) <index_name> <number_of_replicas>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o PUT -a "$1/_settings" -j '{"index":{"number_of_replicas":'$2'}}'
   query-es -o PUT -a "$1/_settings" -j '{"index":{"number_of_replicas":'$2'}}'
   exit
fi
if [[ "$1 $2 $3" == "disable shard allocation" || "$1" == "edsa" ]]; then
   if [[ "$1" == "edsa" ]]; then shift; else shift 3; fi
   usage="disable shard allocation (edsa)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o PUT -a "_cluster/settings" -j '{"persistent":{"cluster.routing.allocation.enable":"primaries"}}'
   query-es -o PUT -a "_cluster/settings" -j '{"persistent":{"cluster.routing.allocation.enable":"primaries"}}'
   exit
fi
if [[ "$1 $2 $3" == "reenable shard allocation" || "$1" == "ersa" ]]; then
   if [[ "$1" == "ersa" ]]; then shift; else shift 3; fi
   usage="reenable shard allocation (ersa)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o PUT -a "_cluster/settings" -j '{"persistent":{"cluster.routing.allocation.enable":null}}'
   query-es -o PUT -a "_cluster/settings" -j '{"persistent":{"cluster.routing.allocation.enable":null}}'
   exit
fi
if [[ "$1" == "forcemerge" || "$1" == "efm" ]]; then
   if [[ "$1" == "efm" ]]; then shift; else shift 1; fi
   usage="forcemerge (efm) <index_name> <max_num_segments>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o POST -a "$1/_forcemerge?max_num_segments=$2"
   query-es -o POST -a "$1/_forcemerge?max_num_segments=$2"
   exit
fi
if [[ "$1" == "refresh" || "$1" == "er" ]]; then
   if [[ "$1" == "er" ]]; then shift; else shift 1; fi
   usage="refresh (er) <index_name>"
   check_params $# 1 "Usage: $usage"
   print_command query-es -o POST -a "$1/_refresh"
   query-es -o POST -a "$1/_refresh"
   exit
fi
section="INDEX ENTRY MANIPULATION"
if [[ "$1 $2" == "add entry" || "$1" == "eae" ]]; then
   if [[ "$1" == "eae" ]]; then shift; else shift 2; fi
   usage="add entry (eae) <index_name> <entry_json>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o POST -a $1/_doc -j "$2"
   query-es -o POST -a $1/_doc -j "$2"
   exit
fi
section="NODES"
if [[ "$1 $2" == "list nodes" || "$1" == "eln" ]]; then
   if [[ "$1" == "eln" ]]; then shift; else shift 2; fi
   usage="list nodes (eln)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -r 1 -o GET -a "_cat/nodes?v&h=name,ip,nodeRole,m,heapPercent,ramPercent,cpu,load_1m,load_5m,load_15m,disk.total,disk.used_percent&s=name"
   query-es -r 1 -o GET -a "_cat/nodes?v&h=name,ip,nodeRole,m,heapPercent,ramPercent,cpu,load_1m,load_5m,load_15m,disk.total,disk.used_percent&s=name"
   exit
fi
if [[ "$1 $2 $3" == "list nodes queries" || "$1" == "elnq" ]]; then
   if [[ "$1" == "elnq" ]]; then shift; else shift 3; fi
   usage="list nodes queries (elnq)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -r 1 -o GET -a "_cat/nodes?v&h=name,nodeRole,search,queryTotal,searchFetchTotal,requestCacheHitCount&s=name"
   query-es -r 1 -o GET -a "_cat/nodes?v&h=name,nodeRole,search,queryTotal,searchFetchTotal,requestCacheHitCount&s=name"
   exit
fi
if [[ "$1 $2" == "search nodes" || "$1" == "esn" ]]; then
   if [[ "$1" == "esn" ]]; then shift; else shift 2; fi
   usage="search nodes (esn)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_nodes" -f "$1"
   query-es -o GET -a "_nodes" -f "$1"
   exit
fi
if [[ "$1 $2 $3" == "node active threads" || "$1" == "eat" ]]; then
   if [[ "$1" == "eat" ]]; then shift; else shift 3; fi
   usage="node active threads (eat)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cat/thread_pool?v&s=node_name,name"             -f 's/\(.*node_name.*\|.* [1-9] .*$\)/\1/;t;d'
   query-es -o GET -a "_cat/thread_pool?v&s=node_name,name"             -f 's/\(.*node_name.*\|.* [1-9] .*$\)/\1/;t;d'
   exit
fi
section="SEARCH"
if [[ "$1" == "search" || "$1" == "es" ]]; then
   if [[ "$1" == "es" ]]; then shift; else shift 1; fi
   usage="search (es) <index_name> <search_term>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o GET -a "$1/_search?q=$2&pretty"
   query-es -o GET -a "$1/_search?q=$2&pretty"
   exit
fi
if [[ "$1 $2" == "search json" || "$1" == "esj" ]]; then
   if [[ "$1" == "esj" ]]; then shift; else shift 2; fi
   usage="search json (esj) <index_name> <search_json>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o GET -a "$1/_search?pretty" -j "$2"
   query-es -o GET -a "$1/_search?pretty" -j "$2"
   exit
fi
if [[ "$1 $2" == "search match" || "$1" == "esm" ]]; then
   if [[ "$1" == "esm" ]]; then shift; else shift 2; fi
   usage="search match (esm) <index_name> <field_name> <value>"
   check_params $# 3 "Usage: $usage"
   print_command query-es -o GET -a "$1/_search?pretty" -j '{"query": { "match": { "'$2'": "'$3'" } } }'
   query-es -o GET -a "$1/_search?pretty" -j '{"query": { "match": { "'$2'": "'$3'" } } }'
   exit
fi
if [[ "$1 $2" == "search term" || "$1" == "est" ]]; then
   if [[ "$1" == "est" ]]; then shift; else shift 2; fi
   usage="search term (est) <index_name> <field_name> <value>"
   check_params $# 3 "Usage: $usage"
   print_command query-es -o GET -a "$1/_search?pretty" -j '{"query": { "term": { "'$2'": "'$3'" } } }'
   query-es -o GET -a "$1/_search?pretty" -j '{"query": { "term": { "'$2'": "'$3'" } } }'
   exit
fi
if [[ "$1 $2" == "search summary" || "$1" == "ess" ]]; then
   if [[ "$1" == "ess" ]]; then shift; else shift 2; fi
   usage="search summary (ess) <index_name> <search_term>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o GET -a "$1/_search?size=0&pretty" -j '{"aggs": {"count": {"terms": { "field" : "'$2'", "size" : 100 } } } }'
   query-es -o GET -a "$1/_search?size=0&pretty" -j '{"aggs": {"count": {"terms": { "field" : "'$2'", "size" : 100 } } } }'
   exit
fi
section="TASKS"
if [[ "$1 $2" == "list tasks" || "$1" == "elt" ]]; then
   if [[ "$1" == "elt" ]]; then shift; else shift 2; fi
   usage="list tasks (elt) [<sort_field>]"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "/_cat/tasks?v&h=action,type,start_time,timestamp,running_time,node&s=$1"             -f '/monitor\/tasks\/lists/d'
   query-es -o GET -a "/_cat/tasks?v&h=action,type,start_time,timestamp,running_time,node&s=$1"             -f '/monitor\/tasks\/lists/d'
   exit
fi
if [[ "$1 $2 $3" == "list tasks detail" || "$1" == "eltd" ]]; then
   if [[ "$1" == "eltd" ]]; then shift; else shift 3; fi
   usage="list tasks detail (eltd) [<sort_field>]"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "/_cat/tasks?v&s=$1"
   query-es -o GET -a "/_cat/tasks?v&s=$1"
   exit
fi
section="REPOS / SNAPSHOTS"
if [[ "$1 $2" == "add repo" || "$1" == "eare" ]]; then
   if [[ "$1" == "eare" ]]; then shift; else shift 2; fi
   usage="add repo (eare) <repo_name>"
   check_params $# 1 "Usage: $usage"
   print_command query-es -o PUT -a "_snapshot/$1?pretty" -j '{ "type": "fs", "settings": { "location": "'$1'" } } '
   query-es -o PUT -a "_snapshot/$1?pretty" -j '{ "type": "fs", "settings": { "location": "'$1'" } } '
   exit
fi
if [[ "$1 $2" == "delete repo" || "$1" == "edre" ]]; then
   if [[ "$1" == "edre" ]]; then shift; else shift 2; fi
   usage="delete repo (edre) <repo_name>"
   check_params $# 1 "Usage: $usage"
   print_command query-es -o DELETE -a "_snapshot/$1?pretty"
   query-es -o DELETE -a "_snapshot/$1?pretty"
   exit
fi
if [[ "$1 $2" == "list repos" || "$1" == "elre" ]]; then
   if [[ "$1" == "elre" ]]; then shift; else shift 2; fi
   usage="list repos (elre)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cat/repositories?v"
   query-es -o GET -a "_cat/repositories?v"
   exit
fi
if [[ "$1 $2" == "create snapshot" || "$1" == "ecsn" ]]; then
   if [[ "$1" == "ecsn" ]]; then shift; else shift 2; fi
   usage="create snapshot (ecsn) <repo_name> <snapshot_name>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o PUT -a "_snapshot/$1/$2?pretty"
   query-es -o PUT -a "_snapshot/$1/$2?pretty"
   exit
fi
if [[ "$1 $2" == "delete snapshot" || "$1" == "edsn" ]]; then
   if [[ "$1" == "edsn" ]]; then shift; else shift 2; fi
   usage="delete snapshot (edsn) <repo_name> <snapshot_name>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o DELETE -a "_snapshot/$1/$2?pretty"
   query-es -o DELETE -a "_snapshot/$1/$2?pretty"
   exit
fi
if [[ "$1 $2" == "list snapshots" || "$1" == "elsn" ]]; then
   if [[ "$1" == "elsn" ]]; then shift; else shift 2; fi
   usage="list snapshots (elsn)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -o GET -a "_cat/snapshots?v"
   query-es -o GET -a "_cat/snapshots?v"
   exit
fi
if [[ "$1 $2" == "snapshot details" || "$1" == "esnd" ]]; then
   if [[ "$1" == "esnd" ]]; then shift; else shift 2; fi
   usage="snapshot details (esnd) <repo_name> <snapshot_name>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o GET -a "_snapshot/$1/$2?pretty
   query-es -o GET -a "_snapshot/$1/$2?pretty
   exit
fi
if [[ "$1 $2" == "restore snaphot" || "$1" == "ersn" ]]; then
   if [[ "$1" == "ersn" ]]; then shift; else shift 2; fi
   usage="restore snaphot (ersn) <repo_name> <snapshot_name>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o POST -a "_snapshot/$1/$2/_restore?pretty"
   query-es -o POST -a "_snapshot/$1/$2/_restore?pretty"
   exit
fi
section="GENERIC"
if [[ "$1" == "generic" || "$1" == "eg" ]]; then
   if [[ "$1" == "eg" ]]; then shift; else shift 1; fi
   usage="generic (eg) <type-GET/POST/PUT> <api_call>"
   check_params $# 2 "Usage: $usage"
   print_command query-es -o $1 -a "$2"
   query-es -o $1 -a "$2"
   exit
fi
if [[ "$1 $2" == "query-es settings" || "$1" == "eqes" ]]; then
   if [[ "$1" == "eqes" ]]; then shift; else shift 2; fi
   usage="query-es settings (eqes)"
   check_params $# 0 "Usage: $usage"
   print_command query-es -s
   query-es -s
   exit
fi
section="HELP"
if [[ "$1" == "help" || "$1" == "ehe" ]]; then
   if [[ "$1" == "ehe" ]]; then shift; else shift 1; fi
   usage="help (ehe)"
   check_params $# 0 "Usage: $usage"
   egrep "usage=|section=" $0 | grep -v "grep" | sed "s/.*usage=/   /; s/.*section=//; s/\"//g"
   exit
fi

if [[ "$1" == "" ]]; then
  echo "No option passed"
else
  echo "$*: invalid option"
fi
echo "Try \"es help\" for more information."

