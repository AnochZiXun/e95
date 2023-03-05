<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output
		method="html"
		encoding="UTF-8"
		omit-xml-declaration="yes"
		indent="no"
		media-type="text/html"
	/>

	<xsl:import href="/import.xsl"/>
	<xsl:import href="/cPanel/import.xsl"/>

	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes">&#60;!DOCTYPE HTML&#62;</xsl:text>
		<HTML dir="ltr" lang="zh-TW">
			<xsl:apply-templates/>
		</HTML>
	</xsl:template>

	<xsl:template match="document">
		<HEAD>
			<META name="viewport" content="width=device-width, initial-scale=1.0"/>
			<LINK href="http://fonts.googleapis.com/earlyaccess/cwtexyen.css" rel="stylesheet" media="all" type="text/css"/>
			<LINK href="/STYLE/font-awesome.min.css" rel="stylesheet" media="all" type="text/css"/>
			<LINK href="/STYLE/common.css" rel="stylesheet" media="all" type="text/css"/>
			<LINK href="/STYLE/mofo.css" rel="stylesheet" media="all" type="text/css"/>
			<SCRIPT src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"/>
			<SCRIPT src="/SCRIPT/mofo.js"/>
			<SCRIPT src="/SCRIPT/gcse.js"/>
			<TITLE>e95 易購物商城 &#187; <xsl:value-of select="@title" disable-output-escaping="yes"/></TITLE>
		</HEAD>
		<xsl:comment>
			<xsl:value-of select="system-property('xsl:version')"/>
		</xsl:comment>
		<BODY>
			<DIV>
				<DIV>
					<HEADER>
						<DIV>
							<xsl:call-template name="header"/>
						</DIV>
					</HEADER>
				</DIV>
				<DIV>
					<DIV>
						<NAV>
							<xsl:call-template name="navigator"/>
							<DIV class="cF">
								<ASIDE>
									<A style="color:#FFF;background-color:#499BC9" href="/mofo/food/">
										<B class="fa fa-cutlery">&#160;</B>
										<SPAN>食</SPAN>
									</A>
									<A style="color:#FFF;background-color:#6EC038" href="/mofo/clothing/">
										<B class="fa fa-user">&#160;</B>
										<SPAN>衣</SPAN>
									</A>
									<A style="color:#FFF;background-color:#F1D130" href="/mofo/shelter/">
										<B class="fa fa-home">&#160;</B>
										<SPAN>住</SPAN>
									</A>
									<A style="color:#FFF;background-color:#FF2D21" href="/mofo/travel/">
										<B class="fa fa-automobile">&#160;</B>
										<SPAN>行</SPAN>
									</A>
									<A style="color:#FFF;background-color:#6C2085" href="/mofo/education/">
										<B class="fa fa-pencil">&#160;</B>
										<SPAN>育</SPAN>
									</A>
									<A style="color:#FFF;background-color:#EC9F2E" href="/mofo/entertainment/">
										<B class="fa fa-television">&#160;</B>
										<SPAN>樂</SPAN>
									</A>
									<A style="color:#FFF;background-color:#D17F15" href="/mofo/others/">
										<B class="fa fa-navicon">&#160;</B>
										<SPAN>其它</SPAN>
									</A>
								</ASIDE>
								<DIV>
									<H1 id="mofoName">
										<xsl:attribute name="style">
											<xsl:choose>
												<xsl:when test="list/@id='1'">color:#FFF;background-color:#499BC9</xsl:when>
												<xsl:when test="list/@id='2'">color:#FFF;background-color:#6EC038</xsl:when>
												<xsl:when test="list/@id='3'">color:#FFF;background-color:#F1D130</xsl:when>
												<xsl:when test="list/@id='4'">color:#FFF;background-color:#FF2D21</xsl:when>
												<xsl:when test="list/@id='5'">color:#FFF;background-color:#6C2085</xsl:when>
												<xsl:when test="list/@id='6'">color:#FFF;background-color:#EC9F2E</xsl:when>
												<xsl:otherwise>color:#FFF;background-color:#D17F15</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<SPAN>店家分類：<xsl:value-of select="pagination/@mofoName"/></SPAN>
									</H1>
									<P>
										<FORM class="textAlignCenter" id="pagination" action="{@requestURI}">
											<xsl:apply-templates select="pagination"/>
										</FORM>
									</P>
									<UL class="cF" id="mofo">
										<xsl:for-each select="list/*">
											<LI>
												<A href="/store/{@id}/">
													<xsl:value-of select="."/>
												</A>
											</LI>
										</xsl:for-each>
									</UL>
								</DIV>
							</DIV>
							<xsl:call-template name="footer"/>
						</NAV>
					</DIV>
				</DIV>
			</DIV>
		</BODY>
	</xsl:template>

</xsl:stylesheet>