<?xml version="1.0" encoding="windows-1251"?>
<!-- Алгоритм формирования подписи – версия 1 -->
<!-- msg-type = "CurConversion" -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="rchumarin.com.functions"
    version="2.0">
    <xsl:output method="text" encoding="windows-1251" indent="no"></xsl:output>    
    <xsl:strip-space elements="*"/>
	<xsl:variable name="ProcessNULLString" select="'1'" as="xs:string"/>
	<xsl:variable name="FloatPrecision" select="4" as="xs:integer"/>
	<xsl:variable name="MoneyPrecision" select="4" as="xs:integer"/>
	<xsl:variable name="CRLF" select="'&#13;&#10;'" as="xs:string"/>
	<xsl:variable name="spaces" select="'                                                                    '" />
	
	<xsl:variable name="vPict" select="'0000000000000000000000'"/>
	<xsl:variable name="mask" select="concat('0.', substring($vPict,1,$FloatPrecision))"/>
	<xsl:variable name="mask_money" select="concat('0.', substring($vPict,1,$MoneyPrecision))"/>
	
	<xsl:function name="fn:space" as="xs:string">
	<xsl:param name="count" as="xs:integer?"/>
		<xsl:sequence select="substring($spaces, 1, $count)"/>
	</xsl:function>
	<xsl:function name="fn:plainString" as="xs:string">
        <xsl:param name="reference" as="node()?"/>
		<xsl:variable name="val" select="$reference/string()" as="xs:string?"/>
		<xsl:variable name="referenceName"  select="name($reference)" as="xs:string"/>
		<xsl:sequence select="
            concat('&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;STRING&quot;&gt;',$val,'&lt;/Field&gt;')"/>
    </xsl:function>
	
   <xsl:function name="fn:printlnString" as="xs:string">
        <xsl:param name="reference" as="node()?"/>
		<xsl:param name="indent" as="xs:integer?"/>
		<xsl:variable name="val" select="$reference/string()" as="xs:string?"/>
		<xsl:variable name="referenceName"  select="name($reference)" as="xs:string"/>
		<xsl:variable name="len" select="string-length($reference)"/>
		<xsl:choose>
            <xsl:when test="($len = 0 and $ProcessNULLString !='1')">
                <xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;STRING&quot; NULL=&quot;true&quot;/&gt;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;STRING&quot;&gt;&lt;![CDATA[', $val,']]&gt;&lt;/Field&gt;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
	
	<!--xsl:function name="fn:printlnS" as="xs:string">
		<xsl:param name="root" as="node()"/>
        <xsl:param name="refer" as="xs:string"/>
		<xsl:variable name="refer1" as="xs:string" select="@DOCUMENTNUMBER"/>
		<xsl:variable  name="reference" select="$root/$refer1" as="node()"/>
		<xsl:variable name="val" select="$reference/string()" as="xs:string?"/>
		<xsl:sequence select="concat($CRLF,fn:space(2),$reference)"/-->
		<!--xsl:value-of select="$settingsNode/*[name() = $contentName]" /--> 
		
		<!--xsl:variable name="val" select="$reference/string()" as="xs:string?"/>
		<xsl:variable name="referenceName"  select="name($reference)" as="xs:string"/>
		<xsl:variable name="len" select="string-length($reference)"/>
		<xsl:choose>
            <xsl:when test="($len = 0 and $ProcessNULLString !='1')">
                <xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;STRING&quot; NULL=&quot;true&quot;/&gt;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;STRING&quot;&gt;&lt;![CDATA[', $val,']]&gt;&lt;/Field&gt;')"/>
            </xsl:otherwise>
        </xsl:choose-->
    <!--/xsl:function-->
	
	
	<xsl:function name="fn:printlnInteger" as="xs:string">
        <xsl:param name="reference" as="node()?"/>
		<xsl:param name="indent" as="xs:integer?"/>
		<xsl:variable name="referenceName"  select="upper-case(name($reference))" as="xs:string"/>
		<xsl:variable name="len" select="string-length($reference)"/>
		<xsl:choose>
            <xsl:when test="($len = 0)">
                <xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;INTEGER&quot; NULL=&quot;true&quot;/&gt;')"/>
            </xsl:when>
            <xsl:otherwise>
				<xsl:variable name="val" select="$reference/string()" as="xs:string?"/>
				<xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',$referenceName,'&quot; DataType=&quot;INTEGER&quot;&gt;', $val,'&lt;/Field&gt;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
	
	<xsl:function name="fn:printlnBoolean" as="xs:string">
	    <xsl:param name="reference" as="node()?"/>
		<xsl:param name="indent" as="xs:integer?"/>
		<xsl:variable name="referenceName"  select="upper-case(name($reference))" as="xs:string"/>
		<xsl:variable name="len" select="string-length($reference)"/>
		<xsl:choose>
            <xsl:when test="($len = 0)">
                <xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;BOOLEAN&quot; NULL=&quot;true&quot;/&gt;')"/>
            </xsl:when>
            <xsl:otherwise>
				<xsl:variable name="val" select="$reference/string()" as="xs:string?"/>
				<xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',$referenceName,'&quot; DataType=&quot;BOOLEAN&quot;&gt;', $val,'&lt;/Field&gt;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
	
	<xsl:function name="fn:printlnDouble" as="xs:string">
        <xsl:param name="reference" as="node()?"/>
		<xsl:param name="indent" as="xs:integer?"/>
		<xsl:variable name="referenceName"  select="upper-case(name($reference))" as="xs:string"/>
		<xsl:variable name="len" select="string-length($reference)"/>
		<xsl:choose>
            <xsl:when test="($len = 0)">
                <xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;DOUBLE&quot; NULL=&quot;true&quot;/&gt;')"/>
            </xsl:when>
            <xsl:otherwise>
				<xsl:variable name="num" select="xs:double($reference/string())"/>
				<xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',$referenceName,'&quot; DataType=&quot;DOUBLE&quot;&gt;', format-number($num ,$mask),'&lt;/Field&gt;')"/>    
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
	
	<xsl:function name="fn:printlnMoney" as="xs:string">
        <xsl:param name="reference" as="node()?"/>
		<xsl:param name="indent" as="xs:integer?"/>
		<xsl:variable name="referenceName"  select="upper-case(name($reference))" as="xs:string"/>
		<xsl:variable name="len" select="string-length($reference)"/>
		<xsl:choose>
            <xsl:when test="($len = 0)">
                <xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;MONEY&quot; NULL=&quot;true&quot;/&gt;')"/>
            </xsl:when>
            <xsl:otherwise>
				<xsl:variable name="num" select="xs:double($reference/string())"/>
				<xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',$referenceName,'&quot; DataType=&quot;MONEY&quot;&gt;', format-number($num ,$mask_money),'&lt;/Field&gt;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

	<xsl:function name="fn:printlnDate" as="xs:string">
        <xsl:param name="reference" as="node()?"/>
		<xsl:param name="indent" as="xs:integer?"/>
		<xsl:variable name="referenceName"  select="upper-case(name($reference))" as="xs:string"/>
		<xsl:variable name="len" select="string-length($reference)"/>
		<xsl:choose>
            <xsl:when test="($len = 0)">
                <xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;DATE&quot; NULL=&quot;true&quot;/&gt;')"/>
            </xsl:when>
            <xsl:otherwise>
				<xsl:variable name="date" select="xs:date($reference/string())"/>
				<xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',$referenceName,'&quot; DataType=&quot;DATE&quot;&gt;', format-date($date, '[D01].[M01].[Y0001]'),'&lt;/Field&gt;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
	
	<xsl:function name="fn:printlnDateTime" as="xs:string">
        <xsl:param name="reference" as="node()?"/>
		<xsl:param name="indent" as="xs:integer?"/>
		<xsl:variable name="referenceName"  select="upper-case(name($reference))" as="xs:string"/>
		<xsl:variable name="len" select="string-length($reference)"/>
		
		
		<xsl:choose>
            <xsl:when test="($len = 0)">
                <xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;DATETIME&quot; NULL=&quot;true&quot;/&gt;')"/>
            </xsl:when>
			<xsl:when test="($len &lt; 11)">
                <xsl:variable name="date" select="xs:date($reference/string())"/>
				<xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',$referenceName,'&quot; DataType=&quot;DATETIME&quot;&gt;', format-date($date, '[Y0001].[M01].[D01]:00:00:00.0000'),'&lt;/Field&gt;')"/>
            </xsl:when>
            <xsl:otherwise>
				<xsl:variable name="date" select="xs:dateTime($reference/string())"/>
				<!--xsl:variable name="date" select="xs:dateTime($reference/string())"/-->
				<xsl:sequence select="
            concat($CRLF,fn:space($indent),'&lt;Field FieldName=&quot;',$referenceName,'&quot; DataType=&quot;DATETIME&quot;&gt;', format-dateTime($date, '[Y0001].[M01].[D01]:[H01]:[m01]:[s01].[f0001]'),'&lt;/Field&gt;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
	
	<xsl:function name="fn:printBLOB" as="xs:string">
        <xsl:param name="reference" as="item()?"/>
		<xsl:variable name="referenceName" select="upper-case(name($reference))" as="xs:string"/>
		<xsl:variable name="len" select="count($reference/child::node())" as="xs:integer"/>
		<xsl:choose>
            <xsl:when test="($len = 0)">
                <xsl:sequence select="
            concat($CRLF,'&lt;Field FieldName=&quot;',upper-case($referenceName),'&quot; DataType=&quot;BLOBTABLE&quot; NULL=&quot;true&quot;/&gt;')"/>
            </xsl:when>
            <xsl:otherwise>
				<xsl:sequence select="
            concat($CRLF,'&lt;Field FieldName=&quot;',$referenceName,'&quot; DataType=&quot;BLOBTABLE&quot;&gt;', $CRLF,fn:space(2),'&lt;Records&gt;', fn:printBLOBRecord($reference),$CRLF,fn:space(2),'&lt;/Records&gt;' ,$CRLF,'&lt;/Field&gt;')"/>
            </xsl:otherwise>
        </xsl:choose>
   	</xsl:function>
		
	<xsl:function name="fn:printBLOBRecord" as="xs:string">
        <xsl:param name="reference" as="node()?"/>
		<!--xsl:variable name="referenceValue" select="$reference/string()" as="xs:string"/-->
		<!--xsl:param name="referenceName" as="xs:string?"/-->
		<xsl:variable name="v">
		<xsl:for-each select = "$reference/child::node()">
			<xsl:value-of select="fn:detailBLOBRecord(.)"/>
		</xsl:for-each>
		</xsl:variable>
		<xsl:sequence select="$v"/>
    	</xsl:function>
	<xsl:function name="fn:detailBLOBRecord" as="xs:string">
		<xsl:param name="reference" as="node()?"/>
		<xsl:sequence select="concat($CRLF,fn:space(3), '&lt;Record&gt;', 
		fn:printlnString($reference/@DOCUMENTTYPE,4),
		fn:printlnString($reference/@DOCUMENTNUMBER,4),
		fn:printlnDateTime($reference/@DOCUMENTDATE,4),
		fn:printlnDouble($reference/@AMOUNT,4),
		fn:printlnString($reference/@DESCRIPTION,4),
		$CRLF,fn:space(3),'&lt;/Record&gt;')"/>
		<!---->
		<!--xsl:value-of select="."/-->
	</xsl:function>
	
		
	<xsl:function name="fn:printAttachments" as="xs:string">
        <xsl:param name="reference" as="node()?"/>
		<!--xsl:variable name="referenceContent" select="$reference/text()"/-->
		<xsl:variable name="referenceContent" select="'lalala'"/>
		<xsl:variable name="referenceName" select="'DOCATTACHMENT'" as="xs:string"/>
        <xsl:sequence select="
            concat($CRLF,'&lt;Field FieldName=&quot;DOCATTACHMENT&quot; DataType=&quot;STRING&quot;&gt;&lt;![CDATA[',fn:printAttachmentRecord($reference),']]&gt;&lt;/Field&gt;')"/>
			
    	</xsl:function>
	
	<xsl:function name="fn:printAttachmentRecord" as="xs:string">
        <xsl:param name="reference" as="node()?"/>
		<xsl:variable name="v">
		<xsl:for-each select = "$reference/child::node()">
		<xsl:sort select="@SeqOrder"/>
			<xsl:value-of select="fn:detailAttachment(.)"/>
		</xsl:for-each>
		</xsl:variable>
		<xsl:sequence select="$v"/>
    	</xsl:function>	
		
	<xsl:function name="fn:detailAttachment" as="xs:string">
		<xsl:param name="reference" as="node()?"/>
		<xsl:sequence select="concat($CRLF,fn:space(3), '&lt;Attachment&gt;', 
		fn:plainString($reference/@FileName),
		fn:plainString($reference/@Value),
		fn:plainString($reference/@SmallIcon),
		fn:plainString($reference/@BigIcon),
		fn:plainString($reference/@SeqOrder),
		$CRLF,fn:space(3),'&lt;/Attachment&gt;')"/>
		<!---->
		<!--xsl:value-of select="."/-->
	</xsl:function>
	
    <xsl:template match="/">&lt;?xml version="1.0" encoding="windows-1251"?&gt;
