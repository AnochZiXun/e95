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
			<LINK href="http://fonts.googleapis.com/earlyaccess/cwtexyen.css" rel="stylesheet" media="all" type="text/css"/>
			<LINK href="/STYLE/font-awesome.min.css" rel="stylesheet" media="all" type="text/css"/>
			<LINK href="/STYLE/common.css" rel="stylesheet" media="all" type="text/css"/>
			<LINK href="/STYLE/feedback.css" rel="stylesheet" media="all" type="text/css"/>
			<SCRIPT src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"/>
			<SCRIPT src="/SCRIPT/gcse.js"/>
			<TITLE>e95 易購物商城 &#187; 意見反應</TITLE>
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
									<IMG alt="" src="/IMG/announcements.png"/>
								</ASIDE>
								<DIV>
									<FORM action="{@requestURI}" method="POST">
										<H1 id="announcements">e95 購物網站意見反應</H1>
										<TABLE id="feedback">
											<xsl:if test="errorMessage">
												<CAPTION>
													<xsl:value-of select="errorMessage"/>
												</CAPTION>
											</xsl:if>
											<TBODY>
												<TR>
													<TH>
														<LABEL for="fullname">姓名</LABEL>
													</TH>
													<TD>
														<INPUT id="fullname" name="fullname" type="text"/>
													</TD>
												</TR>
												<TR>
													<TH>
														<LABEL for="email">電子郵件</LABEL>
													</TH>
													<TD>
														<INPUT id="email" name="email" type="text"/>
													</TD>
												</TR>
												<TR>
													<TH>
														<LABEL for="number">連絡電話</LABEL>
													</TH>
													<TD>
														<INPUT id="number" name="number" type="text"/>
													</TD>
												</TR>
												<TR>
													<TH class="must">
														<LABEL for="content">意見內容</LABEL>
													</TH>
													<TD>
														<TEXTAREA id="content" cols="1" name="content" required="" rows="1"/>
													</TD>
												</TR>
												<TR>
													<TD colspan="2">
														<INPUT type="reset" value="取消重填"/>
														<INPUT type="submit" value="確定送出"/>
													</TD>
												</TR>
											</TBODY>
										</TABLE>
									</FORM>
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