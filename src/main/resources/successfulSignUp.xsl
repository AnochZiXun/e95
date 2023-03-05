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
			<xsl:value-of select="lastname"/>
			<xsl:value-of select="firstname"/>
			<xsl:choose>
				<xsl:when test="gender='false'">小姐</xsl:when>
				<xsl:otherwise>先生</xsl:otherwise>
			</xsl:choose>
			<SPAN>，您好：</SPAN>
		</P>
		<P>歡迎您加入 e95 易購物網站會員；以下是您的註冊資訊，請查核確認，謝謝。</P>
		<OL>
			<LI>
				<SPAN>註冊帳號：</SPAN>
				<B style="font-family:monospace">
					<xsl:value-of select="email"/>
				</B>
			</LI>
			<LI>
				<SPAN>註冊密碼：</SPAN>
				<B style="font-family:monospace">
					<xsl:value-of select="shadow"/>
				</B>
			</LI>
			<LI>
				<SPAN>登入網址：</SPAN>
				<B style="font-family:monospace">http://www.e95.com.tw/logIn.asp</B>
			</LI>
		</OL>
		<P>歡迎您的加入！</P>
	</xsl:template>

</xsl:stylesheet>