&lt;Body&gt;<xsl:apply-templates/>
&lt;/Body&gt;
</xsl:template>
    <xsl:template match="/msg/object">
		<xsl:value-of select="concat(
		fn:printlnDate(@DOCUMENTDATE,0),
		fn:printlnString(@DOCUMENTNUMBER,0),
		fn:printlnInteger(@CUSTID,0),
                
                fn:printAttachments(/msg/ATTACHMENTS),
                
		fn:printlnString(@SENDEROFFICIALS,0),
		fn:printlnString(@CUSTOMERNAME,0),
		fn:printlnString(@CUSTOMERPROPERTYTYPE,0),
		fn:printlnString(@CUSTOMERINN,0),
		fn:printlnString(@CUSTOMEROKPO,0),
		fn:printlnString(@CUSTOMERPLACE,0),
		fn:printlnString(@CUSTOMERPLACETYPE,0),
		fn:printlnString(@CUSTOMERADDRESS,0),
		fn:printlnString(@CUSTOMERCOUNTRY,0),
		fn:printlnString(@ACCOUNTRUR,0),
		fn:printlnString(@ACCOUNTCURR,0),
		fn:printlnInteger(@CUSTOMERTYPE,0),
		fn:printlnString(@PHONEOFFICIAL,0),
		fn:printlnString(@FAXOFFICIAL,0),
		fn:printlnDouble(@REQUESTRATE,0),
		fn:printlnString(@ACCOUNTDEBET,0),
		fn:printlnString(@CURRCODEDEBET,0),
		fn:printlnMoney(@AMOUNTDEBET,0),
		fn:printlnString(@ACCOUNTCREDIT,0),
		fn:printlnString(@CURRCODECREDIT,0),
		fn:printlnMoney(@AMOUNTCREDIT,0),
		fn:printlnString(@DEBETBANKBIC,0),
		fn:printlnString(@DEBETBANKTYPE,0),
		fn:printlnString(@DEBETBANKNAME,0),
		fn:printlnString(@DEBETBANKPLACE,0),
		fn:printlnString(@DEBETBANKPLACETYPE,0),
		fn:printlnString(@CUSTOMERPLACE,0),
		fn:printlnString(@DEBETBANKCORRACC,0),
		fn:printlnString(@CREDITBANKBIC,0),
		fn:printlnString(@CREDITBANKTYPE,0),
		fn:printlnString(@CREDITBANKNAME,0),
		fn:printlnString(@CREDITBANKPLACE,0),
		fn:printlnString(@CREDITBANKCORRACC,0),
		fn:printlnString(@CREDITBANKPLACETYPE,0),
		fn:printlnDate(@VALIDITYPERIOD,0),
		fn:printlnString(@PAYMENTDETAILS,0),
		fn:printlnString(@CHARGEACCOUNT,0),
		fn:printlnString(@VALUEDATETYPE,0),
		fn:printBLOB(/msg/GROUNDRECEIPTSBLOBS),                				
                fn:printlnString(@CURRCODECHARGE,0),
		fn:printlnString(@OPERCODE,0),
		fn:printlnString(@OPERCODEDESCRIPTION,0),
		fn:printlnString(@CURRDEALINQUIRYNUMBER,0),
		fn:printlnDate(@CURRDEALINQUIRYDATE,0),
		fn:printlnString(@RESERVED,0),
		fn:printlnString(@RESERVED1,0),
		fn:printlnString(@DEALTYPE,0),
		fn:printlnInteger(@REQUESTRATETYPE,0),
		fn:printlnInteger(@CHARGETYPE,0),
		fn:printlnString(@SUPPLYCONDITION,0),
		fn:printlnDate(@SUPPLYCONDITIONDATE,0),
		fn:printlnString(@BANKAGREEMENT,0),
		fn:printlnString(@TRANSFERDOCUMENTNUMBER,0),
		fn:printlnDate(@TRANSFERDOCUMENTDATE,0),
		fn:printlnString(@DEPOINFO,0),
		fn:printlnString(@CREDITBANKSWIFT,0),
		fn:printlnString(@CreditBankNameInt,0),
		fn:printlnString(@CreditBankCountryCodeInt,0),
		fn:printlnString(@CreditBankPlaceInt,0),
		fn:printlnString(@CreditBankAdressInt,0),
		fn:printlnInteger(@CeditOurBank,0),
		fn:printlnString(@UNIQ_KEY,0))"/>
	</xsl:template>
</xsl:stylesheet>
