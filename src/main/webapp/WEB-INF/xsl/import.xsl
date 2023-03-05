<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output
		method="html"
		encoding="UTF-8"
		omit-xml-declaration="yes"
		indent="no"
		media-type="text/html"
	/>

	<!--下拉式選單群組-->
	<xsl:template match="optgroup">
		<OPTGROUP label="{@label}">
			<xsl:apply-templates/>
		</OPTGROUP>
	</xsl:template>

	<!--下拉式選單選項-->
	<xsl:template match="option">
		<OPTION value="{@value}">
			<xsl:if test="@selected">
				<xsl:attribute name="selected"/>
			</xsl:if>
			<xsl:value-of select="." disable-output-escaping="yes"/>
		</OPTION>
	</xsl:template>

	<!--前臺右上角-->
	<xsl:template name="header">
		<A id="home" href="/">
			<IMG alt="logo" src="/IMG/logo.png"/>
		</A>
		<UL class="cF">
			<xsl:if test="not(@remoteUser)">
				<LI>
					<A>
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="@me">/logOut.asp</xsl:when>
								<xsl:otherwise>/logIn.asp</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="@me">登出</xsl:when>
							<xsl:otherwise>登入</xsl:otherwise>
						</xsl:choose>
					</A>
				</LI>
				<LI>
					<B>&#124;</B>
				</LI>
				<LI>
					<A>
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="@me">/me.asp</xsl:when>
								<xsl:otherwise>/signUp.asp</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="@me">我的帳號</xsl:when>
							<xsl:otherwise>加入會員</xsl:otherwise>
						</xsl:choose>
					</A>
				</LI>
				<LI>
					<B>&#124;</B>
				</LI>
				<LI>
					<A href="/cart/">
						<SPAN>我的購物車</SPAN>
						<SPAN class="fa fa-shopping-cart fa-lg" id="shoppingCart">&#160;</SPAN>
						<xsl:if test="@cart">
							<SUP style="border-radius:8px;display:inline-block;width:16px;height:16px;color:#FFF;background-color:#08C;text-align:center">
								<xsl:value-of select="@cart"/>
							</SUP>
						</xsl:if>
					</A>
				</LI>
			</xsl:if>
		</UL>
		<DIV id="gcse">
			<xsl:element name="gcse:search" namespace="">
				<xsl:attribute name="linktarget">_self</xsl:attribute>
				<xsl:attribute name="enableautocomplete">true</xsl:attribute>
			</xsl:element>
		</DIV>
	</xsl:template>
	
	<!--前臺導覽工具列-->
	<xsl:template name="navigator">
		<DIV id="nav">
			<TABLE>
				<TR>
					<TD>
						<A>
							<xsl:choose>
								<xsl:when test="@requestURI='/'">
									<xsl:attribute name="class">current</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="href">/</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<SPAN>首頁</SPAN>
						</A>
					</TD>
					<TD>
						<B>&#124;</B>
					</TD>
					<TD>
						<A>
							<xsl:choose>
								<xsl:when test="@requestURI='/announcements.asp'">
									<xsl:attribute name="class">current</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="href">/announcements.asp</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<SPAN>最新消息</SPAN>
						</A>
					</TD>
					<TD>
						<B>&#124;</B>
					</TD>
					<TD>
						<A>
							<xsl:choose>
								<xsl:when test="@requestURI='/register.asp'">
									<xsl:attribute name="class">current</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="href">/register.asp</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<SPAN>線上招商</SPAN>
						</A>
					</TD>
					<TD>
						<B>&#124;</B>
					</TD>
					<TD>
						<A>
							<xsl:choose>
								<xsl:when test="@requestURI='/cPanel/'">
									<xsl:attribute name="class">current</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="href">/cPanel/</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<SPAN>店家登入</SPAN>
						</A>
					</TD>
					<TD>
						<B>&#124;</B>
					</TD>
					<TD>
						<A>
							<xsl:choose>
								<xsl:when test="@requestURI='/about.htm'">
									<xsl:attribute name="class">current</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="href">/about.htm</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<SPAN>關於我們</SPAN>
						</A>
					</TD>
					<TD>
						<B>&#124;</B>
					</TD>
					<TD>
						<A>
							<xsl:choose>
								<xsl:when test="@requestURI='/mofo/'">
									<xsl:attribute name="class">current</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="href">/mofo/</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<SPAN>店家分類</SPAN>
						</A>
					</TD>
					<TD>
						<B>&#124;</B>
					</TD>
					<TD>
						<A>
							<xsl:choose>
								<xsl:when test="@requestURI='/feedback.htm'">
									<xsl:attribute name="class">current</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="href">/feedback.htm</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<SPAN>意見回應</SPAN>
						</A>
					</TD>
					<TD>
						<B>&#124;</B>
					</TD>
					<TD>
						<A>
							<xsl:choose>
								<xsl:when test="@requestURI='/faq.htm'">
									<xsl:attribute name="class">current</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="href">/faq.htm</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<SPAN>常見問答</SPAN>
						</A>
					</TD>
					<TD>
						<B>&#124;</B>
					</TD>
					<TD>
						<A href="https://member.allpay.com.tw/MemberReg/ChooseMembership" target="_blank">店家金流註冊</A>
					</TD>
					<TD>
						<B>&#124;</B>
					</TD>
					<TD>
						<A href="http://store.anoch-info.com/?post_type=product" target="_blank">購物</A>
					</TD>
				</TR>
			</TABLE>
		</DIV>
	</xsl:template>

	<!--前臺底部-->
	<xsl:template name="footer">
		<DIV id="booths">
			<UL>
				<xsl:for-each select="booths/*">
					<LI title="{name}">
						<A href="/store/{id}/">
							<IMG alt="{name}" src="/logo/{id}.png"/>
						</A>
					</LI>
				</xsl:for-each>
			</UL>
		</DIV>
		<FOOTER>
			<DIV>
				<TABLE>
					<TR>
						<TD>
							<UL>
								<LI>
									<H3>易購物商城</H3>
								</LI>
								<LI>
									<ADDRESS>363 苗栗縣公館鄉中義村9鄰216-1號</ADDRESS>
								</LI>
								<LI>
									<ADDRESS>電話：(03)723-3178</ADDRESS>
								</LI>
								<LI>
									<ADDRESS>傳真：(03)723-2533</ADDRESS>
								</LI>
								<LI>
									<A style="border-bottom:1px solid" href="mailto:e95195@gmail.com">e95195@gmail.com</A>
								</LI>
							</UL>
						</TD>
						<TD>
							<UL>
								<LI>
									<H3>購物須知</H3>
								</LI>
								<LI>
									<A href="/privacy.htm">個人隱私權</A>
								</LI>
								<LI>
									<A href="/policy.htm">退換貨條款</A>
								</LI>
								<LI>
									<A href="/statement.htm">購物權利聲明</A>
								</LI>
							</UL>
						</TD>
						<TD>
							<UL>
								<LI>
									<H3>歡迎店家加入</H3>
								</LI>
								<LI>
									<A href="/register.asp">加入 e95 店家</A>
								</LI>
								<LI>
									<A href="javascript:void(0);" target="_blank">加入小農市集</A>
								</LI>
								<LI>
									<!--<A href="javascript:void(0)">店家分類</A>-->
									<A href="/mofo/">店家分類</A>
								</LI>
							</UL>
						</TD>
						<TH>
							<A style="color:#3664A2" href="https://www.facebook.com/E95%E6%98%93%E8%B3%BC%E7%89%A9%E5%95%86%E5%9F%8E-1558147357830570/" target="_blank">
								<IMG alt="FB-fLogo-Blue-printpackaging" src="/IMG/facebook.png"/>
							</A>
							<A style="color:#DC4E41" href="https://developers.google.com/+/branding-guidelines" target="_blank">
								<IMG alt="btn_google+_dark_normal_ios" src="/IMG/google%2B.png"/>
							</A>
							<IMG alt="QR-code" src="/IMG/qrCode.png"/>
						</TH>
					</TR>
				</TABLE>
			</DIV>
		</FOOTER>
		<DIV>
			<P class="textAlignCenter" style="cursor:default">網站所有權 &#169; 2016 易購物商城</P>
		</DIV>
	</xsl:template>

</xsl:stylesheet>