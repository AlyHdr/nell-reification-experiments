# Internship Reification in Semantic Web 2019 

In this readme a documentation of the tests is presented with examples on the command line tools and the bash scripts used.
## Triple Stores (SPARQL engines)

On the cluster machine there is a directory "/home_expes/database-servers/" where all the triple stores are installed with their configurations and the hieracrhy of the work is to submit jobs and get the results in a redirected output with name "slurm-pidOfProcess.out" or add `-o "out_file_name"` to the command with sbatch:

* **Virtuoso** To launch virtuoso run the command: `sbatch -p LONG  --mem=64G -c 2 -J 'virtuoso' -w calcul-bigcpu-lahc-1 --wrap='cd /home_expes/database-servers/virtuoso-new/var/lib/virtuoso/db/ && /home_expes/database-servers/virtuoso-new/bin/virtuoso-t -f'` , and there is initialization file "virtuoso.ini" of virtuoso where we can tune parameters (memory size,buffer size  ..)  in the directory "/home_expes/database-servers/virtuoso/var/lib/virtuoso/db/".
* **Blazegraph** To launch blazegraph run the command: `sbatch -p LONG  --mem=64G -c 2 -J 'blazegraph' -w calcul-bigcpu-lahc-1 --wrap='cd /home_expes/database-servers/blazegraph && /usr/lib/jvm/java-8-openjdk-amd64/bin/java -server -Xmx64g -jar blazegraph.jar'`.
* **GraphDB** To launch virtuoso run the command: `sbatch -p LONG  --mem=64G -c 2 -J 'graphDB' -w calcul-bigcpu-lahc-1 --wrap='export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/" && /home_expes/database-servers/GraphDB/graphdb-free-8.8.1/bin/graphdb -s -Xmx64g'`.
* **Fuseki-Jena** To launch virtuoso run the command: `sbatch -p LONG  --mem=64G -c 2 -J 'fuseki' -w calcul-bigcpu-lahc-1 --wrap='cd /home_expes/database-servers/apache-jena-fuseki-3.10.0/ && /home_expes/database-servers/apache-jena-fuseki-3.10.0/fuseki-server'`, and there is the java configuration in this script `fuseki-server` where the amount of memory occupied by java could be changed `JVM_ARGS=${JVM_ARGS:--Xmx64g} on line 81`.

## Data Loading

The data is in the directory `/home_expes/database-servers/data/` where there is a file called `nell.shuf.csv`, this file basically contains the dump from nell of candidate and prompted beliefs which have been already shuffled using the command `shuf /home_expes/database-servers/data/nell.csv /home_expes/database-servers/data/nell.shuf.csv` and this command loads all the file in memory and shuffle it.

* After shuflling generate the data using Nell Converter example: 

`sbatch -p LONG -c 2 --mem=32G -J 'c_nd' -w calcul-bigcpu-lahc-1 --wrap='cd ~/nell2rdf/target && java -jar NellConverter-0.3.jar N-TRIPLE ndfluents /home_expes/database-servers/data/NELL.08m.1100.ontology.csv /home_expes/database-servers/data/dump.ttl /home_expes/database-servers/data/half_data/nell.half.csv /home_expes/database-servers/data/half_data/nell.half.nd.nt'`

* Remove the duplicates using `sbatch -p LONG  --mem=64G -c 2 -J 'dups' -w calcul-bigcpu-lahc-1 --wrap='export TMPDIR=/home_expes/database-servers/temp && sort /home_expes/database-servers/data/half_data/nell.half.nd.nt | uniq -u > /home_expes/database-servers/data/half_data/nell.half.u.nd.nt'`

