<?xml version="1.0" encoding="UTF-8"?>
<!-- Template to make the iso8601 date -->
<<<<<<< HEAD
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:java="http://xml.apache.org/xalan/java">

  <xsl:template name="get_ISO8601_date">
    <xsl:param name="date"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>

    <xsl:variable name="conf">
      <xsl:value-of select="java:ca.discoverygarden.gsearch_extensions.JodaAdapter.addDateParser(2, 'yyyy')"/>
      <xsl:value-of select="java:ca.discoverygarden.gsearch_extensions.JodaAdapter.addDateParser(3, 'yyyy-MM')"/>
      <xsl:value-of select="java:ca.discoverygarden.gsearch_extensions.JodaAdapter.addDateParser(4, 'yyyy-MM-dd')"/>
    </xsl:variable>

    <xsl:variable name="initial">
      <xsl:value-of select="java:ca.discoverygarden.gsearch_extensions.JodaAdapter.transformForSolr($date, $pid, $datastream)"/>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="$initial">
            <xsl:value-of select="$initial"/>
        </xsl:when>
        <xsl:when test="contains($date, '/')">
            <xsl:value-of select="java:ca.discoverygarden.gsearch_extensions.JodaAdapter.transformForSolr(substring-bebfore($date, '/') , $pid, $datastream)"/>
        </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
