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
			<!--<STYLE><![CDATA[TABLE.form A.fa{line-height:24px;font-size:140%;text-decoration:none}]]></STYLE>-->
			<SCRIPT src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"/>
			<SCRIPT src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"/>
			<SCRIPT src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/i18n/jquery-ui-i18n.min.js"/>
			<SCRIPT src="/SCRIPT/cPanel.js"/>
			<TITLE>控制臺 &#187; 新增店家</TITLE>
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
							<FORM action="{form/@action}" method="POST">
								<FIELDSET>
									<LEGEND>
										<xsl:value-of select="form/@legend"/>
									</LEGEND>
									<TABLE class="form">
										<xsl:if test="form/@error">
											<CAPTION>
												<xsl:value-of select="form/@error"/>
											</CAPTION>
										</xsl:if>
										<TR>
											<TH class="must">
												<LABEL for="login">店家帳號</LABEL>
											</TH>
											<TD>
												<INPUT id="login" name="login" required="" type="text" value="{form/login}"/>
											</TD>
											<TD>必填。</TD>
										</TR>
										<TR>
											<TH class="must">
												<LABEL for="shadow">店家密碼</LABEL>
											</TH>
											<TD>
												<INPUT id="shadow" name="shadow" required="" type="password"/>
											</TD>
											<TD>必填。</TD>
										</TR>
										<TR>
											<TH class="must">
												<LABEL for="name">店家抬頭</LABEL>
											</TH>
											<TD>
												<INPUT id="name" name="name" required="" type="text" value="{form/name}"/>
											</TD>
											<TD>必填。</TD>
										</TR>
										<TR>
											<TH class="must">
												<LABEL for="mofo">店家分類</LABEL>
											</TH>
											<TD>
												<SELECT id="mofo" name="mofo" required="">
													<OPTION value="-1">其它</OPTION>
													<OPTION value="1">食</OPTION>
													<OPTION value="2">衣</OPTION>
													<OPTION value="3">住</OPTION>
													<OPTION value="4">行</OPTION>
													<OPTION value="5">育</OPTION>
													<OPTION value="6">樂</OPTION>
												</SELECT>
											</TD>
											<TD>必選。</TD>
										</TR>
										<TR>
											<TD class="cF" colspan="3">
												<INPUT class="fL" type="reset" value="復原"/>
												<INPUT class="fR" type="submit" value="送出"/>
											</TD>
										</TR>
									</TABLE>
								</FIELDSET>
							</FORM>
						</TD>
					</TR>
				</TBODY>
			</TABLE>
			<HEADER class="cF">
				<DIV class="fL">
					<A href="/cPanel/">控制臺首頁</A>
					<SPAN>&#187;</SPAN>
					<A>新增店家</A>
				</DIV>
				<xsl:call-template name="topRite"/>
			</HEADER>
		</BODY>
	</xsl:template>

</xsl:stylesheet>