<?xml version="1.0" encoding="windows-1251"?>
<!-- Алгоритм формирования подписи – версия 0 -->
<!-- msg-type = "PaymentOrder" -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="rchumarin.com.functions"
    version="2.0">
    <xsl:output method="text" encoding="windows-1251" indent="no"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:function name="fn:printlnString" as="xs:string">
        <xsl:param name="reference" as="xs:string?"/>
        <xsl:sequence select="
            concat('STRING(', string-length($reference), '):', $reference, '&#13;&#10;')"/>
    </xsl:function>
    
    <xsl:function name="fn:printlnOther" as="xs:string">
        <xsl:param name="reference" as="xs:string?"/>
        <xsl:param name="type" as="xs:string"/>
        <xsl:variable name="len" select="string-length($reference)"/>
        <xsl:choose>
            <xsl:when test="$len = 0">
                <xsl:sequence select="concat('NULL ', $type, ':NULL&#13;&#10;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="concat($type, ':', $reference, '&#13;&#10;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
	
    <xsl:function name="fn:printlnDOUBLE" as="xs:string">
        <xsl:param name="reference" as="xs:string?"/>
        <xsl:variable name="len" select="string-length($reference)"/>
		<xsl:variable name="num" select="xs:double($reference)"/>
        <xsl:choose>
            <xsl:when test="$len = 0">
                <xsl:sequence select="concat('NULL ', 'DOUBLE', ':NULL&#13;&#10;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="concat('DOUBLE', ':', format-number($num ,'0.0000'), '&#13;&#10;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>    
	<xsl:function name="fn:printlnMONEY" as="xs:string">
        <xsl:param name="reference" as="xs:string?"/>
        <xsl:variable name="len" select="string-length($reference)"/>
		<xsl:variable name="num" select="xs:double($reference)"/>
        <xsl:choose>
            <xsl:when test="$len = 0">
                <xsl:sequence select="concat('NULL ', 'MONEY', ':NULL&#13;&#10;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="concat('MONEY', ':', format-number($num ,'0.0000'), '&#13;&#10;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="fn:printlnDate" as="xs:string">
        <xsl:param name="reference" as="xs:string?"/>
        <xsl:variable name="len" select="string-length($reference)"/>
        <xsl:choose>
            <xsl:when test="$len = 0">
                <xsl:sequence select="'NULL DOUBLE:NULL&#13;&#10;'"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Дата должна быть в стандартном формате xs:date YYYY-MM-DD !!! -->
                <xsl:variable name="date" select="xs:date($reference)"/>
                <xsl:sequence select="concat('DATE:', format-date($date, '[D01].[M01].[Y0001]'), '&#13;&#10;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:template match="/msg/object">
        <xsl:value-of select="fn:printlnDate(@DOC_DATE)"/>
        <xsl:value-of select="fn:printlnString(@DOC_NUMBER)"/>
		<!--xsl:value-of select="fn:printlnOther(@CUST_ID, 'INTEGER')"/-->
        <xsl:value-of select="fn:printlnOther(@CustId, 'INTEGER')"/>
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:value-of select="fn:printlnString(@CURRCODE)"/>
        <xsl:value-of select="fn:printlnString(@ORG_NAME)"/>
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:value-of select="fn:printlnString(@ORG_TAXCODE)"/>
        <xsl:value-of select="fn:printlnString(@ORG_KPP)"/>
        <xsl:value-of select="fn:printlnString(@ORG_ACCOUNT)"/>
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:value-of select="fn:printlnString(@ORG_BIC)"/>
        <xsl:value-of select="fn:printlnString(@ORG_CORACCOUNT)"/>
        <xsl:value-of select="fn:printlnString(@ORG_B_NAME)"/>
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:value-of select="fn:printlnString(@PAYERPLACE)"/>
		<xsl:value-of select="fn:printlnString(@PAYERPLACETYPE)"/>
        <!--xsl:text/>STRING(0):&#13;&#10;<xsl:text/-->
        <xsl:value-of select="fn:printlnString(@REC_NAME)"/>
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:value-of select="fn:printlnString(@REC_TAXCODE)"/>
        <xsl:value-of select="fn:printlnString(@REC_ACCOUNT)"/>
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:value-of select="fn:printlnString(@REC_BIC)"/>
        <xsl:value-of select="fn:printlnString(@REC_CORACCOUNT)"/>
        <xsl:value-of select="fn:printlnString(@REC_B_NAME)"/>
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:value-of select="fn:printlnString(@RECEIVERPLACE)"/>
        <xsl:value-of select="fn:printlnString(@RECEIVERPLACETYPE)"/>
        <xsl:value-of select="fn:printlnMONEY(@AMOUNT)"/>
        <xsl:value-of select="fn:printlnMONEY(@VAT)"/>
        <xsl:value-of select="fn:printlnString(@DESCRIPTION)"/>
        <xsl:value-of select="fn:printlnString(@QUEUE)"/>
        <!--xsl:text/>STRING(0):&#13;&#10;<xsl:text/-->
		<xsl:value-of select="fn:printlnDOUBLE(@someattribute)"/>
        <xsl:value-of select="fn:printlnString(@BANKOPER)"/>
        <xsl:value-of select="fn:printlnString(@PAYMENT_KIND)"/> <!-- здесь верно-->
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:value-of select="fn:printlnString(@REC_KPP)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_CREATOR)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_KBK)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_OKATO)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_BASIS)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_PERIOD1)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_PERIOD2)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_PERIOD3)"/>
        <xsl:text/>STRING(0):&#13;&#10;<xsl:text/>
        <xsl:value-of select="fn:printlnString(@CHARGE_NUM)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_DATE1)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_DATE2)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_DATE3)"/>
        <xsl:value-of select="fn:printlnString(@CHARGE_TYPE)"/>
        <xsl:value-of select="fn:printlnString(@UNIQ_KEY)"/>
		<xsl:value-of select="fn:printlnOther(@PAYKIND_CODE, 'INTEGER')"/>
		<xsl:value-of select="fn:printlnString(@CodeUIP)"/>
    </xsl:template>
</xsl:stylesheet>