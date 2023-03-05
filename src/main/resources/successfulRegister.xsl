<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output
		method="html"
		encoding="UTF-8"
		omit-xml-declaration="yes"
		indent="no"
		media-type="text/html"
	/>

	<xsl:template match="form">
		<P>
			<xsl:value-of select="name"/>
			<SPAN>，您好：</SPAN>
		</P>
		<P>歡迎您加入 e95 易購物網站店家；以下是您的註冊資訊，請查核確認，謝謝。</P>
		<OL>
			<LI>註冊帳號：<xsl:value-of select="login"/></LI>
			<LI>註冊密碼：<xsl:value-of select="shadow"/></LI>
			<LI>登入網址：http://www.e95.com.tw/cPanel/</LI>
		</OL>
		<P>歡迎您的加入！</P>
	</xsl:template>

</xsl:stylesheet>