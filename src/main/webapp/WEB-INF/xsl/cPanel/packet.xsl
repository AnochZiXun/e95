<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output
		method="html"
		encoding="UTF-8"
		omit-xml-declaration="yes"
		indent="no"
		media-type="text/html"
	/>

	<xsl:import href="/cPanel/import.xsl"/>

	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes">&#60;!DOCTYPE HTML&#62;</xsl:text>
		<HTML dir="ltr" lang="zh-TW">
			<xsl:apply-templates/>
		</HTML>
	</xsl:template>

	<xsl:template match="document">
		<HEAD>
			<META charset="UTF-8"/>
			<META name="viewport" content="width=device-width, initial-scale=1.0"/>
			<LINK href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/dark-hive/jquery-ui.css" rel="stylesheet" media="all" type="text/css"/>
			<LINK href="/STYLE/font-awesome.min.css" rel="stylesheet" media="all" type="text/css"/>
			<LINK href="/STYLE/cPanel.css" rel="stylesheet" media="all" type="text/css"/>
			<SCRIPT src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"/>
			<SCRIPT src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"/>
			<SCRIPT src="/SCRIPT/cPanel.js"/>
			<TITLE>控制臺 &#187; 訂單明細</TITLE>
		</HEAD>
		<xsl:comment>
			<xsl:value-of select="system-property('xsl:version')"/>
		</xsl:comment>
		<BODY>
			<TABLE id="cPanel">
				<TBODY>
					<TR>
						<TD>
							<xsl:apply-templates select="aside"/>
						</TD>
						<TD>
							<TABLE class="list">
								<CAPTION class="textAlignLeft">
									<P>
										<SPAN>收件人：</SPAN>
										<xsl:value-of select="packet/recipient"/>
									</P>
									<P>
										<SPAN>聯絡電話：</SPAN>
										<xsl:value-of select="packet/phone"/>
									</P>
									<P>
										<SPAN>運送地址：</SPAN>
										<xsl:value-of select="packet/address"/>
									</P>
									<P>
										<SPAN>交易編號：</SPAN>
										<SPAN class="monospace">
											<xsl:value-of select="packet/merchantTradeNo"/>
										</SPAN>
									</P>
									<P>
										<SPAN>交易時間：</SPAN>
										<SPAN class="monospace">
											<xsl:value-of select="packet/merchantTradeDate"/>
										</SPAN>
									</P>
									<P>
										<SPAN>交易金額：</SPAN>
										<SPAN class="monospace textAlignRite">
											<xsl:value-of select="format-number(packet/totalAmount,'###,###')"/>
										</SPAN>
									</P>
								</CAPTION>
								<THEAD>
									<TR>
										<TH>商品名稱</TH>
										<TH>規格</TH>
										<TH>數量</TH>
									</TR>
								</THEAD>
								<TBODY>
									<xsl:for-each select="list/row">
										<TR>
											<xsl:if test="position()mod'2'='0'">
												<xsl:attribute name="class">even</xsl:attribute>
											</xsl:if>
											<TD>
												<xsl:value-of select="merchandiseName"/>
											</TD>
											<TD>
												<xsl:value-of select="merchandiseSpecification"/>
											</TD>
											<TD class="monospace textAlignCenter">
												<xsl:value-of select="quantity"/>
											</TD>
										</TR>
									</xsl:for-each>
								</TBODY>
							</TABLE>
						</TD>
					</TR>
				</TBODY>
			</TABLE>
			<HEADER class="cF">
				<DIV class="fL">
					<A href="/cPanel/">控制臺首頁</A>
					<SPAN>&#187;</SPAN>
					<A>
						<xsl:value-of select="@breadcrumb"/>
					</A>
				</DIV>
				<xsl:call-template name="topRite"/>
			</HEADER>
		</BODY>
	</xsl:template>

</xsl:stylesheet>