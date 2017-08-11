# Solr config upgrade tool

Despite widespread enterprise adoption, Solr lacks automated upgrade tooling. It has long been a challenge for users to understand the implications of a Solr upgrade. Users must manually review the Solr release notes to identify configuration changes either to fix backwards incompatibilities or to utilize latest features in the new version. Additionally, users must identify a way to migrate existing index data to the new version (either via an index upgrade or re-indexing the raw data).

Solr config upgrade tool aims to simplify the upgrade process by providing upgrade instructions tailored to your configuration. These instuctions can help you to answer following questions

- Does my Solr configuration have any backwards incompatible sections? If yes which ones?
- For each of the incompatibility - what do I need to do to fix this incompatibility? Where can I get more information about why this incompatibility was introduced (e.g. references to Lucene/Solr jiras)?
- Are there any changes in Lucene/Solr which would require me to do a full reindexing OR can I get away with an index upgrade?

 ## High level design
 
This tool is built using [Extensible Stylesheet Language Transformations](https://en.wikipedia.org/wiki/XSLT) engine. The upgrade rules, implemented in the form of XSLT transformations, can identify backwards incompatibilities and in some cases can even fix them automatically.
 
 In general, an incompatibility can be categorized as follows,
 - An incompatibility due to removal of Lucene/Solr configuration element (e.g. a field type) is marked as ERROR in the validation result. Typically this will result in failure to start the Solr server (or load the core). User must make changes to Solr configuration using application specific knowledge to fix such incompatibility.
 - An incompatibility due to deprecation of a configuration section in the new Solr version is marked as WARNING in the validation result. Typically this will not result in any failure during Solr server startup (or core loading), but may prevent application from utilizing new Lucene/Solr features (or bug-fixes). User may choose to make changes to Solr configuration using application specific knowledge to fix such incompatibility.
 - An incompatibility which can be fixed automatically (e.g. by rewriting the Solr configuration section) and do not require any manual intervention is marked as INFO in the validation result. This also includes incompatibilities in the underlying Lucene implementation (e.g. [LUCENE-6058](https://issues.apache.org/jira/browse/LUCENE-6058)) which would require rebuilding the index (instead of index upgrade). Typically such incompatibility will not result in failure during Solr server startup (or core loading), but may affect the accuracy of the query results or consistency of underlying indexed data.

## Steps to run this tool

- Build this project using maven (mvn clean install)
- Run the config upgrade tool as follows
```bash
./bin/config_upgrade.sh --help
usage: ConfigUpgradeTool
 -t <arg>       This parameter specifies the type of Solr configuration to
                be validated and transformed.The tool currently supports
                schema.xml, solrconfig.xml and solr.xml
    --help      This command will print the help message for the Solr
                config upgrade related commands.
    --dry-run   This command will perform compatibility checks for the
                specified Solr config file.
 -c <arg>       This parameter specifies the path of Solr configuration to
                be upgraded.
 -u <arg>       This parameter specifies the path of the file providing
                Solr upgrade processor configurations.
 -d <arg>       This parameter specifies the directory path where
                tansformed Solr configuration should be stored.
 -v             This parameter enables printing XSLT compiler warnings on
                the command output.
```

e.g. following command runs the upgrade tool on a Solr schema.xml of version 4.x to identify incomatibilities before upgrade to Solr 5

```bash
./bin/config_upgrade.sh -t schema -c src/test/resources/bad_config/solr4/schema.xml -u validators/solr_4_to_5_processors.xml -d /tmp
Validating schema...

Following configuration errors found:
      
      * Legacy field type (name = pint and class = solr.IntField) is removed.
      * Legacy field type (name = plong and class = solr.LongField) is removed.
      * Legacy field type (name = pfloat and class = solr.FloatField) is removed.
      * Legacy field type (name = pdouble and class = solr.DoubleField) is removed.
      * Legacy field type (name = pdate and class = solr.DateField) is removed.
      * Legacy field type (name = sint and class = solr.SortableIntField) is removed.

No configuration warnings found...

Please note that in Solr 5:
    * Users of the BeiderMorseFilterFactory will need to rebuild their indexes after upgrading

Solr schema validation failed. Please review /tmp/schema_validation.xml for more details. 
```
 
## TODO
- Add logic to handle the Solr config set (which includes overlay configurations) as well as solr.xml
- Add upgrade rules to identify plugin deprecations (and removals)
- Add rules for Solr 6 -> Solr 7 upgrade

