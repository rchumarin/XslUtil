Обработка платежных документов. 

Суть проекта: имеются платежные документы (xml - файлы) содержащие различную платежную информацию, электронную подпись и записи-вложения. 

Из Java кода:
1) запускается saxon парсер, который обрабатывает xml и xsl файлы. Преобразование xml-файлов осуществляется по алгоритму формирования подписи (см. ниже), заданному в xsl-файлах. 
Поскольку записи-вложения полностью не преобразуются к нужному виду, то поэтому конечное преобразование осуществляется непосредственно с самом java-коде, а именно:
2) осуществляется чтение созданной строки, поиск в строке записей-вложений и их конечное преобразование в бинарный вид (Base64).

1. Алгоритм формирования подписи – версия 0.
Основные типы элементов xml-сообщения:
DATE – дата;
STRING – строка;
MONEY – число, с четырьмя знаками после разделителя;
INTEGER – число;
ATTACHMENT – вложения.
BLOBTABLE - вложенные таблицы 
DATETIME– дата и время;
DOUBLE– число, с четырьмя знаками после разделителя;

Формирование элемента блока данных для типа «DATE»:
<DATE:>+<DD.MM.YYYY>, например:
DATE:03.02.2010
Если значение элемента блока = Null, то блок данных =
NULL DOUBLE:NULL

Формирование элемента блока данных для типа «STRING»:
<STRING(>+<кол-во знаков в строке>+<):>+<данные строки>, например:
STRING(52):ОАО "НОВОКУЙБЫШЕВСКИЙ 22НЕФТЕПЕРЕРАБАТЫВАЮЩИЙ ЗАВОД"
Если значение элемента блока = Null, то блок данных =
STRING(0):

Формирование элемента блока данных для типа «MONEY»:
<MONEY:>+<данные>, например:
MONEY:12.5100
Если значение элемента блока = Null, то блок данных =
NULL MONEY:NULL

Формирование элемента блока данных для типа «DOUBLE»:
FLOAT:<Значение поля>
Если значение элемента блока = Null, то блок данных =
NULL DOUBLE:NULL

Формирование элемента блока данных для типа «DATETIME»:
DATETIME:<Дата>:<Время>
Примечание1: <Дата> - это дата из значения DateTime в формате dd.mm.yyyy. <Время> - это время из значения DateTime в формате hh:mm:ss.dddd.
Если значение элемента блока = Null, то блок данных =
NULL DATETIME:NULL

Формирование элемента блока данных для типа «INTEGER»:
<INTEGER:>+<данные>, например:
INTEGER:101212
Если значение элемента блока = Null, то блок данных =
NULL INTEGER:NULL

Формирование элемента блока данных для типа «LONGSTRING»:
<STRING(>+<кол-во знаков в строке>+<):>+<данные строки>, например:
STRING(52):ОАО "НОВОКУЙБЫШЕВСКИЙ 22НЕФТЕПЕРЕРАБАТЫВАЮЩИЙ ЗАВОД"
Если значение элемента блока = Null, то блок данных =
STRING(0):

Формат бинарного представления полей типа «ATTACHMENT».
Каждое поле типа ATTACHMENT представляет собой упорядоченный набор файлов вложений. Каждый файл вложение характеризуется следующими атрибутами:
Имя файла
Содержимое файл
Иконка 16x16 с изображением, соответствующим типу файла
Иконка 32x32 с изображением, соответствующим типу файла
Формат бинарного представления для несжатых вложений следующий:
<Бинарное представление>:=<Данные вложения 1><Данные вложения 2>…<Данные вложения N>
<Данные вложения>:=<Длина имени файла|4 байта><Имя файла><Длина содержимого иконки16х16|4 байта><Данные иконки 16x16><Длина содержимого иконки32х32|4 байта><Данные иконки 32x32><Длина содержимого файла|4 байта><Данные файла>

<STRING(>+<кол-во знаков в строке>+<):<Бинарное представление>
Если значение элемента блока = Null, то блок данных =
STRING(0):

Длина записыватся в виде четырех байт, так как целое число представляется 4-мя байтами. Запись проводится начиная с младшего байта и заканчивая старшим байтом.
Длина иконки, например, 12874, в шестнадцатеричном представлении выглядит как 324A. В поток будет записаны 4 байта:
4A, 32, 0, 0

