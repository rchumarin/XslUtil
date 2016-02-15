Variables and other functions - версия 1
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


String – версия 0
Example: <xsl:value-of select="fn:printlnString(@DOC_NUMBER)"/>
Function:
<xsl:function name="fn:printlnString" as="xs:string">
    <xsl:param name="reference" as="xs:string?"/>
    <xsl:sequence select="concat('STRING(', string-length($reference), '):', $reference, '&#13;&#10;')"/>
</xsl:function>

String - версия 1
Example: <xsl:value-of select="concat(fn:printlnString(@DOCUMENTNUMBER,0))"/>
Function:
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

Date - версия 0
Example: <xsl:value-of select="fn:printlnDate(@DOC_DATE)"/>
Function:
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

Date - версия 1
Example: <xsl:value-of select="concat(fn:printlnDate(@DOCUMENTDATE,0))"/>
Function:
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

DateTime – версия 0
Example: <xsl:value-of select="fn:printlnDate(@DOC_DATETIME)"/>
Function:
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

DateTime - версия 1
Example: <xsl:value-of select="concat(fn:printlnDouble(@DateTime,0))"/>
Function:
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

Money – версия 0
Example: <xsl:value-of select="fn:printlnMONEY(@AMOUNT)"/>
Function:
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

Money - версия 1
Example: <xsl:value-of select="concat(fn:printlnMoney(@AMOUNTDEBET,0))"/>
Function: 
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

Integer - версия 0
Example: <xsl:value-of select="fn:printlnOther(@PAYKIND_CODE, 'INTEGER')"/>
Function:
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

Integer - версия 1
Example: <xsl:value-of select="concat(fn:printlnInteger(@CUSTID,0))"/>
Function:
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

Attachment - версия 0
Example: 
Function:

Attachment - версия 1
Example: <xsl:value-of select="concat(fn:printAttachments(/msg/ATTACHMENTS))"/>
Function: 
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

Blob - версия 0
Example: 
Function:

Blob - версия 1
Example: <xsl:value-of select="concat(fn:printBLOB(/msg/GROUNDRECEIPTSBLOBS))"/>
Function: 
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

Double – версия 0
Example: <xsl:value-of select="fn:printlnDOUBLE(@someattribute)"/>
Function:
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

Double - версия 1
Example: <xsl:value-of select="concat(fn:printlnDouble(@REQUESTRATE,0))"/>
Function:
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
	
===============================

Other example: <xsl:value-of select="math:sqrt(16)"  xmlns:math="java:java.lang.Math"/>


  

