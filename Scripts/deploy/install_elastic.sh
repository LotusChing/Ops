#!/bin/bash
Basedir="/usr/local/"
elastic_dir="/usr/local/elasticsearch"

Install(){
    cd $Basedir/src && wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.3.tar.gz
    tar xf elasticsearch-1.7.3.tar.gz -C /usr/local/
    ln -s /usr/local/elasticsearch-1.7.3 /usr/local/elasticsearch
    cd /tmp && git clone https://github.com/elastic/elasticsearch-servicewrapper
    cd elasticsearch-servicewrapper/ && mv service /usr/local/elasticsearch/bin/
    echo "Install OK..."
}

Config(){
    mkdir -p /usr/local/elasticsearch/{plugins,logs,es-data,es-work}
    cd /usr/local/elasticsearch/config/
    # Configuration ElasticSearch
    sed -r -i '32c cluster.name\: LotusChing' elasticsearch.yml
    sed -r -i "40c node.name\: "\"$HOSTNAME\""" elasticsearch.yml
    sed -r -i '47c node.master\: true' elasticsearch.yml
    sed -r -i '51c node.data\: true' elasticsearch.yml
    sed -r -i '107c index.number_of_shards: 5' elasticsearch.yml
    sed -r -i '111c index.number_of_replicas: 1' elasticsearch.yml
    sed -r -i '145c path.conf: /usr/local/elasticsearch/config' elasticsearch.yml
    sed -r -i '149c path.data: /usr/local/elasticsearch/es-data' elasticsearch.yml
    sed -r -i '159c path.work: /usr/local/elasticsearch/es-work' elasticsearch.yml
    sed -r -i '163c path.logs: /usr/local/elasticsearch/logs' elasticsearch.yml
    sed -r -i '167c path.plugins: /usr/local/elasticsearch/plugins' elasticsearch.yml
    sed -r -i s'/#bootstrap.mlockall\: true/bootstrap.mlockall\: true/'g elasticsearch.yml
    # Configuration JVM
    sed -r -i '1c set.default.ES_HOME=/usr/local/elasticsearch' $elastic_dir/bin/service/elasticsearch.conf
    sed -r -i '2c set.default.ES_HEAP_SIZE=256' $elastic_dir/bin/service/elasticsearch.conf
    cd  $elastic_dir/bin/service && ./elasticsearch install
    echo "Configuration OK..."
    echo "Please use: service elasticsearch start"
}

Plugins(){
    /usr/local/elasticsearch/bin/plugin -i elasticsearch/marvel/latest


}

Install
Config
