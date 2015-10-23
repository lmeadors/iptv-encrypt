<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>

	<xsl:template match="/">
		<xsl:for-each select="/ADI/Asset/Asset/Metadata/AMS[@Asset_Class='movie']">
			<xsl:value-of select="../../Content/@Value"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
