<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:mods="http://www.loc.gov/mods/v3" exclude-result-prefixes="mods">
  <xsl:include
    href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/config/index/gsearch_solr/islandora_transforms/library/xslt-date-template.xslt"/>

  <xsl:variable name="PID" select="/foxml:digitalObject/@PID"/>
  <xsl:variable name="modsPrefix">mods_</xsl:variable>
  <xsl:variable name="modsSuffix">_ms</xsl:variable>

  <!--
    SECTION 1:

    Our root MODS processing template; this is where we split out specific MODS
    collections that need special metadata field templates. Not all collections
    will need this; if they don't, the generic stuff below takes care of them.
    
    Collections being given special treatment in here should also have templates
    in the second and third sections below.
  -->

  <xsl:template match="foxml:datastream[@ID='MODS']/foxml:datastreamVersion[last()]"
    name="index_MODS">
    <xsl:param name="content"/>

    <!-- xslt 1.0 doesn't allow use of multiple modes; we need wrapper code -->
    <xsl:for-each select="$content/mods:mods/mods:*">
      <xsl:choose>
        <xsl:when
          test="starts-with($PID, 'edu.ucla.library.specialCollections.losAngelesDailyNews')
          | starts-with($PID, 'edu.ucla.library.universityArchives.historicPhotographs')">
          <xsl:apply-templates select="self::mods:*" mode="CollectingLA"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- we get the generic treatment -->
          <xsl:apply-templates select="self::mods:*"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!--
   SECTION 2:

   Below this are processing templates used by collections that have special
   metadata processing needs.
  -->

  <!-- We pull out cla topics for the visualization index -->
  <xsl:template match="mods:subject[@authority='cla_topic']" mode="CollectingLA">
    <!-- cla_topic_mt field is created automatically from submitted _ms one -->
    <field name="cla_topic_ms">
      <xsl:value-of select="mods:topic"/>
    </field>
  </xsl:template>

  <!--
    SECTION 3:
    
    Below this are collection level mode switches (needed b/c we use xslt 1.0).
    These basically handle the non-special fields in a collection that is being
    given special treatment...  It switches them to use the generic templates.
  -->

  <xsl:template match="mods:*" mode="CollectingLA">
    <xsl:apply-templates select="self::mods:*"/>
  </xsl:template>

  <!--
    SECTION 4:

    Below this are generic (non-collection specific) field processing templates.
    Changing these changes the default processing for all MODS collections.
  -->

  <!-- Generic non-date fields -->
  <xsl:template
    match="mods:*[not(@type='date')][not(contains(translate(local-name(), 'D', 'd'), 'date')) or (self::mods:dateCreated)][normalize-space(text())]">
    <field>
      <xsl:attribute name="name">
        <xsl:choose>
          <xsl:when test="../@type">
            <xsl:value-of select="concat($modsPrefix, local-name(), '_', ../@type, $modsSuffix)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($modsPrefix, local-name(), $modsSuffix)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="text()"/>
    </field>
  </xsl:template>

  <!-- Generic date fields -->
  <xsl:template
    match="mods:*[(@type='date') or (contains(translate(local-name(), 'D', 'd'), 'date'))][not(self::mods:dateCreated)][normalize-space(text())]">
    <xsl:variable name="textValue">
      <xsl:call-template name="get_ISO8601_date">
        <xsl:with-param name="date" select="normalize-space(text())"/>
      </xsl:call-template>
    </xsl:variable>

    <field>
      <xsl:attribute name="name">
        <xsl:choose>
          <xsl:when test="@point">
            <xsl:value-of select="concat($modsPrefix, local-name(), '_', @point, '_dt')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($modsPrefix, local-name(), '_dt')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="$textValue"/>
    </field>
  </xsl:template>

</xsl:stylesheet>
