<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="urn:mpeg:DASH:schema:MPD:2011">
	<xsl:param name="base_url"/>
	<xsl:output method="text"/>

	<xsl:template match="/">
		<xsl:for-each select="d:MPD/d:Period/d:AdaptationSet/d:Representation">
			<xsl:value-of select="$base_url"/>
			<xsl:value-of select="d:BaseURL"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