Пример формирования блока данных для подписи Произвольного длокумента в Банк с полем типом ATTACHMENT:
DATE:23.06.2015
STRING(5):    2
INTEGER:1000002
STRING(0):
INTEGER:0
STRING(1135):####����.txt>#################(#######(####### ###########�#########################�##�###��#�###�#�#��##���#���###�##�###��#�###�#�#��##���##########x�����##�����##�����##�#���###�##�##��0�##π##�##� �##��##�##�����##�����##����###�����##����p##wwwww##�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�#########  ######�#######(### ###@#####################################�##�###��#�###�#�#��##���#���###�##�###��#�###�#�#��##���###################x������������###������������###������������###������������###������������###������������###������������###���##����#��###����##��##��###����@####��###������##�#��###������;�#��###����
;�#��###���#;##��###����#####��###����## #��###���##��" #��###����#	�" #��###����#�"##��###�����####���###������##����###������������###������������###������������###���������######����������####����������p####���������#####���������p#####���������######wwwwwwwwww####�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�###�##?�##�##�####12312312
�����������
����
STRING(5):�����
STRING(9):���������
STRING(1):1
INTEGER:1
INTEGER:2
STRING(5):53218 

2. Алгоритм формирования подписи – версия 1.
Данные для подписи представляют собой массив байт.  Для преобразования строки в массив байт должна использоваться кодировка "windows-1251".
1) Выводим текст «<?xml version="1.0" encoding="windows-1251"?>\r\n\<Body>\r\n».
2) Подписываемые поля выводятся в том порядке, как они объявлены в алгоритме ЭП.
3) В цикле по полям для подписи:
выводим один пробел, «<Field FieldName=», в кавычках (") название поля заглавными буквами (uppercase), один пробел, «DataType=», в кавычках тип поля (см. описание для конкретных типов полей ДБО), затем:
если значение поля не указано (для полей с типом STRING и BLOBTABLE также проверяется чтобы параметр "dbo.sign.ProcessNULLString" не был равен "1"), выводим один пробел, «NULL=\"true\"/>\r\n»
иначе, выводим «>», форматированное значение поля (см. описание для конкретных типов полей ДБО), «</Field>\r\n»
Например:
 <Field FieldName="REQUESTCONVRATE" DataType="DOUBLE">2.3700</Field>\r\n
4) Выводим «</Body>»

Пояснения для конкретных типов полей:
а) Поля с типом STRING выводятся следующим образом:
выводим «<![CDATA[», значение поля (причем вывод каждого байта со значением от 1 по 31 или вывод символа ‘#’ предваряется выводом символа ‘#’), выводим «]]>», например:
 <Field FieldName="BENEFBANKPLACE" DataType="STRING"><![CDATA[MOSCOW]]></Field>
Если значение поля не известно и "dbo.sign.ProcessNULLString" = “1”:
 <Field FieldName="BENEFBANKPLACE" DataType="STRING"><![CDATA[]]></Field>
Если значение поля не известно и "dbo.sign.ProcessNULLString" = “0”:
 <Field FieldName="BENEFBANKPLACE" DataType="STRING" NULL=”true”/>
б)  Поля с типом INTEGER выводятся следующим образом, например:
 <Field FieldName="ISMULTICURR" DataType="INTEGER">1</Field>
в) Поля с типом DOUBLE, форматируются в соответствии с параметром "dbo.sign.FloatPrecision", например:
 <Field FieldName="REQUESTCONVRATE" DataType="DOUBLE">2.3700</Field>
г) Поля с топом DATE, форматируются при выводе как "dd.MM.yyyy", например:
 <Field FieldName="DOCUMENTDATE" DataType="DATE">30.06.2011</Field>
д) Поля с типом DATETIME, форматируются при выводе как "yyyy.MM.dd':'HH:mm:ss.SSSS", например:
 <Field FieldName="TESTDATE" DataType="DATETIME">06.06.2011:00:00:00.0000</Field>
е) Поля с типом MONEY, форматируются в соответствии с параметром "dbo.sign.MoneyPrecision", например:
 <Field FieldName="AMOUNT" DataType="MONEY">50.1000</Field> 
ж) Поля с типом BOOLEAN, форматируется как true или false, например:
 <Field FieldName="BOOLFIELD" DataType="BOOLEAN">true</Field> 
 <Field FieldName="BOOLFIELD" DataType="BOOLEAN">false</Field> 
