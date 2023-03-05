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
		<TABLE>
			<CAPTION>意見反應</CAPTION>
			<TBODY>
				<xsl:if test="fullname">
					<TR>
						<TH style="text-align:right">姓名：</TH>
						<TD style="text-align:left">
							<xsl:value-of select="fullname"/>
						</TD>
					</TR>
				</xsl:if>
				<xsl:if test="email">
					<TR>
						<TH style="text-align:right">電子郵件：</TH>
						<TD style="text-align:left">
							<xsl:value-of select="email"/>
						</TD>
					</TR>
				</xsl:if>
				<xsl:if test="number">
					<TR>
						<TH style="text-align:right">連絡電話：</TH>
						<TD style="text-align:left">
							<xsl:value-of select="number"/>
						</TD>
					</TR>
				</xsl:if>
				<TR>
					<TH style="text-align:right">意見內容：</TH>
					<TD style="text-align:left">
						<TEXTAREA style="width:480px;height:320px" cols="1" rows="1">
							<xsl:value-of select="content"/>
						</TEXTAREA>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
	</xsl:template>

</xsl:stylesheet>