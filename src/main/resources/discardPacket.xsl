<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output
		method="html"
		encoding="UTF-8"
		omit-xml-declaration="yes"
		indent="no"
		media-type="text/html"
	/>

	<xsl:template match="document">
		<P>
			<SPAN>親愛的顧客&#160;</SPAN>
			<SPAN>
				<xsl:value-of select="regular"/>
			</SPAN>
			<SPAN>，您好：</SPAN>
		</P>
		<P>
			<SPAN>很抱歉，您的訂單(&#35;<xsl:value-of select="packet"/>)已被取消，若有任何交易上的疑問，請和</SPAN>
			<A href="mailto:{booth/@email}">
				<xsl:value-of select="booth"/>
			</A>
			<SPAN>連繫，謝謝您再次觀臨「e95 易購物網站」購物。</SPAN>
		</P>
		<P>祝 順安</P>
		<P>易購物商城 敬上</P>
	</xsl:template>

</xsl:stylesheet>