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
			<xsl:value-of select="name"/>
			<SPAN>，您好：</SPAN>
		</P>
		<P>請至 <A href="http://www.e95.com.tw/reset.asp?code={code}" target="_blank">http://www.e95.com.tw/reset.asp?code=<xsl:value-of select="code"/></A> 重設密碼，謝謝。</P>
	</xsl:template>

</xsl:stylesheet>