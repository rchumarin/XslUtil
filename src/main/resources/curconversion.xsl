<?xml version="1.0" encoding="windows-1251"?>
<!-- Алгоритм формирования подписи – версия 0 -->
<!-- msg-type = "CurConversion" -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="rchumarin.com.functions"
    version="2.0">
    <xsl:output method="text" encoding="windows-1251" indent="no" />
    
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
                <!-- Äàòà äîëæíà áûòü â ñòàíäàðòíîì ôîðìàòå xs:date YYYY-MM-DD !!! -->
                <xsl:variable name="date" select="xs:date($reference)"/>
                <xsl:sequence select="concat('DATE:', format-date($date, '[D01].[M01].[Y0001]'), '&#13;&#10;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>   
    <xsl:function name="fn:printlnDateTime" as="xs:string">
        <xsl:param name="reference" as="xs:string?"/>
        <xsl:variable name="len" select="string-length($reference)"/>
        <xsl:choose>
            <xsl:when test="$len = 0">
                <xsl:sequence select="'NULL DOUBLE:NULL&#13;&#10;'"/>
            </xsl:when>               
            <xsl:when test="($len &lt; 11)">
                <xsl:variable name="date" select="xs:date($reference)"/>
                <xsl:sequence select="
                concat('DATETIME:', format-date($date, '[Y0001].[M01].[D01]:00:00:00.0000'), '&#13;&#10;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="date" select="xs:dateTime($reference)"/>
                <xsl:sequence select="
                concat('DATETIME:', format-dateTime($date, '[Y0001].[M01].[D01]:[H01]:[m01]:[s01].[f0001]'), '&#13;&#10;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:strip-space elements="*"/>
    <xsl:variable name="CRLF" select="'&#13;&#10;'" as="xs:string"/>
    <xsl:variable name="spaces" select="'                                                                    '" />	

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
    
    <xsl:function name="fn:printAttachments" as="xs:string">
        <xsl:param name="reference" as="node()?"/>        
        <xsl:variable name="referenceContent" select="'lalala'"/>
        <xsl:variable name="referenceName" select="'DOCATTACHMENT'" as="xs:string"/>
        <xsl:sequence select="fn:printAttachmentRecord($reference)"/>        
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
        <xsl:sequence select="concat('&lt;Attachment&gt;', 
        fn:plainString($reference/@FileName),
        fn:plainString($reference/@Value),
        fn:plainString($reference/@SmallIcon),
        fn:plainString($reference/@BigIcon),
        fn:plainString($reference/@SeqOrder),
        '&lt;/Attachment&gt;', $CRLF)"/>
    </xsl:function>     

    <xsl:template match="/msg/object">
        <xsl:value-of select="fn:printlnString(@DOC_NUMBER)"/>        	
        <xsl:value-of select="fn:printlnDate(@DOCUMENTDATE)"/>	
        <xsl:value-of select="fn:printlnString(@DOCUMENTNUMBER)"/>        
        <xsl:value-of select="fn:printlnOther(@CUSTID, 'INTEGER')"/>              
        <xsl:value-of select="fn:printAttachments(/msg/ATTACHMENTS)"/>                
        <xsl:value-of select="fn:printlnString(@SENDEROFFICIALS)"/>
        <xsl:value-of select="fn:printlnString(@CUSTOMERNAME)"/>
        <xsl:value-of select="fn:printlnString(@CUSTOMERPROPERTYTYPE)"/>
        <xsl:value-of select="fn:printlnString(@CUSTOMERINN)"/>
        <xsl:value-of select="fn:printlnString(@CUSTOMEROKPO)"/>
        <xsl:value-of select="fn:printlnString(@CUSTOMERPLACE)"/>
        <xsl:value-of select="fn:printlnString(@CUSTOMERPLACETYPE)"/>
        <xsl:value-of select="fn:printlnString(@CUSTOMERADDRESS)"/>
        <xsl:value-of select="fn:printlnString(@CUSTOMERCOUNTRY)"/>
        <xsl:value-of select="fn:printlnString(@ACCOUNTRUR)"/>
        <xsl:value-of select="fn:printlnString(@ACCOUNTCURR)"/>        
        <xsl:value-of select="fn:printlnOther(@CUSTOMERTYPE, 'INTEGER')"/>                
        <xsl:value-of select="fn:printlnString(@PHONEOFFICIAL)"/>
        <xsl:value-of select="fn:printlnString(@FAXOFFICIAL)"/>        
        <xsl:value-of select="fn:printlnDOUBLE(@REQUESTRATE)"/>        
        <xsl:value-of select="fn:printlnString(@ACCOUNTDEBET)"/>
        <xsl:value-of select="fn:printlnString(@CURRCODEDEBET)"/>        
        <xsl:value-of select="fn:printlnMONEY(@AMOUNTDEBET)"/>        
        <xsl:value-of select="fn:printlnString(@ACCOUNTCREDIT)"/>
        <xsl:value-of select="fn:printlnString(@CURRCODECREDIT)"/>
        <xsl:value-of select="fn:printlnMONEY(@AMOUNTCREDIT)"/>        
        <xsl:value-of select="fn:printlnString(@DEBETBANKBIC)"/>
        <xsl:value-of select="fn:printlnString(@DEBETBANKTYPE)"/>
        <xsl:value-of select="fn:printlnString(@DEBETBANKNAME)"/>
        <xsl:value-of select="fn:printlnString(@DEBETBANKPLACE)"/>
        <xsl:value-of select="fn:printlnString(@DEBETBANKPLACETYPE)"/>
        <xsl:value-of select="fn:printlnString(@CUSTOMERPLACE)"/>
        <xsl:value-of select="fn:printlnString(@DEBETBANKCORRACC)"/>
        <xsl:value-of select="fn:printlnString(@CREDITBANKBIC)"/>
        <xsl:value-of select="fn:printlnString(@CREDITBANKTYPE)"/>
        <xsl:value-of select="fn:printlnString(@CREDITBANKNAME)"/>
        <xsl:value-of select="fn:printlnString(@CREDITBANKPLACE)"/>
        <xsl:value-of select="fn:printlnString(@CREDITBANKCORRACC)"/>
        <xsl:value-of select="fn:printlnString(@CREDITBANKPLACETYPE)"/>
        <xsl:value-of select="fn:printlnDate(@VALIDITYPERIOD)"/>        
        <xsl:value-of select="fn:printlnString(@PAYMENTDETAILS)"/>
        <xsl:value-of select="fn:printlnString(@CHARGEACCOUNT)"/>
        <xsl:value-of select="fn:printlnString(@VALUEDATETYPE)"/>        
        <xsl:value-of select="fn:printlnString(@CURRCODECHARGE)"/>
        <xsl:value-of select="fn:printlnString(@OPERCODE)"/>
        <xsl:value-of select="fn:printlnString(@OPERCODEDESCRIPTION)"/>
        <xsl:value-of select="fn:printlnString(@CURRDEALINQUIRYNUMBER)"/>        
        <xsl:value-of select="fn:printlnDate(@CURRDEALINQUIRYDATE)"/>        
        <xsl:value-of select="fn:printlnString(@RESERVED)"/>
        <xsl:value-of select="fn:printlnString(@RESERVED1)"/>
        <xsl:value-of select="fn:printlnString(@DEALTYPE)"/>        
        <xsl:value-of select="fn:printlnOther(@REQUESTRATETYPE, 'INTEGER')"/>
        <xsl:value-of select="fn:printlnOther(@CHARGETYPE, 'INTEGER')"/>
        <xsl:value-of select="fn:printlnString(@SUPPLYCONDITION)"/>                		        
        <xsl:value-of select="fn:printlnDate(@SUPPLYCONDITIONDATE)"/>        
        <xsl:value-of select="fn:printlnString(@BANKAGREEMENT)"/>                
        <xsl:value-of select="fn:printlnString(@TRANSFERDOCUMENTNUMBER)"/>        
        <xsl:value-of select="fn:printlnDate(@TRANSFERDOCUMENTDATE)"/>        
        <xsl:value-of select="fn:printlnString(@DEPOINFO)"/>
        <xsl:value-of select="fn:printlnString(@CREDITBANKSWIFT)"/>
        <xsl:value-of select="fn:printlnString(@CreditBankNameInt)"/>
        <xsl:value-of select="fn:printlnString(@CreditBankCountryCodeInt)"/>
        <xsl:value-of select="fn:printlnString(@CreditBankPlaceInt)"/>
        <xsl:value-of select="fn:printlnString(@CreditBankAdressInt)"/>       
        <xsl:value-of select="fn:printlnOther(@CeditOurBank, 'INTEGER')"/>        
        <xsl:value-of select="fn:printlnString(@UNIQ_KEY)"/>             
    </xsl:template>
    <xsl:template match="/msg/GROUNDRECEIPTSBLOBS">                          				        
        <xsl:value-of select="fn:printlnString(@DOCUMENTTYPE)"/>
        <xsl:value-of select="fn:printlnString(@DOCUMENTNUMBER)"/>        
        <xsl:value-of select="fn:printlnDate(@DOCUMENTDATE)"/>
        <xsl:value-of select="fn:printlnDOUBLE(@AMOUNT)"/>             
        <xsl:value-of select="fn:printlnString(@DESCRIPTION)"/>
    </xsl:template>
</xsl:stylesheet>