Load data to triple stores:
* **Virtuoso** to load to virtuoso we configure the loader with the deisred directory and the file but first open a bash terminal on the machine `srun -c1 --mem=1G -w calcul-bigcpu-lahc-1 -t 3:00:00 --pty bash -i` and then run the command `/home_expes/database-servers/virtuoso-new/bin/isql 1111 dba dba exec="ld_dir ('/home_expes/database-servers/data/half_data/','nell.half.u.nq','half.nq');"`, first parameter to ld_dir is directory where the file is second is the file name and the third is the name of the default graph (can be anything).Then we can start loading using the command `sbatch -p LONG  --mem=1G -J 'virtuoso' -w calcul-bigcpu-lahc-1 --wrap='/home_expes/database-servers/virtuoso-new/bin/isql 1111 dba dba exec="rdf_loader_run();"'` and it's important to run this command also after the loading phase is finished `sbatch -p LONG  --mem=1G -J 'virtuoso' -w calcul-bigcpu-lahc-1 --wrap='/home_expes/database-servers/virtuoso-new/bin/isql 1111 dba dba exec="checkpoint"'` other wise the triple store will not **store** the data when it is shut down.

* **Blazegraph** to load to blazegraph there is a property file `/home_expes/database-servers/blazegraph/props` where there is a line `com.bigdata.rdf.store.AbstractTripleStore.quads=true` that should be commented when loading triples.The command to launch the loading is `sbatch -p LONG  --mem=64G -J 'l_blazegraph' -w calcul-bigcpu-lahc-1 --wrap='cd /home_expes/database-servers/blazegraph && /usr/lib/jvm/java-8-openjdk-amd64/bin/java -cp blazegraph.jar com.bigdata.rdf.store.DataLoader -namespace nell props /home_expes/database-servers/data/full_data/NELL2RDF_0.3_1100_reif.nt'` , and when loading quads uncomment the line with quads in `props` file and launch the command `sbatch -p LONG  --mem=64G -c 2 -J 'l_blazegraph' -w calcul-bigcpu-lahc-1 --wrap='cd /home_expes/database-servers/blazegraph && java -cp blazegraph.jar com.bigdata.rdf.store.DataLoader -defaultGraph http://nell.org props /home_expes/database-servers/data/NELL2RDF_0.3_1100.nq'`

* **GraphDB** A repository should be initiated on the engine where its configuration file `/home_expes/ha07131t/scripts/repo-config.ttl` should be attached to the command `sbatch -p LONG  --mem=64G -c 2 -J 'l_graphDB' -w calcul-bigcpu-lahc-1 --wrap='export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/" && /home_expes/database-servers/GraphDB/graphdb-free-8.8.1/bin/loadrdf --force -c ~/scripts/repo-config.ttl -m parallel /home_expes/database-servers/data/nell.half.u.nq'` and '--force' is not mandatory in case there is no repository with the same configuration in the engine.
* **Fuseki-Jena** to load huge data and load them to disk we use `tdbloader` but before launing it there is a configuration file `/home_expes/database-servers/apache-jena-fuseki-3.10.0/run/configuration/config.ttl` where we define the properties of the database with (location,query timeout..) and then the command `sbatch -p LONG  --mem=64G -c 2 -J 'l_jena' -w calcul-bigcpu-lahc-1 --wrap='export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/" && /home_expes/database-servers/apache-jena-3.10.0/bin/tdbloader -- loc /home_expes/database-servers/Jena_half_nq/ /home_expes/database-servers/data/half_data/nell.half.u.nq'` to start the loader.

## Query tests

All the translated queries are in `/home_expes/ha07131t/queries` so to run a query on a triple store there is 4 scripts in `/home_expes/ha07131t/queries` 'run_virtuoso.sh','run_blazegraph.sh','run_graphDB.sh' and 'run_jena.sh' example to run a query : `./run_virtuoso.sh ~/queries/query_1_reif` (not to forget to launch the engine before).

There is also a script `run_seq.sh` which basically accepts two arguments **queries folder** and **script name** to run all the queries after each other example: `./run_seq.sh ~/queries run_virtuoso.sh`.

Some of the results while testing has been saved in the directory `/home_expes/ha07131t/queries_results` and there is a google sheet https://docs.google.com/spreadsheets/d/15zF50kP7T42FYzx3oUAxDDatgBGVvS_C6jaMRVUTf2A/edit#gid=285272082 .