з)  Поля с типом BLOBTABLE.
Если имеются данные для вывода или параметр "dbo.sign.ProcessNULLString" равен “1” выводим:
«\r\n», два пробела, «<Records>\r\n», 
затем в цикле по строкам связанной таблицы выводим:
три пробела, «<Record>\r\n»
в цикле по полям связанной таблицы выводим:
три пробела, формируем данные по полю согласно пункту 3.3
три пробела, «</Record>\r\n»
два пробела, «</Records>\r\n»
один пробел
Приведем пример для преобразования GROUNDDOCUMENTS(15)[DOCNUMBER(0),DOCDATE(4),], когда таблица содержит две записи соотв. подписываемому документу:
 <Field FieldName="GROUNDDOCUMENTS" DataType="BLOBTABLE">
  <Records>
   <Record>
    <Field FieldName="DOCNUMBER" DataType="STRING"><![CDATA[121113]]></Field>
    <Field FieldName="DOCDATE" DataType="DATE">22.12.2011</Field>
   </Record>
   <Record>
    <Field FieldName="DOCNUMBER" DataType="STRING"><![CDATA[345-ВФ]]></Field>
    <Field FieldName="DOCDATE" DataType="DATE">23.12.2011</Field>
   </Record>
  </Records>
 </Field>
Если нет данных для вывода и параметр "dbo.sign.ProcessNULLString" равен “1” выводим:
 <Field FieldName="GROUNDDOCUMENTS" DataType="BLOBTABLE">
  <Records>
  </Records>
 </Field>
Если нет данных для вывода и параметр "dbo.sign.ProcessNULLString" не равен “1” выводим:
 <Field FieldName="GROUNDDOCUMENTS" DataType="BLOBTABLE" NULL=”true”/>

Для вложенных таблиц (тип BLOBTABLE) поля с типом MONEY и DATE данный для подписи формируются как DOUBLE и DATETIME соответственно.

Приведем пример для преобразования, когда вложенная таблица содержит две записи соответствующие подписываемому документу:

<Field FieldName="CONFDOCPSBLOB" DataType="BLOBTABLE">
  <Records>
   <Record>
    <Field FieldName="DOCDATE" DataType="DATETIME">02.05.2012:00:00:00.0000</Field>
    <Field FieldName="DOCCODE" DataType="STRING"><![CDATA[04]]></Field>
    <Field FieldName="DOCCUSTHOUSENUM" DataType="STRING"><![CDATA[]]></Field>
    <Field FieldName="CURRCODE1" DataType="STRING"><![CDATA[840]]></Field>
    <Field FieldName="AMOUNTCURRENCY1" DataType="DOUBLE">500.0000</Field>
    <Field FieldName="CURRCODE2" DataType="STRING"><![CDATA[]]></Field>
    <Field FieldName="AMOUNTCURRENCY2" DataType="DOUBLE" NULL="true"/>
    <Field FieldName="CORTABLE" DataType="STRING"><![CDATA[]]></Field>
    <Field FieldName="ADDINFO" DataType="STRING"><![CDATA[]]></Field>
   </Record>
  </Records>
</Field>

Если нет данных для вывода и параметр "dbo.sign.ProcessNULLString" равен “1” выводим:
 <Field FieldName="CONFDOCPSBLOB" DataType="BLOBTABLE">
  <Records>
  </Records>
 </Field>
Если нет данных для вывода и параметр "dbo.sign.ProcessNULLString" не равен “1” выводим:
 <Field FieldName="CONFDOCPSBLOB" DataType="BLOBTABLE" NULL=”true”/>


Исключение составляет вложенная таблица CONFDOCNOTPSBLOB в документе «Справка о подтверждающих документах» (ConfDocInquiry). Для этого объекта блок данных формируется:

<Field FieldName="CONFDOCNOTPSBLOB" DataType="BLOBTABLE" NULL="true"/>
 
и)  Поля с типом ATTACHMENT.
Поле с вложениями файлов  выводится как тип STRING выводится «<![CDATA[», значение поля (причем вывод каждого байта со значением от 0 по 31 или вывод символов ‘#’ и ‘]’ выводится в виде #XX –где XX – код символа в шестандцатиричном виде), выводится «]]>», в которое выводится бинарное представление вложений.
Каждое поле типа вложение представляет собой упорядоченный набор файлов вложений. Каждый файл вложение характеризуется следующими атрибутами:
1) Имя файла
2) Содержимое файл
3) Иконка 16x16 с изображением, соответствующим типу файла
4) Иконка 32x32 с изображением, соответствующим типу файла

Формат бинарного представления для вложений следующий:
<Данные вложения 1><Данные вложения 2>…<Данные вложения N>
<Данны вложения>:=<Длина имени файла|4 байта><Имя файла><Длина иконки 16x16|4 байта><Данные иконки 16x16><Длина иконки 32x32|4 байта><Данные иконки 32x32><Длина содержимого файла|4 байта><Данные файла>

