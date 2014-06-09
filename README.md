# UCLA GSearch Config

This repo will holds a basic solr config, schema and xslt to use as a starting point for future projects. It requires the [Joda library](http://sourceforge.net/projects/joda-time/files/joda-time/) deployed to gsearch's `lib` directory.

## Installation

This repo should be cloned such that the subfolder `gsearch_solr` ends up in the GSearch `index` directory... So `$CATALINA_HOME/webapps/fedoragsearch/WEB-INF/classes/config/index` contains `gsearch_solr`.

Additionally, the directory `gsearch_solr/conf` contains the Solr configuration files, which can/should be symlinked to from the solr.home directory (in many installations, this ends up being something like `/usr/local/fedora/gsearch_solr/solr` (alongside the Solr's `data` directory)).