Длина записыватся в виде четырех байт, так как целое число представляется 4-мя байтами. Запись проводится начиная с младшего байта и заканчивая старшим байтом.
Длина иконки, например, 12874, в шестнадцатеричном представлении выглядит как 324A. В поток будет записаны 4 байта:
4A, 32, 0, 0

Пример формирования блока данных для подписи документа – Справка о подтверждающих документах с полем типом ATTACHMENT: 
<?xml version="1.0" encoding="windows-1251"?>
<Body>
 <Field FieldName="DOCUMENTDATE" DataType="DATE">03.03.2015</Field>
 <Field FieldName="RESERV6" DataType="STRING"><![CDATA[]]></Field>
 <Field FieldName="DOCUMENTNUMBER" DataType="STRING"><![CDATA[2571]]></Field>
 <Field FieldName="ADDINFO" DataType="STRING"><![CDATA[]]></Field>
 <Field FieldName="CUSTID" DataType="INTEGER">1001</Field>
 <Field FieldName="DOCATTACHMENT" DataType="STRING"><![CDATA[#14#00#00#00043_v131122a.138.xls>#01#0000#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00������������#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00#00]]></Field>
 <Field FieldName="SENDEROFFICIALS" DataType="STRING"><![CDATA[������������� ���������� ������]]></Field>
 <Field FieldName="RESERV5" DataType="STRING"><![CDATA[]]></Field>
 <Field FieldName="BANKVKFULLNAME" DataType="STRING"><![CDATA[]]></Field>
 <Field FieldName="CUSTOMERBANKBIC" DataType="STRING"><![CDATA[046311763]]></Field>
 <Field FieldName="RESERV4" DataType="STRING"><![CDATA[]]></Field>
 <Field FieldName="CUSTOMERBANKNAME" DataType="STRING"><![CDATA[�-� ��� (���) � �.��������]]></Field>
 <Field FieldName="RESERV2" DataType="STRING"><![CDATA[]]></Field>
 <Field FieldName="RESERV3" DataType="STRING"><![CDATA[]]></Field>
 <Field FieldName="CUSTOMERINN" DataType="STRING"><![CDATA[224444223333]]></Field>
 <Field FieldName="CUSTOMERNAME" DataType="STRING"><![CDATA[��� "����-����"]]></Field>
 <Field FieldName="CUSTOMERPROPERTYTYPE" DataType="STRING"><![CDATA[���]]></Field>
 <Field FieldName="CUSTOMERTYPE" DataType="INTEGER">1</Field>
 <Field FieldName="CONFDOCPSBLOB" DataType="BLOBTABLE">
  <Records>
   <Record>
    <Field FieldName="ADDINFO" DataType="STRING"><![CDATA[987654]]></Field>
    <Field FieldName="AMOUNTCURRENCY1" DataType="DOUBLE">111.0000</Field>
    <Field FieldName="AMOUNTCURRENCY2" DataType="DOUBLE" NULL="true"/>
    <Field FieldName="AMOUNTCURRENCY11" DataType="DOUBLE" NULL="true"/>
    <Field FieldName="AMOUNTCURRENCY21" DataType="DOUBLE" NULL="true"/>
    <Field FieldName="COUNTRYCODE" DataType="STRING"><![CDATA[008]]></Field>
    <Field FieldName="CURRCODE1" DataType="STRING"><![CDATA[840]]></Field>
    <Field FieldName="CURRCODE2" DataType="STRING"><![CDATA[]]></Field>
    <Field FieldName="DOCCODE" DataType="STRING"><![CDATA[02_4]]></Field>
    <Field FieldName="DOCDATE" DataType="DATETIME">03.03.2015:00:00:00.0000</Field>
    <Field FieldName="DOCUMENTNUMBER" DataType="STRING"><![CDATA[1]]></Field>
    <Field FieldName="EXPECTDATE" DataType="DATETIME" NULL="true"/>
    <Field FieldName="NUM" DataType="INTEGER">1</Field>
    <Field FieldName="REMARK" DataType="STRING"><![CDATA[147852]]></Field>
    <Field FieldName="FDELIVERY" DataType="INTEGER">2</Field>
   </Record>
  </Records>
 </Field>
 <Field FieldName="CONFDOCNOTPSBLOB" DataType="BLOBTABLE" NULL="true"/>
 <Field FieldName="FCORRECTION" DataType="INTEGER">1</Field>
 <Field FieldName="KBOPID" DataType="INTEGER" NULL="true"/>
 <Field FieldName="PHONEOFFICIALS" DataType="STRING"><![CDATA[]]></Field>
</Body>
